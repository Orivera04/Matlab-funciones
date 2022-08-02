/*
 * File : main.c
 *
 * Abstract :
 *
 *    Main file to be used by the external ram test file
 *
 * Disclaimers / restrictions if any.
 *
 * $Revision: 1.2.4.2 $
 * $Date: 2004/04/19 01:25:16 $
 *
 * Copyright 1990-2003 The MathWorks, Inc.
 */

#include "mpc5xx.h"

#ifndef MPC555_VARIANT
#define MIOS1 MIOS14
#endif

/*==================================*
 * Macros used by this module 
 *==================================*/
#define SERVICE_WATCHDOG_TIMER \
   USIU.SWSR.R = 0x556C; \
   USIU.SWSR.R = 0xAA39; 

void main(){
	volatile int i;
	MIOS1.MPIOSM32DDR.R = ~0;
	while(1){
		SERVICE_WATCHDOG_TIMER;
		for(i=0; i< 200000;i++);
		MIOS1.MPIOSM32DR.R = ~(MIOS1.MPIOSM32DR.R);
	}
		
}
