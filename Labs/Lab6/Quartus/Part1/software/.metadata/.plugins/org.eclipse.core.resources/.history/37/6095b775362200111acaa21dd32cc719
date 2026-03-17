#include "io.h"
#include <stdio.h>
#include "system.h"
#include "alt_types.h"
#include "sys/alt_irq.h"

typedef signed char    sint8;
typedef unsigned char  uint8;
typedef signed short   sint16;
typedef unsigned short uint16;
typedef signed long    sint32;
typedef unsigned long  uint32;
typedef         float  real32;

#define ram_size 0x4000
#define data_32 0x12345678

//pointers
uint8  *pushbutton_ptr = (uint8*)PUSHBUTTON_BASE;
uint8  *leds_ptr       = (uint8*)LEDS_BASE;
uint32 *ram_ptr        = (uint32*)INFERRED_RAM_BASE;


void ram_test_uint32(uint32 * start_ptr, uint32 size, uint32 data){
	*leds_ptr = 0xFF;

	size = size/4;
	for(int i = 0; i < size; i++)
	{
		start_ptr[i] = data;
	}

	for(int i = 0; i < size/4; i++)
	{
		if(start_ptr[i] != data)
		{
			*leds_ptr = 0x00;
		}
	}
}

void ram_test_uint16(uint32 * start_ptr, uint32 size, uint16 data){
	*leds_ptr = 0xFF;

	size = size/2;
	for(int i = 0; i < size; i++)
	{
		start_ptr[i] = data;
	}

	for(int i = 0; i < (size/2); i++)
	{
		if(start_ptr[i] != data)
		{
			*leds_ptr = 0x00;
		}
	}
}

void ram_test_uint8(uint32 * start_ptr, uint32 size, uint8 data){
	*leds_ptr = 0xFF;

	for(int i = 0; i < size; i++)
	{
		start_ptr[i] = data;
	}

	for(int i = 0; i < size; i++)
	{
		if(start_ptr[i] != data)
		{
			*leds_ptr = 0x00;
		}
	}
}

int main(void)
{

	*leds_ptr = 0x00;
    while (1)
    {
    	ram_test_uint32((uint32*)ram_ptr,(uint32)ram_size,(uint32)0x12345678);
    	//ram_test_uint16((uint16*)ram_ptr,(uint32)ram_size,(uint16)data_32);
    	//ram_test_uint8 ((uint8 *)ram_ptr,(uint32)ram_size,(uint8 )data_32);
    }

    return 0;
}
