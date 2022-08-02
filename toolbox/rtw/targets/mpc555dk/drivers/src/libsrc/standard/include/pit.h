/*
 * File: pit.h
 *
 * Abstract:
 *    PIT module API
 *
 *
 * $Revision: 1.9.4.2 $
 * $Date: 2004/04/19 01:25:40 $
 *
 * Copyright 2001-2003 The MathWorks, Inc.
 */

#ifndef _PIT_H
#define _PIT_H

#include "isr.h"
#include "mpc5xx.h"


/*----------------------------------------------
 * Shorthand macros
 * --------------------------------------------*/

// Enable / Disable the counter
#define EnablePit 				USIU.PISCR.B.PTE = 1 
#define DisablePit 				USIU.PISCR.B.PTE = 0 


// Enable / Disable freezing the clock on debugging
#define EnablePitFreeze		  	USIU.PISCR.B.PITF = 1
#define DisablePitFreeze	  	USIU.PISCR.B.PITF = 0

// Enable / Disable the interrupt on clock timeout
#define EnablePitInterrupt		USIU.PISCR.B.PIE = 1
#define DisablePitInterrupt	USIU.PISCR.B.PIE = 0

// Call this in the ISR to clear the Interrupt flag
#define ClearPitIRQ				USIU.PISCR.B.PS = 1


// Use this macro to determine the minimum PIT period
#define MIN_PIT_PERIOD(extClkFreq)  (1 + 1)/((extClkFreq)/ \
                        (USIU.SCCR.B.RTDIV ? 256.0 : 4.0 ))

// Use this macro to determine the maximum PIT period
#define MAX_PIT_PERIOD(extClkFreq)  (0xFFFF + 1)/((extClkFreq)/ \
                        (USIU.SCCR.B.RTDIV ? 256.0 : 4.0 ))


/*------------------------------------------------------------
 * Function
 *
 *   setPitModuleIrqLevel  
 *
 * Purpose
 *
 *   Sets the interrupt level of the module in terms of
 *   the MPC555_IRQ_LEVEL. Note the PIT is an internal
 *   device and only can provide internal level 0-7.
 *
 * Arguments
 *
 *    level - INT_LEVEL0
 *            INT_LEVEL1
 *            INT_LEVEL2
 *            INT_LEVEL3
 *            INT_LEVEL4
 *            INT_LEVEL5
 *            INT_LEVEL6
 *            INT_LEVEL7 
 *
 *            any other values give undefined results.
 *
 *----------------------------------------------------------*/
void setPitModuleIrqLevel(MPC555_IRQ_LEVEL level);



/*------------------------------------------------------------
 * Function
 *
 *   setPitPeriod  
 *
 * Purpose
 *
 *   Set the timeout period of the PIT
 *
 * Arguments
 *
 *   period			-		The period in seconds.
 *   extClkFreq 	-		The frequency of the external clock or osscilator. This is
 *   							usually 4Hhz or 20Mhz
 *
 * Example
 * 	setPitPeriod(0.01,20000000);
 *
 * Returns
 *
 *   The achieved period of the timer. Note that because this
 *   is a digital system arbitrary timeout periods can't be 
 *   achieved. If the period was out of range then
 *
 *   -1
 *
 *   will be returned else the approximation achieved will
 *   be returned.
 *
 *   Essentlially the period is a division of the 
 *   external clock which can be calculated via.
 *
 *   period = ( PITC + 1 ) / (extClkFreq / ( 4 or 256 ) )
 *
 *   The value 4 or 256 is determined by the flag USIU.SCCR.B.RTDIV. If it 
 *   is zero then the divisor is 4 else the divisor is 256.
 *
 *   See section 6.9 in the RCPU manual Rev 1 June 2000 and
 *       table   8-9 in the same manual for details on setting
 *       the PIT. 
 *----------------------------------------------------------*/
float setPitPeriod(float period,long extClkFreq);




#endif
