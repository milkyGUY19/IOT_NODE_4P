#include "definitions.h"
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#define MCP9808_ADDR 0x1C        // I2C adresa teplotniho senzoru
#define RB_MAGIC     0x52494E47  // "RING" - znacka platneho kruhoveho bufferu

// 1 = pri startu probehne test EEPROM a test kruhoveho bufferu
#define RUN_SELFTESTS 1

#define PERIODA_MERENI    15   // jak casto se meri teplota [s]
#define BTN_LONG_PRESS_MS 5000 // dlouhy stisk SW0 pro factory reset [ms]
#define ESP_RX_BUF_SIZE   256  // velikost bufferu pro prijem z ESP32-C6

// =====================================================================
// EEPROM 25CSM04 - prikazy a mapa pameti
// =====================================================================
#define EEPROM_SIZE      0x080000 // 4 Mbit = 512 KB
#define EEPROM_PAGE_SIZE 256      // zapis nesmi prekrocit hranici stranky

#define EEPROM_CMD_WREN  0x06 // povoleni zapisu
#define EEPROM_CMD_WRITE 0x02 // zapis
#define EEPROM_CMD_READ  0x03 // cteni
#define EEPROM_CMD_RDSR  0x05 // cteni status registru
#define EEPROM_SR_WIP    0x01 // bit "probiha zapis"

// Mapa pameti:
//   0x000000 - 0x0000FF  konfigurace zarizeni (device_config_t, 226 B)
//   0x000200 - 0x0002FF  oblast pro test kruhoveho bufferu
//   0x000300 - 0x0003FF  informace o kruhovem bufferu
//   0x000400 - 0x07FFFF  zaznamy mereni (kruhovy buffer)
#define EEPROM_CONFIG_ADDR 0x000000
#define EEPROM_TEST_ADDR   0x000200
#define RB_META_ADDR       0x000300
#define RB_DATA_ADDR       0x000400

// =====================================================================
// STRUKTURY
// =====================================================================

// Konfigurace zarizeni ulozena v EEPROM na adrese 0x0000.
// (Bez __attribute__((packed)) - uint16_t lezi na adrese 192, coz je sude
// cislo, takze kompilator mezi polozky nic nevklada. Velikost je 226 B.)
typedef struct
{
    char     wifi_ssid[32];      // nazev WiFi site na MikroTiku
    char     wifi_password[64];  // heslo k WiFi siti
    char     hostname[32];       // jmeno modulu v siti (DHCP)
    char     mqtt_server[64];    // IP adresa Mosquitto brokeru
    uint16_t mqtt_port;          // port (standardne 1883)
    char     mqtt_client_id[32]; // klientske ID (napr. "STUL_01")
} device_config_t;

// Jeden zaznam mereni (8 B)
typedef struct {
  uint32_t timestamp; // cas [s]
  int32_t teplota;    // teplota v setinach stupne (2534 = 25,34 C)
} Record_t;

// Informace o kruhovem bufferu (uklada se do EEPROM)
typedef struct {
  uint32_t magic;
  uint32_t capacity;   // kolik zaznamu se vejde
  uint32_t write_idx;  // sem se zapise dalsi zaznam
  uint32_t oldest_idx; // tady je nejstarsi zaznam
  uint32_t count;      // kolik zaznamu je ulozeno
  uint32_t unsent;     // kolik zaznamu jeste nebylo odeslano
  uint32_t crc;        // kontrolni soucet
} RingMeta_t;

// Kruhovy buffer v EEPROM
typedef struct {
  uint32_t meta_addr; // adresa informaci o bufferu
  uint32_t data_addr; // adresa prvniho zaznamu
  uint32_t capacity;  // kolik zaznamu se vejde
  RingMeta_t m;
} RingBuffer_t;

#define RB_CAPACITY ((EEPROM_SIZE - RB_DATA_ADDR) / sizeof(Record_t))

// =====================================================================
// GLOBALNI PROMENNE (mereni)
// =====================================================================
RingBuffer_t ring;       // kruhovy buffer s merenim
uint32_t system_uptime_sec = 0;

// "volatile", protoze se meni v preruseni
volatile bool rtc_alarm_fired = false;

// =====================================================================
// CRC-16 (kontrolni soucet dat)
// =====================================================================
uint16_t CRC16(uint8_t *data, uint32_t len) {
  uint16_t crc = 0xFFFF;
  for (uint32_t i = 0; i < len; i++) {
    crc = crc ^ (data[i] << 8);
    for (int b = 0; b < 8; b++) {
      if (crc & 0x8000) {
        crc = (crc << 1) ^ 0x1021;
      } else {
        crc = crc << 1;
      }
    }
  }
  return crc;
}

// =====================================================================
// OVLADAC EEPROM 25CSM04 (SPI = SERCOM2, CS = PA14)
// =====================================================================
void SPI_Write(void *data, uint32_t len) {
  SERCOM2_SPI_Write(data, len);
  while (SERCOM2_SPI_IsBusy())
    ;
}

void SPI_Read(void *data, uint32_t len) {
  SERCOM2_SPI_Read(data, len);
  while (SERCOM2_SPI_IsBusy())
    ;
}

uint8_t EEPROM_ReadStatus(void) {
  uint8_t cmd = EEPROM_CMD_RDSR;
  uint8_t status;

  EEPROM_CS_Clear();
  SPI_Write(&cmd, 1);
  SPI_Read(&status, 1);
  EEPROM_CS_Set();
  return status;
}

// Ceka, nez EEPROM dokonci zapis. Kdyz EEPROM neodpovida, vrati false.
bool EEPROM_WaitReady(void) {
  for (uint32_t i = 0; i < 50000; i++) {
    if ((EEPROM_ReadStatus() & EEPROM_SR_WIP) == 0) {
      return true;
    }
  }
  printf("[EEPROM] CHYBA: EEPROM neodpovida\r\n");
  return false;
}

bool eeprom_read(uint32_t addr, void *data, uint32_t len) {
  uint8_t cmd[4];
  cmd[0] = EEPROM_CMD_READ;
  cmd[1] = addr >> 16; // adresa ma 3 bajty
  cmd[2] = addr >> 8;
  cmd[3] = addr;

  if (!EEPROM_WaitReady()) {
    return false;
  }
  EEPROM_CS_Clear();
  SPI_Write(cmd, 4);
  SPI_Read(data, len);
  EEPROM_CS_Set();
  return true;
}

// Zapis do jedne stranky (nesmi prekrocit hranici 256 B)
bool EEPROM_WritePage(uint32_t addr, uint8_t *data, uint32_t len) {
  uint8_t wren = EEPROM_CMD_WREN;
  uint8_t cmd[4];
  cmd[0] = EEPROM_CMD_WRITE;
  cmd[1] = addr >> 16;
  cmd[2] = addr >> 8;
  cmd[3] = addr;

  if (!EEPROM_WaitReady()) {
    return false;
  }

  // 1. Povoleni zapisu
  EEPROM_CS_Clear();
  SPI_Write(&wren, 1);
  EEPROM_CS_Set();

  // 2. Zapis dat
  EEPROM_CS_Clear();
  SPI_Write(cmd, 4);
  SPI_Write(data, len);
  EEPROM_CS_Set();

  // 3. Pockat na dokonceni zapisu
  return EEPROM_WaitReady();
}

// Zapis libovolne delky - data se rozdeli po strankach
bool eeprom_write(uint32_t addr, void *data, uint32_t len) {
  uint8_t *p = (uint8_t *)data;

  while (len > 0) {
    // kolik bajtu jeste zbyva do konce aktualni stranky
    uint32_t chunk = EEPROM_PAGE_SIZE - (addr % EEPROM_PAGE_SIZE);
    if (chunk > len) {
      chunk = len;
    }
    if (!EEPROM_WritePage(addr, p, chunk)) {
      return false;
    }
    addr = addr + chunk;
    p = p + chunk;
    len = len - chunk;
  }
  return true;
}

// Test EEPROM: zapis 32 B pres hranici stranky a kontrolni precteni.
// Puvodni data se pred testem ulozi a po testu vrati zpet.
bool EEPROM_Test(void) {
  uint32_t addr = 0x07FEF0; // 16 B pred hranici stranky 0x07FF00
  uint8_t backup[32];
  uint8_t pattern[32];
  uint8_t readback[32];

  printf("[EEPROM] Status registr: 0x%02X\r\n", EEPROM_ReadStatus());

  for (int i = 0; i < 32; i++) {
    pattern[i] = i + 0xA0;
  }

  eeprom_read(addr, backup, 32);     // zaloha
  eeprom_write(addr, pattern, 32);   // zapis testovacich dat
  eeprom_read(addr, readback, 32);   // precteni
  eeprom_write(addr, backup, 32);    // vraceni puvodnich dat

  if (memcmp(pattern, readback, 32) == 0) {
    printf("[EEPROM] Test zapisu a cteni: OK\r\n");
    return true;
  }
  printf("[EEPROM] Test zapisu a cteni: CHYBA\r\n");
  return false;
}

// =====================================================================
// KRUHOVY BUFFER (RING BUFFER) V EEPROM
// =====================================================================

// Adresa zaznamu s danym indexem
uint32_t RB_SlotAddr(RingBuffer_t *rb, uint32_t idx) {
  return rb->data_addr + idx * sizeof(Record_t);
}

// Ulozeni informaci o bufferu do EEPROM (CRC se pocita s crc = 0)
bool RB_SaveMeta(RingBuffer_t *rb) {
  rb->m.crc = 0;
  rb->m.crc = CRC16((uint8_t *)&rb->m, sizeof(RingMeta_t));
  return eeprom_write(rb->meta_addr, &rb->m, sizeof(RingMeta_t));
}

// Kontrola, jestli jsou informace nactene z EEPROM platne
bool RB_MetaValid(RingBuffer_t *rb) {
  if (rb->m.magic != RB_MAGIC || rb->m.capacity != rb->capacity) {
    return false;
  }
  uint32_t saved = rb->m.crc;
  rb->m.crc = 0;
  uint16_t crc = CRC16((uint8_t *)&rb->m, sizeof(RingMeta_t));
  rb->m.crc = saved;
  return saved == crc;
}

// Vymazani bufferu (staci vynulovat informace, stara data se prepisou)
bool RB_Format(RingBuffer_t *rb) {
  memset(&rb->m, 0, sizeof(RingMeta_t));
  rb->m.magic = RB_MAGIC;
  rb->m.capacity = rb->capacity;
  return RB_SaveMeta(rb);
}

// Nacteni bufferu po startu. Kdyz jsou informace neplatne, buffer se vymaze.
bool RB_Init(RingBuffer_t *rb, uint32_t meta_addr, uint32_t data_addr,
             uint32_t capacity) {
  rb->meta_addr = meta_addr;
  rb->data_addr = data_addr;
  rb->capacity = capacity;

  eeprom_read(meta_addr, &rb->m, sizeof(RingMeta_t));
  if (RB_MetaValid(rb)) {
    return true;
  }
  return RB_Format(rb);
}

// Pridani zaznamu. Kdyz je buffer plny, prepise se nejstarsi zaznam.
bool RB_Push(RingBuffer_t *rb, Record_t *rec) {
  if (!eeprom_write(RB_SlotAddr(rb, rb->m.write_idx), rec, sizeof(Record_t))) {
    return false;
  }

  rb->m.write_idx++;
  if (rb->m.write_idx >= rb->capacity) {
    rb->m.write_idx = 0; // na konci zacit znovu od zacatku
  }

  if (rb->m.count < rb->capacity) {
    rb->m.count++;
  } else {
    // buffer je plny -> nejstarsi zaznam byl prepsan
    rb->m.oldest_idx++;
    if (rb->m.oldest_idx >= rb->capacity) {
      rb->m.oldest_idx = 0;
    }
  }

  if (rb->m.unsent < rb->capacity) {
    rb->m.unsent++;
  }
  return RB_SaveMeta(rb);
}

// Precteni i-teho zaznamu (0 = nejstarsi)
bool RB_ReadAt(RingBuffer_t *rb, uint32_t i, Record_t *rec) {
  if (i >= rb->m.count) {
    return false;
  }
  uint32_t idx = (rb->m.oldest_idx + i) % rb->capacity;
  return eeprom_read(RB_SlotAddr(rb, idx), rec, sizeof(Record_t));
}

// Precteni i-teho neodeslaneho zaznamu (0 = nejstarsi neodeslany)
bool RB_ReadUnsent(RingBuffer_t *rb, uint32_t i, Record_t *rec) {
  if (i >= rb->m.unsent) {
    return false;
  }
  return RB_ReadAt(rb, rb->m.count - rb->m.unsent + i, rec);
}

// Oznaceni n zaznamu jako odeslanych
bool RB_MarkSent(RingBuffer_t *rb, uint32_t n) {
  if (n > rb->m.unsent) {
    n = rb->m.unsent;
  }
  rb->m.unsent = rb->m.unsent - n;
  return RB_SaveMeta(rb);
}

// Test preteceni na malem bufferu (kapacita 5) v testovaci oblasti EEPROM
bool RB_Test(void) {
  RingBuffer_t t;
  Record_t r;
  int chyby = 0;

  RB_Init(&t, EEPROM_TEST_ADDR, EEPROM_TEST_ADDR + 0x20, 5);
  RB_Format(&t);

  // 8 zaznamu do bufferu pro 5 -> zaznamy 1, 2, 3 se prepisou
  for (uint32_t i = 1; i <= 8; i++) {
    r.timestamp = i;
    r.teplota = 2000 + i;
    RB_Push(&t, &r);
  }
  if (t.m.count != 5) chyby++;
  if (t.m.oldest_idx != 3) chyby++;

  // V bufferu musi byt zaznamy 4, 5, 6, 7, 8
  for (uint32_t i = 0; i < 5; i++) {
    RB_ReadAt(&t, i, &r);
    if (r.timestamp != 4 + i) chyby++;
  }

  // Po odeslani 2 zaznamu je prvni neodeslany zaznam 6
  RB_MarkSent(&t, 2);
  RB_ReadUnsent(&t, 0, &r);
  if (r.timestamp != 6) chyby++;

  // "Restart" - nacist buffer znovu z EEPROM, posledni zaznam musi byt 8
  RingBuffer_t t2;
  RB_Init(&t2, EEPROM_TEST_ADDR, EEPROM_TEST_ADDR + 0x20, 5);
  RB_ReadAt(&t2, 4, &r);
  if (r.timestamp != 8) chyby++;

  if (chyby == 0) {
    printf("[RB-TEST] Test preteceni bufferu: OK\r\n");
    return true;
  }
  printf("[RB-TEST] Test preteceni bufferu: %d chyb\r\n", chyby);
  return false;
}

// =====================================================================
// SENZOR MCP9808 (I2C = SERCOM0)
// =====================================================================
void MCP9808_Shutdown(bool shutdown) {
  uint8_t buf[3];
  buf[0] = 0x01; // registr CONFIG
  buf[1] = 0x00; // bit 8 = SHDN
  buf[2] = 0x00;
  if (shutdown) {
    buf[1] = 0x01;
  }
  SERCOM0_I2C_Write(MCP9808_ADDR, buf, 3);
  while (SERCOM0_I2C_IsBusy())
    ;
}

// Vraci teplotu v setinach stupne
int32_t MCP9808_ReadTemp(void) {
  uint8_t reg = 0x05; // registr teploty
  uint8_t data[2];

  SERCOM0_I2C_Write(MCP9808_ADDR, &reg, 1);
  while (SERCOM0_I2C_IsBusy())
    ;
  SERCOM0_I2C_Read(MCP9808_ADDR, data, 2);
  while (SERCOM0_I2C_IsBusy())
    ;

  int32_t raw = ((data[0] & 0x1F) << 8) | data[1];
  if (raw & 0x1000) {
    raw = raw - 0x2000; // zaporna teplota
  }
  return raw * 100 / 16; // 1 bit = 0,0625 C
}

// =====================================================================
// KONFIGURACE ZARIZENI
// =====================================================================

// Nacteni konfigurace z EEPROM (adresa 0x0000)
void config_load(device_config_t *cfg) {
  eeprom_read(EEPROM_CONFIG_ADDR, (uint8_t *)cfg, sizeof(device_config_t));
}

// Vypis nactene konfigurace do terminalu
void config_print(device_config_t *cfg) {
  printf("Konfigurace z EEPROM:\r\n");
  printf("  wifi_ssid      : %s\r\n", cfg->wifi_ssid);
  printf("  wifi_password  : %s\r\n", cfg->wifi_password);
  printf("  hostname       : %s\r\n", cfg->hostname);
  printf("  mqtt_server    : %s\r\n", cfg->mqtt_server);
  printf("  mqtt_port      : %u\r\n", cfg->mqtt_port);
  printf("  mqtt_client_id : %s\r\n", cfg->mqtt_client_id);
}

// =====================================================================
// 1. BLOK: PRIJEM Z ESP32-C6 (SERCOM4 z MCC, PB10 = TX, PB11 = RX)
// =====================================================================

// Kruhovy buffer pro data prijata z ESP32-C6
typedef struct {
  uint8_t *buffer;        // pole, kam se ukladaji znaky
  uint16_t size;          // velikost pole
  volatile uint16_t head; // sem se zapisuje (v preruseni)
  volatile uint16_t tail; // odsud se cte (v hlavni smycce)
} ring_buffer_t;

uint8_t esp_rx_raw_buffer[ESP_RX_BUF_SIZE];
ring_buffer_t esp_ring_buffer;
uint8_t esp_char; // sem MCC uklada prave prijaty znak

void ring_buffer_init(ring_buffer_t *rb, uint8_t *buffer, uint16_t size) {
  rb->buffer = buffer;
  rb->size = size;
  rb->head = 0;
  rb->tail = 0;
}

void ring_buffer_write(ring_buffer_t *rb, uint8_t c) {
  uint16_t next = rb->head + 1;
  if (next >= rb->size) {
    next = 0;
  }
  if (next != rb->tail) { // kdyz je buffer plny, znak se zahodi
    rb->buffer[rb->head] = c;
    rb->head = next;
  }
}

bool ring_buffer_read(ring_buffer_t *rb, uint8_t *c) {
  if (rb->tail == rb->head) {
    return false; // buffer je prazdny
  }
  *c = rb->buffer[rb->tail];
  rb->tail++;
  if (rb->tail >= rb->size) {
    rb->tail = 0;
  }
  return true;
}

// Callback obsluha UART RX (vola se automaticky pri prijmu 1 znaku)
void esp_rx_callback(uintptr_t context) {
  ring_buffer_write(&esp_ring_buffer, esp_char);
  SERCOM4_USART_Read(&esp_char, 1); // naplanovani prijmu dalsiho znaku
}

// Odeslani AT prikazu do ESP32-C6 (\r\n se prida automaticky)
void esp_send_command(char *cmd) {
  printf("[PIC->ESP] %s\r\n", cmd);

  SERCOM4_USART_Write(cmd, strlen(cmd));
  while (SERCOM4_USART_WriteIsBusy())
    ;
  SERCOM4_USART_Write("\r\n", 2);
  while (SERCOM4_USART_WriteIsBusy())
    ;
}

// =====================================================================
// 2. BLOK: PARSER ZNAK PO ZNAKU (esp_parser_FSM)
// =====================================================================

// Udalosti, ktere parser rozpozna
typedef enum
{
    ESP_EVENT_NONE = 0,
    ESP_EVENT_READY,          // Modul odeslal "ready\r\n" (ESP nastartovalo)
    ESP_EVENT_WIFI_CONNECTED, // Modul odeslal "WIFI CONNECTED\r\n"
    ESP_EVENT_WIFI_GOT_IP,    // Modul odeslal "WIFI GOT IP\r\n"
    ESP_EVENT_OK,             // Modul odeslal "OK\r\n"
    ESP_EVENT_ERROR           // Modul odeslal "ERROR\r\n" (chyba)
} esp_event_t;

// Stavy parseru
typedef enum {
  PARSER_CTENI_RADKU, // porovnavaji se znaky radku
  PARSER_CEKA_NA_LF   // prislo '\r', ceka se na '\n'
} parser_state_t;

// Zpravy, ktere se hledaji, a k nim patrici udalosti.
// "FAIL" posila ESP, kdyz se nepovede AT+CWJAP -> bere se jako chyba.
#define ESP_POCET_ZPRAV 6
char *esp_zpravy[ESP_POCET_ZPRAV] = {"ready", "WIFI CONNECTED", "WIFI GOT IP",
                                     "OK",    "ERROR",          "FAIL"};
esp_event_t esp_zpravy_eventy[ESP_POCET_ZPRAV] = {
    ESP_EVENT_READY, ESP_EVENT_WIFI_CONNECTED, ESP_EVENT_WIFI_GOT_IP,
    ESP_EVENT_OK,    ESP_EVENT_ERROR,          ESP_EVENT_ERROR};

// Vnitrni promenne parseru (musi si je pamatovat mezi volanimi)
parser_state_t parser_stav = PARSER_CTENI_RADKU;
uint16_t parser_idx = 0;                     // pozice znaku v radku
bool parser_neshoda[ESP_POCET_ZPRAV];        // true = zprava uz nesedi
esp_event_t parser_kandidat = ESP_EVENT_NONE; // shoda, ceka se na CRLF

// Zacatek noveho radku - vsechny zpravy jsou zase mozne
void parser_reset(void) {
  parser_stav = PARSER_CTENI_RADKU;
  parser_idx = 0;
  parser_kandidat = ESP_EVENT_NONE;
  for (int k = 0; k < ESP_POCET_ZPRAV; k++) {
    parser_neshoda[k] = false;
  }
}

// Nazev udalosti pro vypis do terminalu
char *esp_event_name(esp_event_t event) {
  switch (event) {
  case ESP_EVENT_READY:          return "ESP_EVENT_READY";
  case ESP_EVENT_WIFI_CONNECTED: return "ESP_EVENT_WIFI_CONNECTED";
  case ESP_EVENT_WIFI_GOT_IP:    return "ESP_EVENT_WIFI_GOT_IP";
  case ESP_EVENT_OK:             return "ESP_EVENT_OK";
  case ESP_EVENT_ERROR:          return "ESP_EVENT_ERROR";
  default:                       return "ESP_EVENT_NONE";
  }
}

// Cte znaky z kruhoveho bufferu po jednom a hleda zpravy od ESP.
// Udalost se vytvori az po prichodu "\r\n" za celou zpravou.
void esp_parser_FSM(ring_buffer_t *rb, esp_event_t *event) {
  uint8_t ch;

  while (ring_buffer_read(rb, &ch)) {
    printf("%c", ch); // vypis prijateho znaku do terminalu

    switch (parser_stav) {
    case PARSER_CTENI_RADKU:
      if (ch == '\r') {
        // Konec textu - sedi cely radek presne na nekterou zpravu?
        for (int k = 0; k < ESP_POCET_ZPRAV; k++) {
          if (parser_neshoda[k] == false && esp_zpravy[k][parser_idx] == '\0') {
            parser_kandidat = esp_zpravy_eventy[k];
          }
        }
        parser_stav = PARSER_CEKA_NA_LF;
      } else {
        // Porovnat znak se znakem na stejne pozici v kazde zprave
        for (int k = 0; k < ESP_POCET_ZPRAV; k++) {
          if (parser_neshoda[k] == false && esp_zpravy[k][parser_idx] != ch) {
            parser_neshoda[k] = true;
          }
        }
        if (parser_idx < 200) {
          parser_idx++;
        }
      }
      break;

    case PARSER_CEKA_NA_LF:
      if (ch == '\n' && parser_kandidat != ESP_EVENT_NONE) {
        // Kandidat se povysi na platnou udalost
        *event = parser_kandidat;
        printf("[EVENT] %s\r\n", esp_event_name(*event));
        parser_reset();
        return; // jedna udalost na jedno zavolani
      }
      parser_reset();
      break;
    }
  }
}

// =====================================================================
// 3. + 4. BLOK: NABEH A FACTORY RESET ESP (esp_reset_FSM)
// =====================================================================

// Stavy automatu
typedef enum {
  BOOT_WAIT_READY,       // ceka se na "ready"
  BOOT_WAIT_WIFI_CONN,   // ceka se na "WIFI CONNECTED"
  BOOT_WAIT_WIFI_GOT_IP, // ceka se na "WIFI GOT IP"
  STATE_READY,           // WiFi pripojena
  RESET_START,           // factory reset - poslat AT+CWMODE=1
  RESET_WAIT_MODE_OK,    // ceka se na OK, pak poslat AT+CWJAP
  RESET_WAIT_JAP         // ceka se na pripojeni k nove siti
} esp_reset_state_t;

esp_reset_state_t esp_reset_stav = BOOT_WAIT_READY;

void esp_reset_FSM(device_config_t *cfg, volatile uint8_t *btn_long_press_flag,
                   esp_event_t *event, bool *esp_state) {
  char cmd[128];

  // Dlouhy stisk SW0 -> factory reset (muze prijit v jakemkoliv stavu)
  if (*btn_long_press_flag == 1) {
    *btn_long_press_flag = 0;
    *esp_state = false;
    esp_reset_stav = RESET_START;
    printf("[RESET] Factory reset - nastavuji WiFi z EEPROM\r\n");
  }

  switch (esp_reset_stav) {
  // ----- Vetev A: bezny nabeh po zapnuti (zadne AT prikazy) -----
  case BOOT_WAIT_READY:
    if (*event == ESP_EVENT_READY) {
      esp_reset_stav = BOOT_WAIT_WIFI_CONN;
    }
    break;

  case BOOT_WAIT_WIFI_CONN:
    if (*event == ESP_EVENT_WIFI_CONNECTED) {
      esp_reset_stav = BOOT_WAIT_WIFI_GOT_IP;
    }
    break;

  case BOOT_WAIT_WIFI_GOT_IP:
    if (*event == ESP_EVENT_WIFI_GOT_IP) {
      *esp_state = true;
      esp_reset_stav = STATE_READY;
      printf("[ESP] WiFi pripojena (esp_state = true)\r\n");
    }
    break;

  case STATE_READY:
    *esp_state = true; // jen se ceka na pripadny stisk SW0
    break;

  // ----- Vetev B: factory reset tlacitkem SW0 -----
  case RESET_START:
    *esp_state = false;
    esp_send_command("AT+CWMODE=1");
    esp_reset_stav = RESET_WAIT_MODE_OK;
    break;

  case RESET_WAIT_MODE_OK:
    if (*event == ESP_EVENT_OK) {
      // Sestaveni AT+CWJAP="SSID","PASS" z udaju z EEPROM
      sprintf(cmd, "AT+CWJAP=\"%s\",\"%s\"", cfg->wifi_ssid,
              cfg->wifi_password);
      esp_send_command(cmd);
      esp_reset_stav = RESET_WAIT_JAP;
    } else if (*event == ESP_EVENT_ERROR) {
      printf("[RESET] AT+CWMODE=1 selhal, zkus znovu podrzet SW0\r\n");
      esp_reset_stav = BOOT_WAIT_WIFI_CONN;
    }
    break;

  case RESET_WAIT_JAP:
    if (*event == ESP_EVENT_WIFI_GOT_IP || *event == ESP_EVENT_OK) {
      *esp_state = true;
      esp_reset_stav = STATE_READY;
      printf("[ESP] Nova sit ulozena, WiFi pripojena (esp_state = true)\r\n");
    } else if (*event == ESP_EVENT_ERROR) {
      printf("[RESET] Pripojeni se nezdarilo, zkus znovu podrzet SW0\r\n");
      esp_reset_stav = BOOT_WAIT_WIFI_CONN;
    }
    break;
  }
}

// =====================================================================
// TLACITKO SW0 (BTN, PA27) - detekce dlouheho stisku
// =====================================================================
uint8_t btn_klid = 0;    // uroven pinu, kdyz tlacitko neni stisknute
uint32_t btn_cas_ms = 0; // jak dlouho je tlacitko drzene [ms]

void button_init(void) {
  // Tlacitko se cte v hlavni smycce, preruseni od EIC neni potreba
  EIC_InterruptDisable(EIC_PIN_15);
  PORT_PinInputEnable(BTN_PIN); // povolit cteni pinu pres BTN_Get()

  // Pri startu tlacitko nikdo nedrzi -> zapamatovat si klidovou uroven
  btn_klid = BTN_Get();
}

// Vola se kazdou 1 ms. Po 5 s drzeni nastavi priznak dlouheho stisku.
void button_check(volatile uint8_t *btn_long_press_flag) {
  if (BTN_Get() != btn_klid) {
    if (btn_cas_ms < BTN_LONG_PRESS_MS) {
      btn_cas_ms++;
      if (btn_cas_ms == BTN_LONG_PRESS_MS) {
        *btn_long_press_flag = 1;
        printf("[BTN] SW0 drzeno 5 s\r\n");
      }
    }
  } else {
    btn_cas_ms = 0; // tlacitko pusteno
  }
}

// =====================================================================
// MERENI TEPLOTY (aplikace)
// =====================================================================

// Zavola se v preruseni, kdyz RTC dopocita do nastavene hodnoty
void RTC_AlarmCallback(RTC_TIMER32_INT_MASK intCause, uintptr_t context) {
  if (intCause & RTC_TIMER32_INT_MASK_CMP0) {
    rtc_alarm_fired = true;
  }
}

// Nastaveni RTC, aby kazdych PERIODA_MERENI sekund nastavil rtc_alarm_fired
void rtc_init(void) {
  uint32_t compare_ticks = PERIODA_MERENI * RTC_Timer32FrequencyGet();

  RTC_Timer32Stop();
  RTC_Timer32CallbackRegister(RTC_AlarmCallback, 0);
  RTC_Timer32CompareSet(compare_ticks);
  RTC_Timer32CounterSet(0);
  RTC_Timer32InterruptEnable(RTC_TIMER32_INT_MASK_CMP0);
  RTC_Timer32Start();
}

// Zmereni teploty a ulozeni do kruhoveho bufferu v EEPROM
void measure_and_store(void) {
  // Probudit senzor a pockat na prevod (~250 ms)
  MCP9808_Shutdown(false);
  SYSTICK_DelayMs(250);

  int32_t temp = MCP9808_ReadTemp();
  system_uptime_sec = system_uptime_sec + PERIODA_MERENI;

  MCP9808_Shutdown(true); // uspat senzor (odber < 1 uA)

  int32_t cela = temp / 100;
  int32_t setiny = temp % 100;
  if (setiny < 0) {
    setiny = -setiny;
  }
  printf("[MERENI] Cas: %lu s | Teplota: %ld.%02ld C\r\n", system_uptime_sec,
         cela, setiny);

  Record_t rec;
  rec.timestamp = system_uptime_sec;
  rec.teplota = temp;
  if (RB_Push(&ring, &rec)) {
    printf("[RB] Ulozeno (zapis=%lu, nejstarsi=%lu, neodeslano=%lu)\r\n",
           ring.m.write_idx, ring.m.oldest_idx, ring.m.unsent);
  } else {
    printf("[RB] CHYBA zapisu do EEPROM!\r\n");
  }
}

// Aplikace - bezi jen tehdy, kdyz je WiFi pripojena (esp_state == true).
// esp_event se zatim nepouziva (bude potreba pro MQTT v pristim cviceni).
void app_run_FSM(bool *esp_state, esp_event_t *esp_event) {
  if (*esp_state == false) {
    return;
  }
  if (rtc_alarm_fired) {
    rtc_alarm_fired = false;
    RTC_Timer32CounterSet(0); // RTC zacne pocitat dalsi periodu od nuly
    measure_and_store();
  }
}

// =====================================================================
// MAIN
// =====================================================================
int main(void) {
  SYS_Initialize(NULL);
  EEPROM_CS_Set();      // EEPROM neaktivni
  SYSTICK_TimerStart(); // bez spusteni SysTicku nefunguje SYSTICK_DelayMs

  // Prijem z ESP spustit hned na zacatku, aby se neztratilo "ready",
  // ktere ESP posle chvili po zapnuti napajeni
  ring_buffer_init(&esp_ring_buffer, esp_rx_raw_buffer, ESP_RX_BUF_SIZE);
  SERCOM4_USART_ReadCallbackRegister(esp_rx_callback, (uintptr_t)NULL);
  SERCOM4_USART_Read(&esp_char, 1);

  printf("\r\n[START] IOT_NODE_4P spusteno\r\n");

  if (RUN_SELFTESTS) {
    EEPROM_Test();
    RB_Test();
  }

  // Obnova konfigurace v EEPROM - jednorazove odkomentovat, nahrat, pak zase
  // zakomentovat:
  /*
  device_config_t default_cfg = {
      .wifi_ssid = "Loading...",
      .wifi_password = "abcd1234",
      .hostname = "PIC32_STUL_01",
      .mqtt_server = "192.168.10.5",
      .mqtt_port = 1883,
      .mqtt_client_id = "STUL_01"
  };
  eeprom_write(0x0000, (uint8_t *)&default_cfg, sizeof(default_cfg));
  */

  device_config_t dev_cfg;
  config_load(&dev_cfg); // nacte nastaveni z EEPROM
  config_print(&dev_cfg);

  // Nacteni kruhoveho bufferu s merenim
  RB_Init(&ring, RB_META_ADDR, RB_DATA_ADDR, RB_CAPACITY);
  if (ring.m.count > 0) {
    // pokracovat v case od posledniho ulozeneho zaznamu
    Record_t last;
    RB_ReadAt(&ring, ring.m.count - 1, &last);
    system_uptime_sec = last.timestamp;
  }

  rtc_init();
  button_init();

  // Lokalni stavove promenne (zadne globalni promenne!):
  esp_event_t esp_event = ESP_EVENT_NONE;
  bool esp_state = false; // true = ESP ready, false = probiha nabeh
  volatile uint8_t btn_long_press_flag = 0;

  printf("Cekam na nabeh ESP32-C6 (ready -> WIFI CONNECTED -> WIFI GOT IP)\r\n");

  while (1) {
    // 1. Parser: prevod znaku z bufferu na udalosti
    esp_parser_FSM(&esp_ring_buffer, &esp_event);

    // 2. Detekce dlouheho stisku tlacitka SW0
    button_check(&btn_long_press_flag);

    // 3. Rizeni nabehu pri zapnuti i po tovarnim resetu tlacitkem SW0
    esp_reset_FSM(&dev_cfg, &btn_long_press_flag, &esp_event, &esp_state);

    // 4. Aplikacni smycka (bezi jen pokud esp_state == true)
    app_run_FSM(&esp_state, &esp_event);

    // 5. Vynulovani zpracovane udalosti
    esp_event = ESP_EVENT_NONE;

    SYSTICK_DelayMs(1); // jedna smycka = cca 1 ms (pro mereni stisku SW0)
  }
}
