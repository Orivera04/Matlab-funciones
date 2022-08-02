/*
 * File: profile_utils.h
 *
 * Abstract: Header file for MPC555-specific utilities for execution profiling
 *
 * $Revision: 1.1.6.2 $
 * $Date: 2003/07/31 18:08:21 $
 *
 * Copyright 2003 The MathWorks, Inc.
 */

#ifndef _PROFILE_UTILS_H
#define _PROFILE_UTILS_H

#include <stdlib.h>
#include "mpc5xx.h"


/* Profiling identifiers. The values must be positive signed integers and must 
 * chosen not to conflict with the identifiers of timer based tasks 1:N
 */
#define PROFILING_ID_CAN_ISR    0x7FFFFFF0
#define PROFILING_ID_TPU_ISR    0x7FFFFFE0
#define PROFILING_ID_QSMCM_ISR  0x7FFFFFD0

/*******************************************************************************
 * Assembler macro    : profileReadTimer
 * 
 * Purpose :  Read value of decrementer register.  The decrementer is a 32-bit *
 *            counter value: clocked at SysClock / 16 i.e. 400 ns per count at
 *            40 MHz or * 800 ns per count at 20 MHz
 * 
 * Inputs:
 *    None.
 *
 * Returns:
 *
 *    Current value of the decrementer register.
 *
 ******************************************************************************/
asm UINT32 profileReadTimer()
{
    mfdec   r3;
#ifdef __MWERKS__
    blr;
#endif

}

/*
 * Function: profile_timer_enable
 * 
 * Purpose:  Initialize timer used for execution profiling.
 *
 * Inputs:   none
 * 
 * Returns:  none
 */
void profile_timer_enable();


#endif
