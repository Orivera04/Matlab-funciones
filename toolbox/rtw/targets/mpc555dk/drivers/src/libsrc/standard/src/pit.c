/*
 * File: pit.c
 *
 * Abstract:
 *    Implements some programmable interrupt timer
 *    functionality.
 *
 *
 * $Revision: 1.10.4.2 $
 * $Date: 2004/04/19 01:25:53 $
 *
 * Copyright 2001-2003 The MathWorks, Inc.
 */

#include <stdlib.h>
#include "pit.h"

void setPitModuleIrqLevel(MPC555_IRQ_LEVEL level){
  /* PIRQ is a bit mask for the IRQ level.
     The MSB represents IRQ_LEVEL0. */ 
	USIU.PISCR.B.PIRQ = 128 >> (level >> 1);
	
} 


#define EX_CLK_DIV   
float setPitPeriod(float period, long extClkFreq){
	int pitc;
   int ex_clk_div;

   // Calculate the external clock division based on RTDIV
   ex_clk_div = (USIU.SCCR.B.RTDIV ? 256.0 : 4.0 ) ;

   // Calculate the reload value for PITC
	pitc = (int) ( period * ( extClkFreq / ex_clk_div ) ) - 1;

   // PITC is only a 16 bit number so if it is out of range or
   // zero return an error.
	if ( pitc > 0xFFFF || pitc < 0 ){
		return -1.0;
	}

   // Load the register
	USIU.PITC.B.PITC = pitc;

   // Return the period acheived
	return (pitc+1)/(extClkFreq / ex_clk_div );
} 

