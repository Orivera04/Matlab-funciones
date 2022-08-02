#ifndef __C3F_FLASH__
#define __C3F_FLASH__
/*
 * File : c3f_flash.h
 *
 * Abstract : 
 * 	Easy to use API to flash drivers
 * 	See flash_drivers.h for more information.
 *
 * $Revision: 1.1.6.2 $
 * $Date: 2003/12/11 03:48:58 $
 *
 * Copyright 2003 The MathWorks, Inc.
 *
 * Usage :
 *
 **/

#include   "gmd_type.h"
#include   "gmd_C3F.h"
#include   "gmd_internal.h"


#define Initialize c3f_Initialize
#define ClearBlock c3f_ClearBlock
#define WritePage  c3f_WritePage

extern int c3f_Initialize(unsigned char * base_addr);
extern int c3f_ClearBlock(int block);
extern int c3f_WritePage(int block, int page, char * buffer);

#define PAGE_SIZE 512

/* NUM_MODULES
 *
 * Determine the number of flash modules depending on the
 * processor variant.
 *
 * 565 / 565 and 563 / 564 are supported 
 * */

#ifdef NUM_MODULES
#error NUM_MODULES should not be defined yet
#endif

#ifdef MPC533_VARIANT
#define NUM_MODULES 1
#endif

#ifdef MPC534_VARIANT
#define NUM_MODULES 1
#endif

#ifdef MPC535_VARIANT
#define NUM_MODULES 2
#endif

#ifdef MPC536_VARIANT
#define NUM_MODULES 2
#endif

#ifdef MPC563_VARIANT
#define NUM_MODULES 1
#endif

#ifdef MPC564_VARIANT
#define NUM_MODULES 1
#endif

#ifdef MPC565_VARIANT
#define NUM_MODULES 2
#endif

#ifdef MPC566_VARIANT
#define NUM_MODULES 2
#endif


#ifndef NUM_MODULES
#error Please define either MPC565_VARIANT or MPC563_VARIANT
#endif

#endif
