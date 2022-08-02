/*
 * File : main.c
 *
 * Abstract :
 * 	Main file for the internal flash test
 *
 *
 * $Revision: 1.1.4.1 $
 * $Date: 2003/07/31 18:07:21 $
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
	int i;
	MIOS1.MPIOSM32DDR.R = ~0;
	while(1){
		SERVICE_WATCHDOG_TIMER;
		for(i=0; i< 500000;i++);
		MIOS1.MPIOSM32DR.R = ~(MIOS1.MPIOSM32DR.R);
	}
		
}
