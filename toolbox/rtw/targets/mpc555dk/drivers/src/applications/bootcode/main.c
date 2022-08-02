/*
 * File: main.c
 *
 * Abstract:
*    Main program for MPC555 bootloader
 *
 * $Revision: 1.14.6.5 $
 * $Date: 2004/04/19 01:25:04 $
 *
 * Copyright 2001-2004 The MathWorks, Inc.
 */

#include <stdlib.h>
#include "mpc5xx.h"
#include "simple_can_driver.h"
#include "ccp_boot_data.h"
#include "ccp_target.h"
#include "serial_boot.h"
#include "ccp_network.h"
#include "assembler.h"
#include "run_app.h"

#define DEFAULT_CCP_CRO_ID 0x6FA
#define DEFAULT_CCP_DTO_ID 0x6FB

/* APPLICATION_EXCEPTION_TABLE_BASE will be passed in as a flag on the compile
   line. The makefile will detect the processor variant and choose the value.
   The APPLICATION_EXCEPTION_TABLE_BASE is the location that applications will
   intercept exceptions forwarded by the bootcode. */
#define SECONDARY_DECREMENTER_EXCEPTION_VECTOR_ADDRESS (APPLICATION_EXCEPTION_TABLE_BASE + 0x24)

/* LISTENING_COUNT is the number of decrementer ticks to wait for a
 * Boot Command before launching the main application.
 *
 * The decrementer uses the time base clock TBSCLK, which in turn
*  is driven by OSCCLK (assumes SCCR[TBS] = 0).
 *
 * Depending on whether a 4 MHz or 20 MHz crystal is used, OSCCLK will
 * be one of these values.
 *
 * 
 * Following a reset, the default value of MF in PLPRCR is either 0 or 4
 * depending on whether a 4 MHz or 20 MHz
 * crystal is used (see clocks & power control section of MPC555 user
 * guide)
 * 
 * If MF=4, TMBCLK is driven by OSCCLK divided by four.
 * If MF=0, TMBCLK is driven by OSCCLK divided by 16.
 *
 * To summarise: 
 *
 * with a 20 MHz crystal the timebase frequency is 1.25 MHz and one decrementer
 * tick = 800 ns. A LISTENING_COUNT of 50000
 * equates to a duration of 40 ms.
 *
 * with a 4 MHz crystal the timebase frequency is 1 MHz and one decrementer
 * tick = 1000 ns. A LISTENING_COUNT of 50000
 * equates to a duration of 50 ms.
 */
#define LISTENING_COUNT 50000 
#define DECLOAD (LISTENING_COUNT + LISTENING_COUNT)


/* Local Prototypes */
void DecrementerStart(void);
void DecrementerDisable(void);
#ifdef __MWERKS__
asm void DecrementerInit();
asm void disable_flash();
asm unsigned int DISABLE_INTERRUPTS(void);
asm unsigned int ENABLE_INTERRUPTS(void);
asm UINT32 readDec();
#endif

/* Global Variables 
 *
 * Function pointers to functions that 
 * can transmit and receive CCP messages
 *
 * These can be set once the transport layer
 * has been selected */
RECEIVE_CCP_MESSAGE RxCCP;
TRANSMIT_CCP_MESSAGE TxCCP;

/*******************************************************************************
FUNCTION    : DISABLE_INTERRUPTS
PURPOSE     : Disable all external interrupts and the decrementer exception
INPUT NOTES : 
RETURN NOTES    : 
GENERAL NOTES   : 
 *******************************************************************************/
asm unsigned int DISABLE_INTERRUPTS(void){
   mtspr EID,r0;
#ifdef __MWERKS__
   blr;
#endif
}

/*******************************************************************************
FUNCTION    : ENABLE_INTERRUPTS
PURPOSE     : Enable all external interrupts and the decrementer exception
INPUT NOTES : 
RETURN NOTES    : 
GENERAL NOTES   : 
 *******************************************************************************/
asm unsigned int ENABLE_INTERRUPTS(void){
   mtspr EIE,r0;
#ifdef __MWERKS__
   blr;
#endif
}

/*******************************************************************************
FUNCTION    : readDec
PURPOSE     : Return Decrementer value
INPUT NOTES : 
RETURN NOTES    : 32-bit counter value: clocked at SysClock / 16
i.e. 400 ns per count at 40 MHz or 800 ns per count at 
20 MHz
GENERAL NOTES   : 
 *******************************************************************************/
asm UINT32 readDec()
{
   mfdec   r3;
#ifdef __MWERKS__
   blr;
#endif
}

/*******************************************************************************
FUNCTION    : DecrementerInit
PURPOSE     : Initialise the decrementer register
INPUT NOTES : 
RETURN NOTES    : 
GENERAL NOTES   : 
 *******************************************************************************/
asm void DecrementerInit() {
   lis     r3,DECLOAD@h;  
   ori     r3,r3,DECLOAD@l;  
   mtdec  r3;               /* initialise decrementer */
#ifdef __MWERKS__
   blr;
#endif
}

/*******************************************************************************
FUNCTION    : DecrementerStart
PURPOSE     : Start the decrementer running
INPUT NOTES : 
RETURN NOTES    : 
GENERAL NOTES   : 
 *******************************************************************************/
void DecrementerStart(void)
{
   /* Install a RFI (return from interrupt) instruction
    * at the specified address (the decrementer interrupt entry
    * in the secondary, RAM exception table).   This effectively
    * ignores the decrementer interrupt if it goes off. 
    *
    * NOTE: we install this handler at run time, since we only wish to
    * write to the internal RAM when absolutely necessary - for example, if 
    * an application has been downloaded already and then triggered a reset 
    * of the processor to begin application execution, we need to make sure 
    * that we do not overwrite any part of the application (ie. it's exception table) ! */
   assemble_rfi((void *) SECONDARY_DECREMENTER_EXCEPTION_VECTOR_ADDRESS);
   
   /* Enable timebase/decrementer  */
   USIU.TBSCRK.R = 0x55CCAA33; /* Unlock timebase status reg                */
   USIU.TBSCR.R  = 3;          /* Enable TB and decrementer                 */
   USIU.SCCR.R  |= 0x82000000; /* Select TB/DEC clock to sys clock/16       */
}

/*******************************************************************************
FUNCTION    : DecrementerDisable
PURPOSE     : Stop the decrementer running
INPUT NOTES : 
RETURN NOTES    : 
GENERAL NOTES   : 
 *******************************************************************************/
void DecrementerDisable(void) {
   USIU.TBSCR.R  = 0;          /* disable TB and decrementer                 */
}

UINT8 main() { 

   /* If ccpBootData contains valid CCP configuration (set by application) 
    * then use it. Otherwise set default values 
    */

   /************************************************************************

     ccpBootData 

     The ccpBootData.cpp is stored at location 0x3f9800 in internal RAM.
     It allows an application to reset the processor but pass some 
     information back to the boot agent such as the reason for the reset.
     It is stored at an absolute location so that both the application and
     the boot agent can have a common reference.

     The boot agent checks the validity of the data by looking at two
     fields ccp_application_key_1 and ccp_application_key_2. If these
     two fields do not match a constant reference value then the 
     assumption is made that either the program crashed and reset
     or it is a cold boot and therefore a default operation should
     occur.

    ************************************************************************/


   if (  !(ccpBootData.ccp_application_key_1 == CCP_DATA_APPLICATION_KEY && 
         ccpBootData.ccp_application_key_2 == CCP_DATA_APPLICATION_KEY)  ) {

      /* The processor has reset either from a COLD boot or an
         unsolicited watchdog timer time-out. The application
         or boot-code did not perform a deliberate reset. */

      ccpBootData.boot_action = COLD_BOOT_APPLICATION;
      ccpBootData.ccp_dto_id = DEFAULT_CCP_DTO_ID;
      ccpBootData.ccp_cro_id = DEFAULT_CCP_CRO_ID;
   }

   ccpBootData.ccp_application_key_1 = 0;
   ccpBootData.ccp_application_key_2 = 0;


   switch (ccpBootData.boot_action){
      case EXECUTE_FLASH_APP:
         /* A Flash application has just been programmed into internal flash,
          * and the processor has been reset ready to execute from flash.
          *
          * Jump to the flash application - never return */
         run_app_from_flash(); 
         break;
      case CAN_DOWNLOAD: /* Arrive here after PROGRAM_PREPARE reset in application */
         {
            unsigned char can_msg[8];
            /* initialise CAN */
            setupCanModuleBoot(ccpBootData.can_settings.desiredNumQuanta,
                               ccpBootData.can_settings.desiredSamplePoint,
                               ccpBootData.can_settings.desiredBitRate);
            initCanModuleRxTxBoot(ccpBootData.ccp_cro_id, ccpBootData.ccp_dto_id);
           
            /* the application already received a PROGRAM_PREPARE CCP
             * message.
             *
             * Construct this message and then call the ccpKernelLoop
             */
            can_msg[0] = CCP_COMMAND_PROGRAM_PREPARE;
            can_msg[1] = ccpBootData.ccp_count;
            can_msg[2] = ccpBootData.download_type;
            can_msg[3] = 0;
            can_msg[4] = 0;
            can_msg[5] = 0;
            can_msg[6] = 0;
            can_msg[7] = 0;

            /* set the function pointers used in ccpKernelLoop */
            RxCCP = (RECEIVE_CCP_MESSAGE) receiveCanFrameBoot;
            TxCCP = (TRANSMIT_CCP_MESSAGE) sendCanFrameBoot;
            
            /* Start the boot loader and never return */
            ccpKernelLoop(can_msg,
                          CCP_SESSION_STATUS_CONNECTED);
         }
         break;
         /*
      case SERIAL_DOWNLOAD: Place holder for automatic (Program Prepare) serial download
         break;
         */
      case COLD_BOOT_APPLICATION: /* Arrive here after power cycle, or reset button */
         setupCanModuleBoot(DEFAULT_NUM_QUANTA,
                            DEFAULT_SAMPLE_POINT,
                            DEFAULT_BIT_RATE);
         initCanModuleRxTxBoot(ccpBootData.ccp_cro_id, ccpBootData.ccp_dto_id);
         initSerialModuleBoot();
         
         /* Use the decrementer to control the time spent listening for a CCP message
          * before launching the main application
          */
         DecrementerInit();
         DecrementerStart();

         /* Listen for for CCP CONNECT command before branching to application code */
         while( readDec() > (DECLOAD - LISTENING_COUNT) ) {
            UINT8 msg[8];
            if ( receiveCanFrameBoot(msg) ) {
               RxCCP = (RECEIVE_CCP_MESSAGE) receiveCanFrameBoot;
               TxCCP = (TRANSMIT_CCP_MESSAGE) sendCanFrameBoot;
               /* Start the bootloader and never return */
         		DecrementerDisable();
               ccpKernelLoop(msg,
                             CCP_SESSION_STATUS_DISCONNECTED);
            }
            /* check for serial comms */
            if (receiveTargetAliveByte()) {
               RxCCP = (RECEIVE_CCP_MESSAGE) receiveSerialCCPMessage; 
               TxCCP = (TRANSMIT_CCP_MESSAGE) sendSerialCCPMessage;
               DecrementerDisable();
               /* sync with host before 
                * starting CCP kernel */
               syncWithHost();
               /* receive the first CCP message */
               waitForSerialCCPMessage(msg); 
               ccpKernelLoop(msg, 
                             CCP_SESSION_STATUS_DISCONNECTED);
            }
         }

         DecrementerDisable();
         
         /* By default we run the flash application */ 
         run_app_from_flash();
      default:
         exit(1); /* Error condition. Should never get here */
         break;
   }
   return 1;
}

/** We do not need this anymore */
asm void disable_flash(){
#ifndef __MWERKS__
   ! "r3"
      addi r3,r0,0x0;
   mtspr 638,r3;
#else
   register int a;
   addi a,r0,0x0;
   mtspr 638,a;
   frfree;
   blr;
#endif
}
