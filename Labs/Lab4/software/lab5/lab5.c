#include "io.h"
#include <stdio.h>
#include "system.h"
#include "alt_types.h"
#include "sys/alt_irq.h"

// typedef
typedef signed char   sint8;
typedef unsigned char uint8;
typedef signed short  sint16;
typedef unsigned short uint16;
typedef signed long   sint32;
typedef unsigned long uint32;

//pointers
uint32* hex0_ptr = (uint32*)HEX0_BASE;
uint32* hex1_ptr = (uint32*)HEX1_BASE;
uint32* hex2_ptr = (uint32*)HEX2_BASE;
uint32* hex4_ptr = (uint32*)HEX4_BASE;
uint32* hex5_ptr = (uint32*)HEX5_BASE;
uint32* pushbutton_ptr = (uint32*)PUSHBUTTONS_BASE;
uint32* switch_ptr = (uint32*)SWITCHES_BASE;
uint32* servo_ptr = (uint32*)SERVO_CONTROLLER_0_BASE;

unsigned int currentMin = 45;
unsigned int currentMax = 135;

uint8 switchVal;

// hexValues
int hexVal[] = {0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x02, 0x78, 0x00, 0x10};

void key1_isr(void* context) {

    uint32 buttons = *pushbutton_ptr;

    switchVal = *switch_ptr;

    if((buttons & 0x08) == 0) {
        if((switchVal >= 45) && (switchVal <= 99)){
            currentMin = switchVal;

            *hex5_ptr = hexVal[switchVal / 10];
            *hex4_ptr = hexVal[switchVal % 10];
        }
    }
    *(pushbutton_ptr + 2) = 0x0C;

    if((buttons & 0x04) == 0) {
        if((switchVal >= 45) && (switchVal <= 135)){
            currentMax = switchVal;

            *hex2_ptr = hexVal[switchVal / 100];
            *hex1_ptr = hexVal[(switchVal/10) % 10];
            *hex0_ptr = hexVal[switchVal % 10];
        }
    }

    *(pushbutton_ptr + 3) = 0x0C;
}

void servo_isr(void* context){
    uint32 pulseMin = (currentMin*(50000/90))+25000;
    uint32 pulseMax = (currentMax*(50000/90))+25000;
    *(servo_ptr + 0) = pulseMin;
    *(servo_ptr + 1) = pulseMax;
}

int main(void){

    *hex2_ptr = hexVal[1];      // hundreds digit: 1
    *hex1_ptr = hexVal[3];      // tens digit: 3
    *hex0_ptr = hexVal[5];      // ones digit: 5

    *hex5_ptr = hexVal[4];      // tens digit: 4
    *hex4_ptr = hexVal[5];      // ones digit: 5

    *(pushbutton_ptr + 2) = 0x0C;
    *(pushbutton_ptr + 3) = 0x0C;
    alt_ic_isr_register(PUSHBUTTONS_IRQ_INTERRUPT_CONTROLLER_ID, PUSHBUTTONS_IRQ, key1_isr, 0, 0);


    alt_ic_isr_register(SERVO_CONTROLLER_0_IRQ_INTERRUPT_CONTROLLER_ID, SERVO_CONTROLLER_0_IRQ, servo_isr, 0, 0);

    while(1){}
    return 0;

}
