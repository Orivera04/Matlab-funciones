/*
 * File: tb.h
 *
 * Abstract:
 *    Include file for time base functions
 *
 *
 * $Revision: 1.9.4.1 $
 * $Date: 2004/04/19 01:25:43 $
 *
 * Copyright 2001-2002 The MathWorks, Inc.
 */

#ifndef _TB_H
#define _TB_H

/* With sysclk = 40 MHz the timer counts at 40MHz/16, i.e. 1 count
 * is 400 ns
 */

/* To calculate time in convenient units of 100 ns use the following
 *
 *

   elapsedTime = readTBL();

   .... do some calculations ...

   elapsedTime = (readTBL() - elapsedTime) * TB_TICK

  *
  */
#define TB_TICK 4 /* 1 tick is 4 x (100 ns) i.e. measure in units of 100 ns */

/* To use the timer TBInit() must be called during initialization in order to start
 * the timebase running 
 */
void TBInit(void);


/*******************************************************************************
FUNCTION    : readTBL
PURPOSE     : Return TIME BASE value
INPUT NOTES : 
RETURN NOTES    : 32-bit counter value: clocked at 40 MHz / 16
                  i.e. 400 ns per count
GENERAL NOTES   : 
*******************************************************************************/
asm UINT32 readTBL()
{
    mfspr   r3, TBL
#ifdef __MWERKS__
    blr;
#endif
}



#endif




