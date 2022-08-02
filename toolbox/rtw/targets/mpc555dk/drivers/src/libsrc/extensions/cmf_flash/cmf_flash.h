#ifndef __CMF_FLASH__
#define __CMF_FLASH__
/*
 * File : cmf_flash.h
 *
 * Abstract : 
 * 	Easy to use API to flash drivers
 * 	See flash_drivers.h for more information.
 *
 * $Revision: 1.1.6.2 $
 * $Date: 2004/04/19 01:25:19 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 *
 * Usage :
 *
 **/

#include "gmd_types.h"
#include "gmd_ppc.h"

#define Initialize cmf_Initialize
#define ClearBlock cmf_ClearBlock
#define WritePage  cmf_WritePage

extern int cmf_Initialize(unsigned char * base_addr);
extern int cmf_ClearBlock(int block);
extern int cmf_WritePage(int block, int page, char * buffer);

#endif
