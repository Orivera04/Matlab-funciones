/*
 * File: profile_utils.c
 *
 * Abstract: This file provides MPC555-specific utilities for execution profiling.
 *
 * $Revision: 1.1.6.3 $
 * $Date: 2004/04/19 01:25:54 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 */

#include <stdlib.h>
#include "mpc5xx.h"
#include "profile_utils.h"

/* See documentation in header file */
void profile_timer_enable() {
    USIU.TBSCRK.R = 0x55CCAA33; /* Unlock timebase status reg                */
    USIU.TBSCR.R  = 3;          /* Enable TB and decrementer                 */
    USIU.SCCR.R  |= 0x82000000; /* Select TB/DEC clock to sys clock/16       */
}
