/*
 * File: isr.h
 *
 * Abstract:
 *    Header file for interrupt service routine code
 *
 * $Revision: 1.10.4.1 $
 * $Date: 2004/04/19 01:25:38 $
 *
 * Copyright 2001-2002 The MathWorks, Inc.
 */

#ifndef _ISR_H
#define _ISR_H

#include "isr_types.h"

#ifndef __MWERKS__
#pragma use_section SDATA IRQ_ENABLE_COUNT_SEMAPHORE
#pragma section SDATA ".sdata" 
	volatile extern int IRQ_ENABLE_COUNT_SEMAPHORE;
#else
	volatile __declspec(section ".sdata") extern int IRQ_ENABLE_COUNT_SEMAPHORE;
#endif


/** Enable interrupts.   EIE()
 *  Disable interrupts.  EID()
 *
 * This asm macro is designed to be paired with the EID macro. The EID macro
 * increments a global counter every time it is called. The EIE macro
 * decrements a global counter every  time it is called. When EIE is called if
 * the decremented value == 0 then interrupts are enabled. Otherwise nothing
 * happens. This is to stop prevent nested critical sections enabling interrupt
 * before they are required.
 *
 * */

#ifndef __MWERKS__
asm void EIE(void){
! "r0"
%lab A,B,C
	lwz r0,IRQ_ENABLE_COUNT_SEMAPHORE@sdarx(r0); // load semaphore in register
	subic. r0,r0,1		   // sem = sem - 1
	beq A						// if sem == 0 goto A
	blt B						// if sem < 0 goto B
	stw r0,IRQ_ENABLE_COUNT_SEMAPHORE@sdarx(r0);
	b C
A:
	stw r0,IRQ_ENABLE_COUNT_SEMAPHORE@sdarx(r0);
B:
	mtspr EIE,r0
C:
}
#else
/* Decrement the IRQ_ENABLE_COUNT_SEMAPHORE. If it is
 * zero then enable interrupts. However if the IRQ_ENABLE_COUNT_SEMAPHORE
 * is allready zero enable interrupts but do not decrement. */
static void EIE(void){
	register int sem = IRQ_ENABLE_COUNT_SEMAPHORE;
	asm {
		subic. sem,sem,1		// sem = sem - 1
		beq A						// if sem == 0 goto A
		blt B						// if sem < 0 goto B
	}
	IRQ_ENABLE_COUNT_SEMAPHORE = sem;
	goto C;
A:
	IRQ_ENABLE_COUNT_SEMAPHORE = sem;
B:
	asm { "mtspr EIE,r0 " } // enable interrupts
C:
	return;
}
#endif

/** Disable interrupts */
#ifndef __MWERKS__
asm void _EID(void){
	mtspr EID,r0;
}
#else
#define _EID() asm { "mtspr EID,r0" }
#endif

/** Disable interrupt and clear NRI */
#ifndef __MWERKS__
asm void _NRI(void){
   mtspr NRI,r0;
}
#else
#define _NRI() asm { "mtspr NRI,r0" }
#endif

static void EID(void){
	_EID();
	IRQ_ENABLE_COUNT_SEMAPHORE++;
}

/*-----------------------------
 * Floating point context macros
 *-----------------------------*/

// Save floating point context at location


// Restore floating point context from location
#ifndef __MWERKS__
asm void  loadfpctxt(unsigned long long p[]){
%reg p
	.set noreorder				// Do not let the assembly reordering optimizer
									// have a go at this function as it doesn't
									// seem to deal with it very well.
#else
static asm void  loadfpctxt(register unsigned long long p[]){
#endif
   lfd     f0,(14*8)(p)       // load saved value of FPSCR

   mtfsf   0xFF,f0         // install it

	lfd     f0,(0*8)(p)      // Store all required FP registers     
   lfd     f1,(1*8)(p)
   lfd     f2,(2*8)(p)
   lfd     f3,(3*8)(p)
   lfd     f4,(4*8)(p)
   lfd     f5,(5*8)(p)
   lfd     f6,(6*8)(p)
   lfd     f7,(7*8)(p)
   lfd     f8,(8*8)(p)
   lfd     f9,(9*8)(p)
   lfd     f10,(10*8)(p)
   lfd     f11,(11*8)(p)
   lfd     f12,(12*8)(p)
   lfd     f13,(13*8)(p)
#ifdef __MWERKS__
	frfree
	blr
#else
	.set reorder				// Turn reordering back on
#endif
}

// Save floating point context at location
#ifndef __MWERKS__
asm void  savefpctxt(unsigned long long p[]){
%reg p
!"r0"
#define tmp r0
	.set noreorder				// Do not let the assembly reordering optimizer
									// have a go at this function as it doesn't
									// seem to deal with it very well.
#else
static asm void  savefpctxt(register unsigned long long p[]){
register int tmp;
#endif
   mfmsr   tmp              // Get the MSR into r0
   ori     tmp,tmp,0x2000    // Set the Floating point available bit
   mtmsr   tmp              // Restore the MSR

	stfd     f0,(0*8)(p)      // Store all required FP registers     
   stfd     f1,(1*8)(p)
   stfd     f2,(2*8)(p)
   stfd     f3,(3*8)(p)
   stfd     f4,(4*8)(p)
   stfd     f5,(5*8)(p)
   stfd     f6,(6*8)(p)
   stfd     f7,(7*8)(p)
   stfd     f8,(8*8)(p)
   stfd     f9,(9*8)(p)
   stfd     f10,(10*8)(p)
   stfd     f11,(11*8)(p)
   stfd     f12,(12*8)(p)
   stfd     f13,(13*8)(p)

	mffs     f0          // Save FPSCR in fr0
   stfd     f0,(14*8)(p)   // Store the offset 80 in r0
#ifdef __MWERKS__
	frfree
	blr
#else
	.set reorder				// Turn reordering back on
#endif
}


/*---------------------------------------------------------
 * Function
 *
 *    cntlzw
 *
 * Purpose
 *
 *    Counts the leading zeros in a word. Using this
 *    asm macro is faster than any C implementation.
 *
 * Notes
 *
 *    This should be compatible with all POWERPC
 *    derivatives. See the rcpu manual for details
 *
 * Arguments
 *
 *    A 32 bit integer.
 *
 * Return
 *
 *    32 - if all zeros
 *    0  - if MSB is 1
 *    1  - ...
 *
 *----------------------------------------------------*/

/* Assembler macro: 
 * Count the leading zeros in a word
 * */
#ifndef __MWERKS__
asm int __cntlzw (int word){                            
%       reg     word;             
        cntlzw  r3,word      
}
#else
// __MWERKS__ PPC intrinsic function __cntlzw is allready defined
#endif


/*------------------------------------------------------------
 * Macros
 *
 *    GET_IRQ_LEVEL_OBJECT
 *    SET_IRQ_LEVEL_OBJECT
 *
 * Purpose
 *
 *    These two macros allow you to store and retrieve data
 *    that your interrupt service routines can access. This
 *    is particularly usefull if one handler processes multiple
 *    interrupt levels. The handler is passed the interrupt
 *    level and can then retrieve the data for that level.
 *
 *    For example you could use the same handler for the two
 *    TOUCAN modules but put each module on a different level.
 *    The object could then be the pointer to the TOUCAN module.
 * 
*-------------------------------------------------------------*/
#define GET_IRQ_LEVEL_OBJECT(level) \
    ( (level > INT_LEVEL31 ) ? NULL : IRQ_LEVEL_OBJECTS[level] )

#define SET_IRQ_LEVEL_OBJECT(level,object) \
    if ( level <= INT_LEVEL31 ) {  IRQ_LEVEL_OBJECTS[level] = object; } 


// Don't access this directly.
// Use the above macros.
extern void * IRQ_LEVEL_OBJECTS[39];

 
 // PROTOTYPE

IRQ_REGISTRATION_STATUS registerIRQ_Handler(MPC555_IRQ_LEVEL lvl, 
                  ISR_HANDLER  fHND,
                  void * object,
                  FLOATING_POINT_FOR_ISR floatMode );

/*------------------------------------------------------------*/

/*------------------------------------------------------------
 * Function
 *
 *    unregisterHandler
 *
 * Purpose
 *
 *    To unregister an interrupt handler at the appropriate
 *    level for the MPC555. 
 *
 *    By removing a handler you are also implicity disabling
 *    interrupts at levels EXT_IRQ0 -> EXT_IRQ7
 *
 *    INT_IRQ7 -> INT_IRQ31 are all mapped to internal level 7
 *    in the SIVEC so unregistering a handler at levels greater
 *    than EXT_IRQ7 does not disable internal level 7 in the
 *    SIVEC.
 * 
 * Arguments
 *
 *    lvl        -  One of the levels specified by MPC555_IRQ_LEVEL
 */
 
 // PROTOTYPE
void unregisterHandler(MPC555_IRQ_LEVEL lvl);

/*------------------------------------------------------------
 * Function
 *
 *    getIRLfromINT_IRQ_LEVEL
 *    getILBSfromINT_IRQ_LEVEL
 *
 * Purpose
 *    
 *    To generate the Interrupt Request Level and 
 *    Interrupt Byte Select values used by 
 *    the peripherals on the UIMB to set their
 *    interrupt levels.
 *
 * Arguments
 *
 *    level - Can be any of the MPC555_IRQ_LEVEL values
 *            except those that start with EXT as these
 *            functions are only for internal interrupts
 *            such as those generated on the UIMB.
 *
 * Returns
 *
 *    An integer value which can be used in the bit fields
 *
 *       IRL
 *       ILBS
 **/

 // PROTOTYPE
int getIRLfromINT_IRQ_LEVEL(MPC555_IRQ_LEVEL level);
int getILBSfromINT_IRQ_LEVEL(MPC555_IRQ_LEVEL level);

/*------------------------------------------------------------*/



/*------------------------------------------------------------
 * Function
 *
 *    initIrqModule
 *
 * Purpose
 *
 *    reinitializes the jump tables. Should be called 
 *    immediately after a reset before any other
 *    handlers are re-registered.
 *
 *    This function should probably be placed in init.c
 *    just before main is called.
 *
 * Arguments
 *
 *    int mux  -  Determines which interrupt levels are passed
 *                on the UIMB. The UIMB mulitplexes these levels
 *                so if you only need levels 0-7 then specify
 *                mux = 0. It takes four times as long to transmit
 *                all 32 levels as apposed to just the low 8.
 *
 *                0  -  interrupts 0-7  are passed sent on UIMB
 *                1  -  interrupts 0-15 "
 *                2  -  interrupts 0-23 "
 *                3  -  interrupts 0-31 "
 **/
 void initIrqModule(int mux);
/*-----------------------------------------------------------*/
#endif
