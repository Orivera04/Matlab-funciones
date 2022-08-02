/*
 * File : bootcode.h
 *
 * Abstract :
 * 	A set of utility functions to be used in the bootcode
 *
 *	Copyright 2002-2003 The MathWorks, Inc.
 *
 * $Revision: 1.3.4.2 $
 * $Date: 2004/04/19 01:24:57 $ 
*/

#ifndef _BOOTCODE_H
#define _BOOTCODE_H

#include "boot_bios.h"

typedef struct {
	unsigned int address;
	const char * data;
	unsigned int count;
} SRecord;


/* The application image */
extern SRecord srecord [] ;

/* --- Prototypes -- */
UINT8 ramInit( void );

void executeFromRam(void);
void executeFromFlash(void);
void program_prepare(DOWNLOAD_TYPE type);

#define PLPRCRK 0x2FC384
#define PLPRCR 0x2FC284  
#define UNLOCK_KEY 0x55CCAA33
#define BAD_FETCH_ADDR 0xFFFF0000

#define IP 25 
#define ME 19 

#define CSR 24
#define TEXPS 17
#define SPLSS 16
#define TMIST 19


// See GECK: G170577

//#ifndef __MWERKS__
//asm void reset(void) {
//#else
//asm static void reset(void) {
//#endif
//	 /* Load a 1 into r5 and a 0 in r6 */
//	 /* for bit set instructions       */
//	 li r5,1 
//	 li r6,0;
//
//	 /* Set the IP and clear the ME BIT in the MSR */
//	 mfmsr  r3;
//	 insrwi r3,r6,1,ME; /* Clear ME bit */
//	 insrwi r3,r5,1,IP; /* Set IP bit */
//	 mtmsr r3;
//
//    /* Be sure DER[CKSTPE] = 0, we don't want to enter debug mode on ME.*/
//    li      r3, 0;
//    mtspr   DER,r3; 
//
//	 /* Unlock the PLPRCR using the PLPRCRK key */
//    lis     r5,   UNLOCK_KEY@h;
//    ori     r5,r5,UNLOCK_KEY@l;
//    addis   r4,r0,PLPRCRK@ha;
//    stw     r5,PLPRCRK@l(r4);
//
//
//	 /* Cause a machine check exception */
//	 li              r12,0        /* Set up a NULL pointer */
//	 stw             r12,0(r12)   /* Causes reset */
//
//}

#define NUMBER_OF_RECORDS 4
#endif
