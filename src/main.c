#include "definitions.h"
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#define MCP9808_ADDR 0x1C
#define EEPROM_CONFIG_ADDR 0x000000
#define CONFIG_MAGIC 0x434F4E46

typedef struct __attribute__((packed)) {
  uint32_t magic;
  uint16_t perioda_mereni;
  uint16_t perioda_odesilani;
  char wifi_ssid[32];
  char wifi_pass[64];
  char mqtt_broker[64];
  uint16_t mqtt_port;
  uint32_t device_id;
  uint16_t crc;
} DeviceConfig_t;

static volatile bool rtc_alarm_fired = false;
static uint32_t system_uptime_sec = 0;

// Výpo?et CRC-16-CCITT pro ov??ení integrity konfigurace
static uint16_t CRC16(const uint8_t *data, size_t len) {
  uint16_t crc = 0xFFFF;
  for (size_t i = 0; i < len; i++) {
    crc ^= ((uint16_t)data[i] << 8);
    for (uint8_t b = 0; b < 8; b++) {
      crc = (crc & 0x8000) ? ((crc << 1) ^ 0x1021) : (crc << 1);
    }
  }
  return crc;
}

// OVLÁDÁNÍ SPI EEPROM 25CSM04
static inline void EEPROM_CS(bool enable) {
  if (enable) {
    PORT_PinClear(PORT_PIN_PA14);
  } else {
    PORT_PinSet(PORT_PIN_PA14);
  }
}

static void EEPROM_WaitBusy(void) {
  uint8_t cmd = 0x05; // RDSR
  uint8_t status;
  do {
    EEPROM_CS(true);
    SERCOM2_SPI_Write(&cmd, 1);
    while (SERCOM2_SPI_IsBusy())
      ;
    SERCOM2_SPI_Read(&status, 1);
    while (SERCOM2_SPI_IsBusy())
      ;
    EEPROM_CS(false);
  } while (status & 0x01); // Bit 0 = WIP
}

void EEPROM_Read(uint32_t addr, void *buf, size_t len) {
  uint8_t hdr[4] = {0x03, (uint8_t)(addr >> 16), (uint8_t)(addr >> 8),
                    (uint8_t)addr};
  EEPROM_WaitBusy();
  EEPROM_CS(true);
  SERCOM2_SPI_Write(hdr, 4);
  while (SERCOM2_SPI_IsBusy())
    ;
  SERCOM2_SPI_Read(buf, len);
  while (SERCOM2_SPI_IsBusy())
    ;
  EEPROM_CS(false);
}

void EEPROM_Write(uint32_t addr, const void *buf, size_t len) {
  uint8_t wren = 0x06;
  uint8_t hdr[4] = {0x02, (uint8_t)(addr >> 16), (uint8_t)(addr >> 8),
                    (uint8_t)addr};

  EEPROM_WaitBusy();

  // 1. Povolení zápisu (WREN)
  EEPROM_CS(true);
  SERCOM2_SPI_Write(&wren, 1);
  while (SERCOM2_SPI_IsBusy())
    ;
  EEPROM_CS(false);

  // 2. Samotný zápis dat
  EEPROM_CS(true);
  SERCOM2_SPI_Write(hdr, 4);
  while (SERCOM2_SPI_IsBusy())
    ;
  SERCOM2_SPI_Write((void *)buf, len);
  while (SERCOM2_SPI_IsBusy())
    ;
  EEPROM_CS(false);

  EEPROM_WaitBusy();
}

void Config_Init(DeviceConfig_t *cfg) {
  EEPROM_Read(EEPROM_CONFIG_ADDR, cfg, sizeof(DeviceConfig_t));
  uint16_t calculated_crc =
      CRC16((uint8_t *)cfg, sizeof(DeviceConfig_t) - sizeof(uint16_t));

  // Kontrola Magic wordu a kontrolního sou?tu CRC
  if (cfg->magic != CONFIG_MAGIC || cfg->crc != calculated_crc) {
    printf("[CFG] Neplatna konfigurace v EEPROM (CRC nesouhlasi). Ukladam "
           "default...\r\n");

    memset(cfg, 0, sizeof(DeviceConfig_t));
    cfg->magic = CONFIG_MAGIC;
    cfg->perioda_mereni = 15;
    cfg->perioda_odesilani = 60;
    strcpy(cfg->wifi_ssid, "IoT_Explorer_Net");
    strcpy(cfg->wifi_pass, "spseplzen123");
    strcpy(cfg->mqtt_broker, "192.168.1.100");
    cfg->mqtt_port = 1883;
    cfg->device_id = 0x00010048;
    cfg->crc = CRC16((uint8_t *)cfg, sizeof(DeviceConfig_t) - sizeof(uint16_t));

    // Zápis výchozích parametr? do EEPROM
    EEPROM_Write(EEPROM_CONFIG_ADDR, cfg, sizeof(DeviceConfig_t));
  } else {
    printf("[CFG] Nactena platna konfigurace (ID: 0x%08lX, Perioda: %u s, "
           "SSID: %s)\r\n",
           cfg->device_id, cfg->perioda_mereni, cfg->wifi_ssid);
  }
}

void MCP9808_Shutdown(bool shutdown) {
  uint8_t buf[3] = {0x01, shutdown ? 0x01 : 0x00,
                    0x00}; // Registr 0x01: Bit 8 = SHDN
  SERCOM0_I2C_Write(MCP9808_ADDR, buf, 3);
  while (SERCOM0_I2C_IsBusy())
    ;
}

int16_t MCP9808_ReadTemp(void) {
  uint8_t reg = 0x05;
  uint8_t data[2];

  SERCOM0_I2C_Write(MCP9808_ADDR, &reg, 1);
  while (SERCOM0_I2C_IsBusy())
    ;

  SERCOM0_I2C_Read(MCP9808_ADDR, data, 2);
  while (SERCOM0_I2C_IsBusy())
    ;

  uint16_t raw = (((uint16_t)data[0] << 8) | data[1]) & 0x1FFF;
  if (raw & 0x1000) {
    return (int16_t)(-((int32_t)(raw & 0x0FFF) * 100) / 16);
  }
  return (int16_t)(((int32_t)raw * 100) / 16);
}

// Callback p?eru?ení p?i dosa?ení Compare hodnoty v RTC
static void RTC_AlarmCallback(RTC_TIMER32_INT_MASK intCause,
                              uintptr_t context) {
  if (intCause & RTC_TIMER32_INT_MASK_CMP0) {
    rtc_alarm_fired = true;
  }
}

int main(void) {
  SYS_Initialize(NULL);
  EEPROM_CS(false);

  // Na?tení a ov??ení konfigurace z EEPROM
  DeviceConfig_t config;
  Config_Init(&config);

  // Nastavení RTC alarmu na periodu m??ení
  uint32_t rtc_freq = RTC_Timer32FrequencyGet();
  if (rtc_freq == 0) {
    rtc_freq = 1024;
  }
  uint32_t compare_ticks = (uint32_t)config.perioda_mereni * rtc_freq;

  RTC_Timer32CallbackRegister(RTC_AlarmCallback, (uintptr_t)NULL);
  RTC_Timer32CompareSet(compare_ticks);
  RTC_Timer32CounterSet(0);
  RTC_Timer32InterruptEnable(RTC_TIMER32_INT_MASK_CMP0);
  RTC_Timer32Start();

  printf("[RTC] Perioda probouzeni: %u s (%lu tiku pri %lu Hz)\r\n\r\n",
         config.perioda_mereni, compare_ticks, rtc_freq);

  while (1) {
    // Probudit senzor MCP9808 z Shutdown módu
    MCP9808_Shutdown(false);

    // Krátká pauza na dokon?ení p?evodu teploty senzoru (~250 ms)
    for (volatile uint32_t i = 0; i < 300000; i++)
      ;

    // Zm??it teplotu
    int16_t temp = MCP9808_ReadTemp();
    system_uptime_sec += config.perioda_mereni;
    printf("[MERENI] Cas: %lu s | Teplota: %d.%02d C\r\n", system_uptime_sec,
           temp / 100, (temp < 0 ? -temp : temp) % 100);

    // Uvést MCP9808 do Shutdown módu (proud senzoru < 1 uA)
    MCP9808_Shutdown(true);

    printf("[SPANEK] Prechod do Standby rezimu...\r\n");
    while (SERCOM1_USART_TransmitComplete() == false)
      ; // Vyprázdnit UART p?ed uspáním

    rtc_alarm_fired = false;
    PM_StandbyModeEnter(); // Hluboký spánek MCU (Standby)

    // Probuzení po vypr?ení periody RTC
    printf("[WAKEUP] MCU probuzeno RTC alarmem!\r\n");
  }
}