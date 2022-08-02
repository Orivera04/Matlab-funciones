/*
 * File: profile_utils.h
 *
 * Abstract:
 *    Code for execution profiling.
 *
 *
 * $Revision: 1.1.6.3 $
 * $Date: 2004/04/19 01:18:52 $
 *
 * Copyright 2002-2004 The MathWorks, Inc.
 */

#ifndef _PROFILE_UTILS_H_
#define _PROFILE_UTILS_H_


/* Profiling identifiers. The values must be positive signed integers and must 
 * chosen not to conflict with the identifiers of timer based tasks 1:N
 */
#define PROFILING_ID_CAN_1_ISR 0x7FF0
#define PROFILING_ID_CAN_2_ISR 0x7FF1

#define PROFILING_ID_TWINCAN_A_ISR 0x7FF0
#define PROFILING_ID_TWINCAN_B_ISR 0x7FF1


#endif
