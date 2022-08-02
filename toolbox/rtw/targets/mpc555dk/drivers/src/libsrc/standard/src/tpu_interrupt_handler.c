/*
 * File: tpu_interrupt_handler.c
 *
 * Abstract: Code for handling TPU interrupts
 *
 * $Revision: 1.1.6.2 $
 * $Date: 2004/04/19 01:25:59 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 */

#include "tpu_interrupt_handler.h"

#ifdef PROFILING_ENABLED
#include "profile_utils.h"
#endif  

void setTPUModuleHandler(TPU_ISR_MODULE_PTR module,
      TPU_IRQ_SOURCE source,
      TPU_IRQ_HANDLER  fHND){
   /* set the handler */
   module->handlers[source]=fHND;
   module->floatFlags[source]=FLOAT_NOT_USED_IN_ISR;
   /* set the bit in the Channel Interrupt Enable Register */
   BITSET(module->reg->CIER.R, source);
}

void setTPUModuleFloatingPointHandler(TPU_ISR_MODULE_PTR module,
      TPU_IRQ_SOURCE source,
      TPU_IRQ_HANDLER fHND){
   /* set the handler */
   module->handlers[source]=fHND;
   module->floatFlags[source]=FLOAT_USED_IN_ISR;
   /* set the bit in the Channel Interrupt Enable Register */
   BITSET(module->reg->CIER.R, source);
}

void removeTPUModuleHandler(TPU_ISR_MODULE_PTR module,
      TPU_IRQ_SOURCE source){
   /* clear the bit in the Channel Interrupt Enable Register */
   BITCLR(module->reg->CIER.R, source);
   /* remove the handler */
   module->handlers[source] = NULL;
}

int setTPUModuleIrqLevel(TPU_ISR_MODULE_PTR module, MPC555_IRQ_LEVEL level) {
   /* Initialise the interrupt level of the module */
   int CIRL = getIRLfromINT_IRQ_LEVEL(level) << 8;
   int ILBS = getILBSfromINT_IRQ_LEVEL(level) << 6;

   module->reg->TICR.R = CIRL | ILBS;
   
   /* attempt to register the handler and handler object */
   return (
         registerIRQ_Handler(level, (ISR_HANDLER) mainTPUHandler,
            (void *) module, FLOAT_NOT_USED_IN_ISR)
         == IRQ_HANDLER_REGISTERED);
}

void mainTPUHandler(MPC555_IRQ_LEVEL level){
   TPU_ISR_MODULE_PTR module;
   struct TPU3_tag * reg;
   int channel;
   VUINT32 tpu_isr_word;
   TPU_IRQ_HANDLER handler;

   // long long is a DIAB extension for 64 bit integers. We will
   // save the floating point context in here if it is required.
   // We use long long to ensure 8 byte alignment as this array
   // will be passed to an asm macro that will store the fp registers
   // in the array.
   unsigned long long floatctxt[15];
   
#ifdef PROFILING_ENABLED
        /* Task execution profiling */
        profile_section_start(PROFILING_ID_TPU_ISR);
#endif 

   /* Retrieve the data associated with the ISR from the IRQ object
      table. */
   module = (TPU_ISR_MODULE_PTR) GET_IRQ_LEVEL_OBJECT(level);
   if(module==NULL){
      /* There has been a coding error if this occurs as
         we can't resolve the TPU module this interrupt
         came from. */
      exit(EXIT_FAILURE);
   }
   reg = module->reg;

   /*
    * Identify the source of the TPU interrupt 
    *
    */
   tpu_isr_word = (VUINT32) reg->CISR.R;
   /* count the leading zeroes in the Interrupt Status register word 
    * and subtract from 31 to get a channel between 0 and 15 */
   channel = 31 - __cntlzw(tpu_isr_word);

   /* clear the interrupt in the Interrupt Status Register */
   BITCLR(reg->CISR.R, channel); 
     
   handler = module->handlers[channel];

   if (handler!=NULL) {
      if (module->floatFlags[channel]==FLOAT_USED_IN_ISR) {
         /* save floating point context */
         savefpctxt(floatctxt); 
         /* call the handler */
         handler(module, channel);
         /* restore floating point context */
         loadfpctxt(floatctxt);
      }
      else {
         /* call the handler */
         handler(module, channel);
      }
   }

#ifdef PROFILING_ENABLED
   /* Task execution profiling */
   profile_section_end(PROFILING_ID_TPU_ISR);
#endif 
}
