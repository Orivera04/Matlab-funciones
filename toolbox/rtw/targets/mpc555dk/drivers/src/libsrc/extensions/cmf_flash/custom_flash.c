/*
 * File: custom_flash.c
 *
 * Abstract :
 * 	API implementation for custom drivers
 *
 * $Revision: 1.1.6.1 $
 * $Date: 2003/12/11 03:48:59 $
 *
 * Copyright 2003 The MathWorks, Inc.
 **/

#include "custom_flash.h"

extern int custom_Initialize(unsigned char * base_addr){
   /* no flash programming support */
	return FLASH_PROGRAMMING_ERROR;
}

extern int custom_ClearBlock(int block){
   /* no flash programming support */
   return FLASH_PROGRAMMING_ERROR;
}

extern int custom_WritePage(int block, int page, char * buffer){
   /* no flash programming support */
   return FLASH_PROGRAMMING_ERROR;
}
