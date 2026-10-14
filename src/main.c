#include <stddef.h>                     // Defines NULL
#include <stdbool.h>                    // Defines true
#include <stdlib.h>                     // Defines EXIT_FAILURE
#include "definitions.h"                // SYS function prototypes

#define MCP9808 0x1C

bool i2c_write (uint16_t address, uint8_t *data, uint8_t size){
    SERCOM0_I2C_Write(address, data, size);
    while(SERCOM0_I2C_IsBusy());
    return !SERCOM0_I2C_ErrorGet();
}

bool i2c_read (uint16_t address, uint8_t *data, uint8_t size){
    SERCOM0_I2C_Read(address, data, size);
    while(SERCOM0_I2C_IsBusy());
    return !SERCOM0_I2C_ErrorGet();
}

bool mcp9808_write_reg (uint8_t reg, uint16_t data){
    uint8_t _d[3] = {reg, data >> 8, data};
    return i2c_write(0x1C, _d, 3);
}

bool mcp9808_read_reg (uint8_t reg, uint8_t *data){
    bool _s = i2c_write(0x1C, &reg, 1);
    if(!_s) return false;
    return i2c_read(0x1C, data, 2);
}

bool mcp9808_read_temp (float *temperature){
    
    uint8_t _d[2];
    bool _s = mcp9808_read_reg(0x05, _d);
    if(!_s) return false;
    
    *temperature = (((uint16_t)(_d[0] & 0x0F) << 8) | _d[1]) / 16.0;
    
    if(_d[0] & 0b00010000 == 1)
        *temperature = *temperature * (-1.0);
    
    return true;
}

int main ( void )
{
    
    SYS_Initialize ( NULL );

    while ( true )
    {
        SYS_Tasks ( );
        
        float temperature;
        
        if(mcp9808_read_temp(&temperature))
        {
            printf("temperature: %.03f\r\n", temperature);
        }
        
        SYSTICK_DelayMs(500);
    }

    return ( EXIT_FAILURE );
}