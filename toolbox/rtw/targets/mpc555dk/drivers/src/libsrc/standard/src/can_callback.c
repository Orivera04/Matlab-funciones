/*
 * File: can_callback.c
 *
 * Abstract:
 *    Functions related to the interrupt servicing for the
 *    TouCAN module.
 *
 *
 * $Revision: 1.12.6.4 $
 * $Date: 2004/04/19 01:25:46 $
 *
 * Copyright 2001-2003 The MathWorks, Inc.
 */

#include <stdlib.h>
#include <stdio.h>
#include "can_callback.h"
#include "can_driver.h"
#include "mpc5xx.h"
#include "isr.h"

#ifdef PROFILING_ENABLED
#include "profile_utils.h"
#endif  


/*---------------------------------------------
  * Static Function
  * -------------------------------------------*/
static _setCanModuleIrqLevel(PCAN_MODULE module){
   // Initialize the interrupt level of the module
   TOUCAN_IRQ_SOURCE level = module->irqlevel;
   module->reg->CANICR.B.IRL = getIRLfromINT_IRQ_LEVEL(level);
   module->reg->CANICR.B.ILBS= getILBSfromINT_IRQ_LEVEL(level);
}

/*----------------------------------------------
 * See header file for documentation for this function
 *----------------------------------------------*/
void enableCanModuleCallback(PCAN_MODULE module, TOUCAN_IRQ_SOURCE source ){

   if (source <= CAN_IRQ_BUFFER15){
      // Buffer interrupt
      module->reg->IMASK.R |= (1 << source );

   }else if ( source == CAN_IRQ_BUS_OFF ) {
      // Bus off interrupt
      module->reg->CANCTRL0.B.BOFFMSK = 1;

   }else if ( source == CAN_IRQ_ERROR ) {
      // Error interrupt
      module->reg->CANCTRL0.B.ERRMSK = 1;

   }else if ( source == CAN_IRQ_WAKE ) {
      // Wakeup interrupt
      module->reg->TCNMCR.B.WAKEMSK = 1;
   }
}

/*------------------------------------------------------------
 * Function
 *
 *  enableCanModuleCallback
 *  disableCanModuleCallback
 *
 * Purpose
 *
 *  To disable the interrupt for a particular TouCAN source
 *
 * Arugments
 *
 *  module  -   The TouCAN module
 *  source  -   The source of the interrupt
 *
 */
static void disableCanModuleCallback(PCAN_MODULE module, TOUCAN_IRQ_SOURCE source ){

   if (source <= CAN_IRQ_BUFFER15){
      // Buffer interrupt
      module->reg->IMASK.R &= ~(1 << source );

   }else if ( source == CAN_IRQ_BUS_OFF ) {
      // Bus off interrupt
      module->reg->CANCTRL0.B.BOFFMSK = 0;

   }else if ( source == CAN_IRQ_ERROR ) {
      // Error interrupt
      module->reg->CANCTRL0.B.ERRMSK = 0;

   }else if ( source == CAN_IRQ_WAKE ) {
      // Wakeup interrupt
      module->reg->TCNMCR.B.WAKEMSK = 0;
   }
}




/*-----------------------------
 * Local Prototypes
 * ---------------------------*/
void mainHandler( MPC555_IRQ_LEVEL level );

/*-----------------------------
 * Implementations
 * ---------------------------*/
int setCanModuleIrqLevel(PCAN_MODULE module, 
      MPC555_IRQ_LEVEL level){

   module->irqlevel = level;

   _setCanModuleIrqLevel(module);

   // Attempt to register the handler and callback object
   return ( 
      registerIRQ_Handler( level, (ISR_HANDLER )mainHandler,
         (void *)module,FLOAT_NOT_USED_IN_ISR) 
      == IRQ_HANDLER_REGISTERED ); 
}

int setOSEKCanModuleIrqLevel(PCAN_MODULE module, 
      MPC555_IRQ_LEVEL level){

   module->irqlevel = level;

   _setCanModuleIrqLevel(module);

   // Store the handler object
   SET_IRQ_LEVEL_OBJECT(level,(void *)module);

}

int ToucanSoftReset(PCAN_MODULE module){
   int callbackIdx;

   STOP_CAN_MODULE(module);
   module->reg->TCNMCR.B.SOFTRST = 1;

   /* Wait for TouCAN internal reset to occur */
   while(module->reg->TCNMCR.B.SOFTRST); 

   _setCanModuleIrqLevel(module);

   module->reg->TCNMCR.B.FRZ  = 1;       // Enable debugging of the CAN module
   module->reg->TCNMCR.B.SUPV = 1;       // Place the registers in priviledged mode. 

   for(callbackIdx=0;callbackIdx<NTOUCANCALLBACKS;callbackIdx++){
      if (module->callbacks[callbackIdx]!=NULL){
         enableCanModuleCallback(module,(TOUCAN_IRQ_SOURCE) callbackIdx);
      }
   }

   START_CAN_MODULE(module);

   /* Make sure the queue which has been halted has a chance
    to restart */
   sendCanMessage(module,NULL);
}



void setCanModuleCallback(PCAN_MODULE module,
                          TOUCAN_IRQ_SOURCE source,
                          CAN_IRQ_CALLBACK  fHND) {
   module->callbacks[source]=fHND;
   module->floatFlags[source]=FLOAT_NOT_USED_IN_ISR;
   enableCanModuleCallback(module,source);
}

void removeCanModuleCallback(PCAN_MODULE module,
      TOUCAN_IRQ_SOURCE source){
   disableCanModuleCallback(module,source);
   module->callbacks[source] = NULL;
}

void setCanModuleFloatingPointCallback(PCAN_MODULE module,
      TOUCAN_IRQ_SOURCE source,
      CAN_IRQ_CALLBACK fHND){
   module->callbacks[source]=fHND;
   module->floatFlags[source]=FLOAT_USED_IN_ISR;
   enableCanModuleCallback(module,source);
}

/*---------------------------------------------
 * Function 
 *    
 *    mainHandler
 *
 * Purpose
 *
 *    To handle interrupts for the TOUCAN modules.
 *
 *    It is designed to be the handler for as many 
 *    TOUCAN mdoules as there are one board the
 *    system. The handler is passed the interrupt
 *    level upon which it has been triggered and
 *    then retrieves the pointer to the TOUCAN
 *    module corresponding to this level.
 *
 *    Note that this function does not clear
 *    the interupt flags. It is up the the handlers
 *    themselves to do this.
 *
 * Arguments
 *
 *    level -  The interrupt level which triggered
 *             this interrupt.
 *
 * ------------------------------------------------*/
void mainHandler( MPC555_IRQ_LEVEL level ){
   PCAN_MODULE  module;
   struct TOUCAN_tag * reg;
   int buffer;
   int iflag;
   CAN_IRQ_CALLBACK  cb = NULL;
   TOUCAN_IRQ_SOURCE source;

   // long long is a DIAB extension for 64 bit integers. We will
   // save the floating point context in here if it is required.
   // We use long long to ensure 8 byte alignment as this array
   // will be passed to an asm macro that will store the fp registers
   // in the array.
   unsigned long long floatctxt[15];

   // Retrieve the data associated with the ISR from the IRQ object
   // table.
   module = (PCAN_MODULE) GET_IRQ_LEVEL_OBJECT(level);

#ifdef ASSERTIONS_ON
   if(module==NULL){
      // There has been a coding error if this occurs as
      // we can't resolve the TOUCAN module this interrupt
      // came from.
      exit(EXIT_FAILURE);
   }
#endif

#ifdef PROFILING_ENABLED
        /* Task execution profiling */
        profile_section_start(PROFILING_ID_CAN_ISR);
#endif 

   reg = module->reg;

   /*------------------------------------------------------------
    * Identify the source of the TOUCAN interrupt
    * -----------------------------------------------------------*/

   // Check Buffers

   // Mask the IFLAG with IMASK. IFLAG bits can
   // also be set by sucessful recieves even when
   // no interrupt handling is required. In these
   // cases we do not wish to respond. By ANDing with
   // the IMASK we limit ourselves to checking IFLAG
   // bits that require interrupt handling support.
   iflag = reg->IFLAG.R & reg->IMASK.R;

   if(iflag!=0){
      // One of the buffers has an interrupt
      //for(buffer = -1;iflag!=0;iflag>>=1,buffer++);
      buffer = 31 - __cntlzw(iflag);

      cb = module->callbacks[buffer];
      if(cb!=NULL){
         source=buffer;
      }
   }


   // Bus off interrupt
   else  if(reg->ESTAT.B.BOFFINT){
      cb = module->callbacks[CAN_IRQ_BUS_OFF];
      reg->ESTAT.B.BOFFINT=0;
      if(cb!=NULL){
         source=CAN_IRQ_BUS_OFF;
      }
   }

   // Error interrupt
   else if(reg->ESTAT.B.ERRINT){
      cb = module->callbacks[CAN_IRQ_ERROR];
      reg->ESTAT.B.ERRINT=0;
      if(cb!=NULL){
         source=CAN_IRQ_ERROR;
      }
   }

   // Wake up interrupt
   else if(reg->ESTAT.B.WAKEINT){
      cb = module->callbacks[CAN_IRQ_WAKE];
      reg->ESTAT.B.WAKEINT=0;
      if(cb!=NULL){
         source=CAN_IRQ_WAKE;
      }
   } 

   /* No interrupt flag is set (may have been cleared by the application */
   else {
       /* Do nothing */  
   }

   if(cb!=NULL){
      if (module->floatFlags[source]==FLOAT_USED_IN_ISR){
         savefpctxt(floatctxt);
         cb(module,source);
         loadfpctxt(floatctxt);
      }else{
         cb(module, source);
      }

   }

   if(iflag != 0){
      CLR_TOUCAN_BUFFER_IFLAG(reg, buffer);
   }

#ifdef PROFILING_ENABLED
   /* Task execution profiling */
   profile_section_end(PROFILING_ID_CAN_ISR);
#endif 

}

