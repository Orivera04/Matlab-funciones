/*
 * File: isr.c
 *
 * Abstract:
 *    Implements the interrupt handling code for the MPC555.
 *    Please see isr.h
 *
 * $Revision: 1.11.4.3 $
 * $Date: 2004/04/19 01:25:50 $
 *
 * Copyright 2001-2003 The MathWorks, Inc.
 */

#include <stdlib.h>
#include "isr.h"
#include "mpc5xx.h"

#ifndef __MWERKS__
static void NOP_IRQ(register MPC555_IRQ_LEVEL lvl);
#else
static asm void NOP_IRQ( MPC555_IRQ_LEVEL lvl );// pointer to null exception handler
#endif


void LEV7_IRQ( MPC555_IRQ_LEVEL lvl );// pointer to secondary interrupt handler

#ifndef __MWERKS__
	#pragma section JUMPTABLES ".bss" 
	#pragma section SDATA ".sdata" 
#endif

// The interrupt objects
void * IRQ_LEVEL_OBJECTS[39] = { 
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
};



#ifndef __MWERKS__
	#pragma use_section SDATA IRQ1_FLOAT_FLAG
	int  IRQ1_FLOAT_FLAG;
#else
	__declspec(section ".sdata") int  IRQ1_FLOAT_FLAG;
#endif

#ifndef __MWERKS__
	#pragma use_section SDATA IRQ2_FLOAT_FLAG
	int  IRQ2_FLOAT_FLAG;
#else
	__declspec(section ".sdata") int  IRQ2_FLOAT_FLAG;
#endif

#ifndef __MWERKS__
	#pragma use_section SDATA IRQ_ENABLE_COUNT_SEMAPHORE
	volatile int IRQ_ENABLE_COUNT_SEMAPHORE=0; // EID EIE nesting counter
#else
 	__declspec(section ".sdata") volatile int IRQ_ENABLE_COUNT_SEMAPHORE=0; // EID EIE nesting counter
#endif

/* SIVEC Jump table.

	This is the primary fast jump table for levels 0-7.  For internal interrupts
	at levels 7 and above a secondary table is used which looks at UIPEND to
	find which of the UIMB interrupts is pending.

	Fill in this table with the appropriate handlers at each location.  For
	interrupts where you wish no operation, insert the label NOP_IRQ which will
	return immediately
  */
ISR_HANDLER    IRQ1_JUMP_TABLE[16]; 

/* UIPEND Jump Table
 *
 * This is the secondary jump table for internal interrupt levels 7 and above.
 *
 * Fill in this table with the appropriate handlers at each location.  For
 * interrupts where you wish no operation, insert the label NOP_IRQ which will
 * return immediately */
ISR_HANDLER    IRQ2_JUMP_TABLE[33];

void initIrqModule(int mux){
   int idx;
   for(idx=0;idx<15;idx++){
      IRQ1_JUMP_TABLE[idx]=NOP_IRQ;
   }
   IRQ1_JUMP_TABLE[15]=LEV7_IRQ;


   for(idx=0;idx<33;idx++){
      IRQ2_JUMP_TABLE[idx]=NOP_IRQ;
   }

   IRQ1_FLOAT_FLAG = 0;
   IRQ2_FLOAT_FLAG = 0;

   UIMB.UMCR.B.IRQMUX=mux;				  /* Enable all IRQ levels on the UIMB */
}


IRQ_REGISTRATION_STATUS registerIRQ_Handler(MPC555_IRQ_LEVEL lvl, 
                           ISR_HANDLER  fHND,
                           void * object,
                           FLOATING_POINT_FOR_ISR floatMode){

   
   // Store the handler object
   SET_IRQ_LEVEL_OBJECT(lvl,object);

   if(lvl < INT_LEVEL7){
      // Check to see if the level is empty
      if( IRQ1_JUMP_TABLE[lvl] != NOP_IRQ) {
         // The level is not empty so return an error
         return IRQ_HANDLER_NOT_REGISTERED;
      } 

      // Register the interrupt handler and enable it
      IRQ1_JUMP_TABLE[lvl] =  fHND;   
      if(floatMode == FLOAT_USED_IN_ISR){
         IRQ1_FLOAT_FLAG |= 0x1 << lvl;
      }else{
         IRQ1_FLOAT_FLAG &= ~(0x1 << lvl);
      }
      USIU.SIMASK.R = USIU.SIMASK.R | ( 0x80000000 >> lvl);
   }else{

      // recalculate the index for the redirected
      // jump table.
      lvl = lvl - INT_LEVEL7 + 7;

      // Check to see if the level is empty
      if( IRQ2_JUMP_TABLE[lvl] !=  NOP_IRQ){
         // The level is not empty so return an error
         return IRQ_HANDLER_NOT_REGISTERED;
      } 

      // Register the interrupt handler and enable it
      IRQ2_JUMP_TABLE[lvl] = fHND;
      USIU.SIMASK.B.LVM7 = 1;

      if(floatMode == FLOAT_USED_IN_ISR){
         IRQ2_FLOAT_FLAG |= 0x1 << lvl;
      }else{
         IRQ2_FLOAT_FLAG &= ~(0x1 << lvl);
      }
   }
   return IRQ_HANDLER_REGISTERED;

}

void unregisterIRQ_Handler(MPC555_IRQ_LEVEL lvl){
   if(lvl < INT_LEVEL8){
      IRQ1_JUMP_TABLE[lvl] =  NOP_IRQ;   
      USIU.SIMASK.R = USIU.SIMASK.R & ~( 0x80000000 >> lvl);
   }else{
      IRQ2_JUMP_TABLE[lvl - INT_LEVEL7 + 7 ] = NOP_IRQ;
   }
}




int getIRLfromINT_IRQ_LEVEL(MPC555_IRQ_LEVEL level){
   if (level < INT_LEVEL7 ){
      level = level >> 1;
   }else{
      level = level  - INT_LEVEL7 + 7;
   }

   return level & 0x7;
}

int getILBSfromINT_IRQ_LEVEL(MPC555_IRQ_LEVEL level){
   if (level < INT_LEVEL7 ){
      level = level >> 1;
   }else{
      level = level  - INT_LEVEL7 + 7;
   }
   return ( level >> 3 ) & 0x3;
}

/* Dummy interrupt Handler */
#ifndef __MWERKS__
static void NOP_IRQ(register MPC555_IRQ_LEVEL lvl){
}
#else
static asm void NOP_IRQ( register MPC555_IRQ_LEVEL lvl ){
	nofralloc
	blr
}
#endif

#ifndef __MWERKS__
/* These asm macros are used for
 * saving SRR0 and SRR1 onto the
 * stack. They are only used for the
 * diab compiler as the Metrowerks compiler
 * automatically saves the SRR registers
 * with their interrupt pragma
 * */
asm void saveSRR(unsigned int * p){
% reg p
! "r3"
   mfsrr0 r3
   stw r3,0(p)
   mfsrr1 r3
   stw r3,4(p)
}

asm void restoreSRR(unsigned int * p){
% reg p
! "r3"
   lwz r3,0(p)
   mtsrr0 r3
   lwz r3,4(p)
   mtsrr1 r3
}
#endif


#ifdef __MWERKS__
#pragma interrupt SRR on 
#endif
INTERRUPT external_interrupt_isr( void ){
	int iLevel; 
	int iLevelEnum;
	int floatFlag;
	
	// long long is a DIAB and METROWERKS extension for 64 bit integers. We will
	// save the floating point context in here if it is required.  We use long
	// long to ensure 8 byte alignment as this array will be passed to an asm
	// macro that will store the fp registers in the array.
   unsigned long long floatctxt[15];
#ifndef __MWERKS__
   /* The DIAB interrupt pragma does not by default save SRR ????.
    * srr is allocated stack space to save the registers */
   register unsigned int srr[2];
#endif
#ifndef __MWERKS__
   /* The DIAB interrupt pragma does not by default save SRR ???? */
   saveSRR(srr);
#endif
   /* Tell the processor that the interrupt is now recoverable. Do
    * not try to set breakpoints before this statement */
	_EID();

	iLevel = USIU.SIVEC.B.INTERRUPT_CODE;
	iLevelEnum = iLevel >> 2;
	floatFlag = (IRQ1_FLOAT_FLAG >> iLevelEnum ) & 0x1 ;

	if (floatFlag>0){
      /* Save the floating point registers if required */ 
		savefpctxt(floatctxt);
	}
   /* By default the interrupt are disabled when calling
    * our customer handlers. Thus to make the EIE and EID
    * macro's behave correctly we require that IRQ_ENABLE_COUNT_SEMAPHORE
    * is set to 1 before calling the handler and reset to zero
    * after the call to the handler */
	IRQ_ENABLE_COUNT_SEMAPHORE=1;
   /* Call the custom handler */
	IRQ1_JUMP_TABLE[iLevelEnum](iLevelEnum);
   /* Reset the semaphore */
	IRQ_ENABLE_COUNT_SEMAPHORE=0;
   /* Do not try to set breakpoints after this statement. Any exceptions
    * after here are non-recoverable */
	if (floatFlag>0){
      /* Restore the floating point registers if required. */
		loadfpctxt(floatctxt);
	}
   _NRI();
#ifndef __MWERKS__
   /* The DIAB interrupt pragma does not by default save SRR ???? */
   restoreSRR(srr);
#endif
}
#ifdef __MWERKS__
#pragma interrupt off
#endif

/* Secondary Interrupt Handler */
static void LEV7_IRQ( MPC555_IRQ_LEVEL lvl ){
	int iLevel = __cntlzw(UIMB.UIPEND.R);
   MPC555_IRQ_LEVEL mpc555_irq_level;
	int floatFlag;


	// long long is a DIAB and METROWERKS extension for 64 bit integers. We will
	// save the floating point context in here if it is required.  We use long
	// long to ensure 8 byte alignment as this array will be passed to an asm
	// macro that will store the fp registers in the array.
   unsigned long long floatctxt[15];

   /* If no bit is set in UIPEND then the interrupt is generated
    * on an internal level 7 on a device which does not set a bit
    * in the UIPEND register. This is a special case. An example
    * of this is the PIT. You can set it's level to internal 
    * level 7 but it won't show up on the UIPEND register 
    * */
   if ( iLevel== 0 ){
      iLevel = 7;
   }

   /* MAP the UIPEND Interrupt level to the enumeration expected by
    * interrupt service routines
    *
    * iLevel will never be less than 7 in this function.
    * */
   mpc555_irq_level = iLevel - 7 + INT_LEVEL7;

   
   floatFlag = (IRQ2_FLOAT_FLAG >> iLevel ) & 0x1;
	if (floatFlag ){
		savefpctxt(floatctxt);
	}
	IRQ2_JUMP_TABLE[iLevel](mpc555_irq_level);
	if (floatFlag){
		loadfpctxt(floatctxt);
	}
}
