/*
 * File: ccp_mpc555_utils.c
 *
 * Abstract:
 *    Description of file contents and purpose.
 *
 *
 * $Revision: 1.1.6.3 $
 * $Date: 2004/04/19 01:30:07 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 */

#include "ccp_mpc555_utils.h"

/* SIMULATION */
#ifndef CCP_MEMORY_OPERATIONS
   uint8_T c_program_prepare(uint32_T cro_id, uint32_T dto_id,
         uint8_T d1, uint8_T d2, uint8_T d3, uint8_T d4,
         uint8_T d5, uint8_T d6, uint8_T d7, uint8_T d8) {
      return 0;
   }

   void EIE() {
      return;
   }

   void EID() {
      return;
   }
#else /* Real time on HARDWARE */

/* force the target to start executing boot code.
 * the CCP CRO ID, and DTO ID are passed in as well as the 8 bytes of data. */
uint8_T c_program_prepare(uint32_T cro_id, uint32_T dto_id, uint8_T d1, uint8_T d2, uint8_T d3, uint8_T d4, \
uint8_T d5, uint8_T d6, uint8_T d7, uint8_T d8) {

   /* NOTE: the CAN A settings are passed to the bootcode - PROGRAM_PREPARE downloads will
    * only work over CAN A (bootcode default). */
   if ( d3 == 0 ){
      BOOTCODE_API->download_can(cro_id,
                                 dto_id,
                                 RAM_DOWNLOAD,
                                 d2/* Current CCP count */,
                                 GlobalModuleCAN_A.desiredNumQuanta,
                                 GlobalModuleCAN_A.desiredSamplePoint,
                                 GlobalModuleCAN_A.desiredBitRate);
   }else{
      BOOTCODE_API->download_can(cro_id,
                                 dto_id,
                                 FLASH_DOWNLOAD,
                                 d2/* Current CCP count */,
                                 GlobalModuleCAN_A.desiredNumQuanta,
                                 GlobalModuleCAN_A.desiredSamplePoint,
                                 GlobalModuleCAN_A.desiredBitRate);      
   }
}
#endif
