/*
 * File : run_app.c
 *
 * Abstract:
 * 	Functions to jump to start of application in RAM or Flash
 *
 * $Revision: 1.1.6.2 $
 * $Date: 2004/04/19 01:25:07 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 */
#include "run_app.h"

void run_app_from_flash(){
   /* Reset any IO used in the bootcode,
    * and jump to the application in Internal Flash */
   SHUTDOWN_CAN;
   /* Disable SCI 1 */
   qsmcm_sci1_disable();
   FLASH_START();
}

void run_app_from_ram(){
	/* Reset any IO used in the bootcode,
    * and jump to the application in External RAM */
	SHUTDOWN_CAN;
   /* Disable SCI 1 */
   qsmcm_sci1_disable();
   RAM_START();
}
