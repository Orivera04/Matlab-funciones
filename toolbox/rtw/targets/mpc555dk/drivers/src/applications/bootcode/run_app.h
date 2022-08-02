/*
 * File : run_app.h
 *
 * Abstract :
 * 
 * Functions to jump to start of application in RAM or Flash
 *
 *	Copyright 2003-2004 The MathWorks, Inc.
 *
 * $Revision: 1.1.6.4 $
 * $Date: 2004/04/19 01:25:08 $ 
*/

#ifndef _RUN_APP_H
#define _RUN_APP_H

#include "simple_can_driver.h" 
#include "serial_boot.h"
#include "run_app.h"
#include "memlayout.h"  /* Import memory layout symbols */

typedef void(*function)(void);

/* Define where Flash applications start
 *
 * Start of application area of Flash
 * 
 */
#define FLASH_START ((function)_bootrom_len)

/* Defined where External RAM applications start 
 *
 * Start of External RAM
 * 
 */
#define RAM_START ((function)_e_ram_org)

/* Reset any IO used in the bootcode,
 * and jump to the application in Internal Flash */
void run_app_from_flash();

/* Reset any IO used in the bootcode,
 * and jump to the application in External RAM */
void run_app_from_ram();

#endif
