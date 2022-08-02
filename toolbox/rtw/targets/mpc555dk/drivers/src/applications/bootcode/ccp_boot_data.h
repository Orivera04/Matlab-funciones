/*
 * File: ccp_boot_data.h
 *
 * Abstract:
 *   Define a data structure for passing information from the application 
 *   to the boot code
 *
 * $Revision: 1.11.6.4 $
 * $Date: 2004/04/19 01:25:00 $
 *
 * Copyright 2001-2003 The MathWorks, Inc.
 */

#ifndef _CCP_BOOT_DATA_H
#define _CCP_BOOT_DATA_H

#include "boot_bios.h"


typedef enum  {
   COLD_BOOT_APPLICATION = 0, 
   EXECUTE_FLASH_APP,      // Assume an application is in flash and execute it
   CAN_DOWNLOAD,              // Initiate a CCP CAN download
   SERIAL_DOWNLOAD            // Initate a CCP Serial download
} BOOT_ACTION;

/* Possibly move ccp_dto_id and ccp_cro_id
 * into CAN_SETTINGS since they should not be 
 * required for serial download */
typedef struct {
   uint16_T desiredNumQuanta;
   real32_T desiredSamplePoint;
   real32_T desiredBitRate;
} CAN_SETTINGS;

typedef struct CCP_BOOT_DATA {
  uint32_T ccp_dto_id; /* CCP DTO ID */
  uint32_T ccp_cro_id; /* CCP CRO ID */
  uint8_T ccp_count; /* Current CCP Count */

  /* What to do after reset 
   * eg. CAN_DOWNLOAD 
   *     SERIAL_DOWNLOAD */
  BOOT_ACTION boot_action; 
  
  /* RAM_DOWNLOAD | FLASH_DOWNLOAD */
  DOWNLOAD_TYPE download_type; 
  
  /* CAN settings used by the bootcode 
   * to maintain the CAN bit rate of the application
   * during the download */
  CAN_SETTINGS can_settings; 
  
  /* Used to validate that the ccp boot data object is valid.
   * CCP_DATA_APPLICATION_KEY will be assigned to each key. In
   * the main program each of the below keys will be checked
   * to see if they both equates CCP_DATA_APPLICATION_KEY. If they
   * do then further processing of the object is allowed */
  unsigned int ccp_application_key_1;
  unsigned int ccp_application_key_2;
  
} CCP_BOOT_DATA;


/* If CCP_BOOT_DATA contains valid data then the ccp_data_valid
 * element must contain the following bytes
 */
#define CCP_DATA_APPLICATION_KEY 0xFE01FD02

/** Map the CCP boot data into the TPU DPT RAM Module */
#define ccpBootData (* (volatile CCP_BOOT_DATA *) 0x302000 )
#endif

