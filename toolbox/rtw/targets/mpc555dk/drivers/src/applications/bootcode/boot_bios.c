/*************************************************************
# File: boot_bios.c
#
# Abstract:
#  Interface to allow applications to call the bootcode API
#
#
# $Revision: 1.2.6.4 $
# $Date: 2004/04/19 01:24:55 $ 
#
# Copyright 2002-2003 The MathWorks, Inc.
*/
#include <stdlib.h>
#include "boot_bios.h"
#include "isr.h"
#include "ccp_boot_data.h"
#include "mpc5xx.h"
#include "bootcode.h"


/* -- Function Prototypes -- */
static void _BB_RESET( void );

static void _BB_DOWNLOAD_CAN(uint32_T cro_id, 
                             uint32_T dto_id, 
                             DOWNLOAD_TYPE type, 
                             uint8_T ccp_count,
                             uint16_T desiredNumQuanta,
                             real32_T desiredSamplePoint,
                             real32_T desiredBitRate); 

static void _BB_DOWNLOAD_SERIAL(uint32_T cro_id, 
                                uint32_T dto_id, 
                                DOWNLOAD_TYPE type, 
                                uint8_T ccp_count );

/* Must locate the section .boot_bios_u at location 0x104 in internal flash
 * just above the exception table */

#ifndef __MWERKS__
#pragma section BOOT_BIOS_SECTION ".boot_bios" ".boot_bios_u"
#pragma use_section BOOT_BIOS_SECTION boot_bios;
BOOTCODE_API_STRUCT boot_bios = 
#else
#pragma section ".boot_bios" ".boot_bios_u"
#pragma push
__declspec(section ".boot_bios") BOOTCODE_API_STRUCT bootcode_bios_jump_table =
#endif
{
   _BB_RESET,             /* Plain old reset */
   _BB_DOWNLOAD_CAN,		  /* Reset and can download */
   _BB_DOWNLOAD_SERIAL	  /* Reset and serial download */
};
#ifdef __MWERKS__
#pragma pop
#endif

/* download_and_reset
 *
 * Parameters
 *
 * cro_id - The CCP CRO id which the boot CCP kernal will be initialized with
 * dto_id - The CCP DTO id which the boot CCP kernal will be initialized with
 * download_type - RAM_DOWNLOAD | FLASH_DOWNLOAD
 * */
static void download_and_reset(uint32_T cro_id, 
                               uint32_T dto_id, 
                               DOWNLOAD_TYPE download_type, 
                               uint8_T ccp_count );


static void do_reset(){
   ccpBootData.ccp_application_key_1 = CCP_DATA_APPLICATION_KEY;
   ccpBootData.ccp_application_key_2 = CCP_DATA_APPLICATION_KEY;
   while (1) {
      /* watchdog timer will time out and cause reset */
   }
}

/* Disable interupts
 * Validate the ccpBootData
 * Force watchdog timeout
 * */
static void _BB_RESET( void ){
	/* This will ensure that the watchdog times out */
   EID();
   do_reset();
}

/* BOOT BIOS CAN DOWNLOAD API IMPLEMENTATION */
static void _BB_DOWNLOAD_CAN(uint32_T cro_id, 
                             uint32_T dto_id, 
                             DOWNLOAD_TYPE download_type,
                             uint8_T ccp_count,
                             uint16_T desiredNumQuanta,
                             real32_T desiredSamplePoint,
                             real32_T desiredBitRate){
   EID();
   ccpBootData.boot_action = CAN_DOWNLOAD;
   /* settings specific to CAN Download */
   ccpBootData.can_settings.desiredNumQuanta = desiredNumQuanta;
   ccpBootData.can_settings.desiredSamplePoint = desiredSamplePoint;
   ccpBootData.can_settings.desiredBitRate = desiredBitRate;
   download_and_reset(cro_id,dto_id,download_type,ccp_count);
}

/* BOOT BIOS API SERIAL DOWNLOAD IMPLEMENTATION */
static void _BB_DOWNLOAD_SERIAL(uint32_T cro_id, 
                                uint32_T dto_id, 
                                DOWNLOAD_TYPE download_type,
                                uint8_T ccp_count ){
   EID();
   ccpBootData.boot_action = SERIAL_DOWNLOAD;
   download_and_reset(cro_id,dto_id,download_type,ccp_count);
}

static void download_and_reset(uint32_T cro_id, 
                               uint32_T dto_id, 
                               DOWNLOAD_TYPE download_type,
                               uint8_T ccp_count){
   ccpBootData.ccp_dto_id = dto_id;
   ccpBootData.ccp_cro_id = cro_id;
   ccpBootData.ccp_count  = ccp_count;
   ccpBootData.download_type = download_type;
   /* Store config somewhere in RAM */
   do_reset();
}
