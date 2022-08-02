/*
 * File: main.c
 *
 * Abstract:
 *    Simple main for use with test build. This program is designed to flash the
 *    LED D3 on the Phytec phyCORE-167 evaluation board.
 *
 *
 * $Revision: 1.1.6.1 $
 * $Date: 2004/04/08 20:57:07 $
 *
 * Copyright 2004 The MathWorks, Inc.
 */

/* Trap numbers used for timer task */
#define T3_TRAP                     0x23

/*
 * System timer interrupt control register:
 *    Interrupt priority level = 7
 *    Interrupt group level = 0
 */
#define SYSTEM_TIMER_IC                 0x5c

/*
 * Using timer T3 to generate interrupts at the model base sample rate 
 *
 * Sample period                          = 1.0 seconds
 * Calculations based on System Frequency = 20000000 Hz
 */
#define TIMER_RELOAD                    0x9897

/* 
 * Initial value for system timer control register T3CON
 *    Prescaler field:  T3I  = 6 
 *    Mode Control:     T3M  = 0
 *    Up/down field:    T3UD = 1 
 *    Reload:           automatically from T2
 */
#define SYSTEM_TIMER_CON                0xc6


#include <reg167cs.h>


void main(void)
{
    unsigned long i = 0;

    DP2 = 0x0001;             /* initialize LED pin for output     */

    /* Configure automatic reload of system timer, T3, from reload timer, T2 */
    T2 = TIMER_RELOAD;
    T2CON = 0x0027;

    /* Initialize the system timer initial value, control register,
     * and interrupts */
    T3 = TIMER_RELOAD;
    T3CON = SYSTEM_TIMER_CON;
    T3IC = SYSTEM_TIMER_IC;
    
    /* Enable interrupts */
    IEN=1;
 
    /* Background loop runs forever */
    while (1);
}

/* LED state variable */
int ledState = 0;

_interrupt (T3_TRAP) void step( void ) {
    
    if (ledState == 1) {
        ledState = 0;
        P2 |= 0x0001;
    } else {
        ledState = 1;
        P2 &= 0xFFFE;
    }
}
