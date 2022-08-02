/* File : ccp_target.c
 *
 * Abstract : 
 *
 *    A minimal ccp implementation for the bootcode to enable download
 *    of applications to either flash or ram.
 *
 * $Revision: 1.3.6.4 $
 * $Date: 2004/04/19 01:25:01 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 * */
#include "mpc5xx.h"
#include "flash_driver.h"
#include "bootcode.h"
#include "ccp_target.h"
#include "memlayout.h"

/** The CCP kernel state object */
CCP_STATUS ccpStatus;

/* Declaration */ 
static int processCCPCommand(UINT8 * com);

/** See header file for details */
void ccpKernelLoop(UINT8 * com, 
                   CCP_SESSION_STATUS status){
   
   ccpStatus.SessionStatus = status;
   processCCPCommand(com);
   if ( ccpStatus.SessionStatus == CCP_SESSION_STATUS_CONNECTED ){
        /* Endless loop */
        /* Will be terminated by a software reset */
        while(1) {
            UINT8 msg[8];
            if (RxCCP(msg)) {
               /** Reset the watchdog every time we get a message. If no messages
                * are received then the processor will reset. */
               USIU.SWSR.B.SWSR = 0x556C;
               USIU.SWSR.B.SWSR = 0xAA39;
               if (!processCCPCommand(msg)){
						break;
					}
            }
        }
   }
}

/* Check the range of a write is within the writable window.
 * 
 * mem_org     -  The origin of the writable window
 * mem_len     -  The length of the writable window
 * write_org   -  The destination location of the write
 * write_len   -  The length of the write
 *
 * */
#define MEM_RANGE_CHECK(mem_org, mem_len, write_org, write_len) ( \
                  (unsigned int)(write_org) >= (unsigned int)(mem_org)  && \
                  ((unsigned int)(write_org) + (unsigned int)(write_len))  \
                  <= ((unsigned int)(mem_org) + (unsigned int)(mem_len)) \
)

/** Process a single CCP command.
 * @param com  The CAN frame to process as a CCP command
 * */
static int processCCPCommand(UINT8 * com){

	/* Default return value. To cause the CCP loop to exit set this
	 * value to 0 */
	int ret = 1;

   if ( com ){
      CCP_COMMAND_CODE code = com[0];

      ccpStatus.CRM[0] = 0xff;
      ccpStatus.CRM[1] = (UINT8) CCP_RETURN_ACKNOWLEDGE;
      ccpStatus.CRM[2] = com[1];
     
      switch(code){
         case CCP_COMMAND_PROGRAM_PREPARE: 
            program_prepare((DOWNLOAD_TYPE)(com[2]));
            break;

         case CCP_COMMAND_CONNECT: 
            ccpStatus.SessionStatus = CCP_SESSION_STATUS_CONNECTED ;
            break;

         case CCP_COMMAND_SET_MTA:  /* Set Transfer Address */
            ccpStatus.MTA = (*(UINT32*)&com[4]);
            break;

         case CCP_COMMAND_PROGRAM: /* Program */
            {
               int size = com[2];
               UINT8 * address = (UINT8 *) (ccpStatus.MTA);
               UINT8 * data = &(com[3]);

               if (com[2] == 0){
                  /* If the length of data is 0
                   * in a PROGRAM command then this is
                   * an instruction to complete the download
                   * and reset the processor */
                  FLASH_DRIVER.flush();
                  /* Send the responce for the last PROGRAM command */
                  TxCCP(ccpStatus.CRM);
                  /* Delay so message will be sent */
                  {
                     volatile int i;
                     for (i=0;i<500000;i++);
                  }
                  executeFromFlash(); 
						/* If executeFromFlash does return it means execution
						 * of flash downloads has been disabled. This may be
						 * because the flash download is data only or it is
						 * an application that should not be run yet
						 * */
						ret = 0;
               }

               if (  MEM_RANGE_CHECK(_flash_org   , _flash_len  , address, size) ) {
                  if ( !(FLASH_DRIVER.program(address, data, size, 1)) ){
                     ccpStatus.CRM[1] = CCP_RETURN_ACCESS_DENIED;
                  }
               }else{
                  ccpStatus.CRM[1] = CCP_RETURN_ACCESS_DENIED;
               }
               
               ccpStatus.MTA += size;

               break;
            }

         case CCP_COMMAND_PROGRAM_6: /* Program */
            {
               int size = 6;
               UINT8 * address = (UINT8 *) (ccpStatus.MTA);
               UINT8 * data = &(com[2]);

               if (  MEM_RANGE_CHECK(_flash_org   , _flash_len  , address, 6) ) {
                  if ( !(FLASH_DRIVER.program(address, data, size, 1)) ){
                     ccpStatus.CRM[1] = CCP_RETURN_ACCESS_DENIED;
                  }
               }else{
                  ccpStatus.CRM[1] = CCP_RETURN_ACCESS_DENIED;
               }
               ccpStatus.MTA += size;


               break;
            }

         case CCP_COMMAND_DNLOAD: /* Download to RAM */
            {
               UINT8 * src;
               UINT8 * sink;

               int i;

               if (com[2] == 0){
                  /* If the length of data is 0
                   * in a DNLOAD command then this is
                   * an instruction to complete the download
                   * and reset the processor */
                  /* Delay so message will be sent */
                  TxCCP(ccpStatus.CRM);
                  {
                     volatile int i;
                     for (i=0;i<500000;i++);
                  }
                  executeFromRam(); // Does not return
               }


               src = &com[3];
               sink = (UINT8 *) (ccpStatus.MTA);

               /* Check to see if the destination is within
                * internal or external ram */
               
               {
                  int sink_len = com[2];
                  if (     MEM_RANGE_CHECK(_ram_org   , _ram_len  , sink, sink_len) 
                        || MEM_RANGE_CHECK(_e_ram_org , _e_ram_len, sink, sink_len)){
                     for (i=0;i<sink_len;i++){
                        *(sink++)=*(src++);
                     }
                  }else{
                     ccpStatus.CRM[1] = CCP_RETURN_ACCESS_DENIED;
                  }
               }
               ccpStatus.MTA += com[2];

               break;
            }
         case CCP_COMMAND_DNLOAD_6:  /* Download to RAM */
            {
               int idx;
               UINT8 * src;
               UINT8 * sink;

               src = &com[2];
               sink = (UINT8 *) (ccpStatus.MTA);

               if (     MEM_RANGE_CHECK(_ram_org   , _ram_len  , sink, 6) 
                     || MEM_RANGE_CHECK(_e_ram_org , _e_ram_len, sink, 6)){
                  for (idx=0;idx<6;idx++){
                     *(sink++)=*(src++);
                  }
               }else{
                  ccpStatus.CRM[1] = CCP_RETURN_ACCESS_DENIED;
               }

               ccpStatus.MTA += 6;

               break;

            }
         case CCP_COMMAND_UPLOAD: /* Upload from RAM / Flash */
            {
               int idx;
               UINT8 *src;
               UINT8 *sink;

               src = (UINT8 *) (ccpStatus.MTA);
               sink = &(ccpStatus.CRM[3]); 

               for (idx=0; idx<com[2]; idx++) {
                  *(sink++)=*(src++);
               }

               ccpStatus.MTA += com[2];

               break;
            }
         default:  /* unknown */
            ccpStatus.CRM[1] = CCP_RETURN_UNKNOWN_COMMAND;
            break;

      }
      
      /* Send the CRM */
      TxCCP(ccpStatus.CRM);
   }
	return ret;
}
