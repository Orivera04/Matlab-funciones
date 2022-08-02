/*
 * File: tb.c
 *
 * Abstract:
 *    Utility for programming the timebase.
 *
 * $Revision: 1.9.4.2 $
 * $Date: 2004/04/19 01:25:58 $
 *
 * Copyright 2001-2003 The MathWorks, Inc.
 */

#include "mpc5xx.h"
#include "stdlib.h"
#include "tb.h"


void TBInit(void)
{
/* Enable timebase/decrementer  */
    USIU.TBSCRK.R = 0x55CCAA33; /* Unlock timebase status reg                */
    USIU.TBSCR.R  = 3;          /* Enable TB and decrementer                 */
    USIU.SCCR.R  |= 0x82000000; /* Select TB/DEC clock to sys clock/16       */
}



