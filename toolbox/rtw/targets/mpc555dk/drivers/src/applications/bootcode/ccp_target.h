/* File : ccp_target.h
 *
 * Abstract : 
 *
 *    A minimal ccp implementation for the bootcode to enable download
 *    of applications to either flash or ram.
 *
 * $Revision: 1.1.6.3 $
 * $Date: 2004/04/19 01:25:02 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 * */
#ifndef _CCP_TARGET_H
#define _CCP_TARGET_H

#include "mpc5xx.h"
#include "ccp_network.h"

/* This is a cut down CCP Kernal header for the mpc555 bootcode. It is not
 * intended to be or ever will be a full CCP kernel. It's aim is to provide
 * a hook for download over CCP to the target 
 * */

/** CCP Command Codes */
typedef enum CCP_COMMAND_CODE{
   CCP_COMMAND_CONNECT               =0x01 ,
   CCP_COMMAND_GET_CCP_VERSION       =0x1B ,
   CCP_COMMAND_EXCHANGE_ID           =0x17 ,
   CCP_COMMAND_GET_SEED              =0x12 ,
   CCP_COMMAND_UNLOCK                =0x13 ,
   CCP_COMMAND_SET_MTA               =0x02 ,
   CCP_COMMAND_DNLOAD                =0x03 ,
   CCP_COMMAND_DNLOAD_6              =0x23 ,
   CCP_COMMAND_UPLOAD                =0x04 ,
   CCP_COMMAND_SHORT_UP              =0x0F ,
   CCP_COMMAND_SELECT_CAL_PAGE       =0x11 ,
   CCP_COMMAND_GET_DAQ_SIZE          =0x14 ,
   CCP_COMMAND_SET_DAQ_PTR           =0x15 ,
   CCP_COMMAND_WRITE_DAQ             =0x16 ,
   CCP_COMMAND_START_STOP            =0x06 ,
   CCP_COMMAND_DISCONNECT            =0x07 ,
   CCP_COMMAND_SET_S_STATUS          =0x0C ,
   CCP_COMMAND_GET_S_STATUS          =0x0D ,
   CCP_COMMAND_BUILD_CHKSUM          =0x0E ,
   CCP_COMMAND_CLEAR_MEMORY          =0x10 ,
   CCP_COMMAND_PROGRAM               =0x18 ,
   CCP_COMMAND_PROGRAM_6             =0x22 ,
   CCP_COMMAND_MOVE                  =0x19 ,
   CCP_COMMAND_TEST                  =0x05 ,
   CCP_COMMAND_GET_ACTIVE_CAL_PAGE   =0x09 ,
   CCP_COMMAND_START_STOP_ALL        =0x08 ,
   CCP_COMMAND_DIAG_SERVICE          =0x20 ,
   CCP_COMMAND_ACTION_SERVICE        =0x21 , 
   /* Extensions */
   CCP_COMMAND_PROGRAM_PREPARE       =0x1E   /* Prepare for application download */
} CCP_COMMAND_CODE;


/** CCP Command Return Codes */
typedef enum CCP_COMMAND_RETURN_CODE {
   CCP_RETURN_ACKNOWLEDGE                        =0x00 ,

   /* Error Categorey C0 */
   CCP_RETURN_DAQ_PROCESSOR_OVERLOAD             =0x01 ,

   /* Error Categorey C1 */
   CCP_RETURN_COMMAND_PROCESSOR_BUSY             =0x10 ,
   CCP_RETURN_DAQ_PROCESSOR_BUSY                 =0x11 ,
   CCP_RETURN_INTERNAL_TIMEOUT                   =0x12 ,
   CCP_RETURN_KEY_REQUEST                        =0x18 ,
   CCP_RETURN_SESSION_STATUS_REQUEST             =0x19 ,

   /* Error Categorey C2 */
   CCP_RETURN_COLD_START_REQUEST                 =0x20 ,
   CCP_RETURN_CAL_DATA_INIT_REQUEST              =0x21 ,
   CCP_RETURN_DAQ_LIST_INIT_REQUEST              =0x22 ,
   CCP_RETURN_CODE_UPDATE_REQUEST                =0x23 ,

   /* Error Categorey C3 */
   CCP_RETURN_UNKNOWN_COMMAND                    =0x30 ,
   CCP_RETURN_COMMAND_SYNTAX                     =0x31 ,
   CCP_RETURN_PARAMETER_OUT_OF_RANGE             =0x32 ,
   CCP_RETURN_ACCESS_DENIED                      =0x33 ,
   CCP_RETURN_OVERLOAD                           =0x34 ,
   CCP_RETURN_ACCESS_LOCKED                      =0x35 ,
   CCP_RETURN_RESOURCE_OR_FUNCTION_NOT_AVAILABLE =0x36 
}CCP_COMMAND_RETURN_CODE; 




/** CCP Session Status */
typedef enum CCP_SESSION_STATUS {
   CCP_SESSION_STATUS_DISCONNECTED       =0x00,
   CCP_SESSION_STATUS_CAL                =0x01,
   CCP_SESSION_STATUS_DAQ                =0x02,
   CCP_SESSION_STATUS_RESUME             =0x04,
   CCP_SESSION_STATUS_TMP_DISCONNECTED   =0x10,
   CCP_SESSION_STATUS_CONNECTED          =0x20,
   CCP_SESSION_STATUS_STORE              =0x40,
   CCP_SESSION_STATUS_RUN                =0x80
}CCP_SESSION_STATUS; 

/** CCP State Structure Type */
typedef struct CCP_STATUS {

   /* Command Return Message */
   UINT8 CRM[8];                            

   /* CCP Session Status */
   CCP_SESSION_STATUS SessionStatus;

   /* Memory Transfer Address */
   UINT32 MTA;          

} CCP_STATUS ;

/** CCP State Structure */
extern CCP_STATUS ccpStatus ;


/** Main loop for ccp kernel.
 * 
 * @param com     Initial CAN data frame. If it is null then it is not processed.
 * @param status  The initial status of the ccp kernel before entry into the loop.
 *                For example if the kernel should start in the connected state pass
 *                the value CCP_SESSION_STATUS_CONNECTED
 * */
void ccpKernelLoop(UINT8 * com, 
                   CCP_SESSION_STATUS status);

#endif
