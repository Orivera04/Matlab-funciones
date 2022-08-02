/*************************************************************
# File: boot_bios.h
#
# Abstract:
#  Interface to allow applications to call the bootcode API
#
#
# $Revision: 1.1.6.3 $
# $Date: 2004/04/19 01:25:30 $ 
#
# Copyright 2002-2003 The MathWorks, Inc.
*/

#ifndef __BOOT_BIOS_H__
#define __BOOT_BIOS_H__

/* -- Access the bootcode api ------------------------
 *
 * BOOTCODE_API->reset();
 * BOOTCODE_API->download_can(can_struct);
 * BOOTCODE_API->download_serial(serial_struct);
 *
 * --------------------------------------------------*/
#include "tmwtypes.h"

/* Define the download locations */
typedef enum { RAM_DOWNLOAD = 0, FLASH_DOWNLOAD } DOWNLOAD_TYPE;

#define BOOTCODE_API_LOCATION 0x104
#define BOOTCODE_API ((BOOTCODE_API_STRUCT *) BOOTCODE_API_LOCATION)

/* -- Typedefs for all the API functions -- */
typedef void ( * BB_RESET ) ( void );

typedef void ( * BB_DOWNLOAD_CAN ) ( uint32_T cro_id, 
                                     uint32_T dto_id, 
                                     DOWNLOAD_TYPE type, 
                                     uint8_T ccp_count,
                                     uint16_T desiredNumQuanta,
                                     real32_T desiredSamplePoint,
                                     real32_T desiredBitRate); 

typedef void ( * BB_DOWNLOAD_SERIAL ) ( uint32_T cro_id, 
                                        uint32_T dto_id, 
                                        DOWNLOAD_TYPE type, 
                                        uint8_T ccp_count );

/* -- Structure for laying out the API table -- */
typedef struct {
   BB_RESET reset;
   BB_DOWNLOAD_CAN download_can;
   BB_DOWNLOAD_SERIAL download_serial;
} BOOTCODE_API_STRUCT;


#endif


