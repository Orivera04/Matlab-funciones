/*
 * File: ccp_mpc555_utils.h
 *
 * Abstract:
 *    CCP utility functions specific to the MPC555 CCP extensions
 *
 *
 * $Revision: 1.1.6.3 $
 * $Date: 2004/04/19 01:30:08 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 */

#ifndef _CCP_MPC555_UTILS_H
#define _CCP_MPC555_UTILS_H

#include "tmwtypes.h"

#include "ccp_build_mode.h"

/* real time code generation extras */
#ifdef CCP_MEMORY_OPERATIONS
   /* header files used for PROGRAM_PREPARE. */ 
   #include "isr.h"
   #include "can_common.h"
   #include "boot_bios.h"
   /* reference to the CAN A module, used to 
    * pass the CAN Bit Rate parameters to the bootcode,
    * during PROGRAM_PREPARE */
   extern CAN_MODULE GlobalModuleCAN_A;
#else
   /* Dummy prototypes for EIE and EID for Simulation */
   void EIE(void);
   void EID(void);
#endif
   
/* force the target to start executing boot code.*/
uint8_T c_program_prepare(uint32_T cro_id, uint32_T dto_id, uint8_T d1, uint8_T d2, uint8_T d3, uint8_T d4, uint8_T d5, uint8_T d6, uint8_T d7, uint8_T d8);

/* END CCP_MPC555_UTILS_H */
#endif
