#ifndef __CUSTOM_FLASH__
#define __CUSTOM_FLASH__
/*
 * File : custom_flash.h
 *
 * Abstract : 
 * 	Easy to use API to flash drivers
 * 	See flash_drivers.h for more information.
 *
 * $Revision: 1.1.6.1 $
 * $Date: 2003/12/11 03:49:00 $
 *
 * Copyright 2003 The MathWorks, Inc.
 *
 * Usage :
 *
 **/
#include "flash_driver.h"

/* include some standard types */
#include "mpc5xx.h"

#define Initialize custom_Initialize
#define ClearBlock custom_ClearBlock
#define WritePage  custom_WritePage

extern int custom_Initialize(unsigned char * base_addr);
extern int custom_ClearBlock(int block);
extern int custom_WritePage(int block, int page, char * buffer);


/* dummy settings */
#define PAGE_SIZE 512
#define BLOCK_SIZE 0x8000

#endif
