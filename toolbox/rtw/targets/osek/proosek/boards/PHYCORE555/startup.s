/* $RCSfile: startup.s,v $
 * $Revision: 1.6.4.1 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 *
 * Abstract:
 *   Library file to create an ProOSEK OIL file for a given model.
 */
	.macro LDA reg,val
	lis	\reg,\val@ha
	addi	\reg,\reg,\val@l
	.endm

	.global	__cstart
	.global	main
	.global	_INIT_
	.global	_BSS_START_
	.global	_BSS_END_
	.global	_SDA_BASE_
	.global	_SDA2_BASE_
	.global	_DATA_START_
	.global	_DATA_END_
	.global	__eabi
	.section	".start","a"
__cstart:
	
	/* Initialize a reasonable stack pointer (Came from os.c code
	 * used with -DINCLUDE_Startup 
	 */
	LDA	1,OSEKOSstacks+128

	/* Initialize small data area pointers 
	 */
	LDA	13,_SDA_BASE_
	LDA	2,_SDA2_BASE_

ClearBSS:	
	li	5,0
	LDA	3,_BSS_START_-1
	LDA	4,_BSS_END_-1
	b	__clear_bss
__clear_loop:
	stbu	5,1(3)
__clear_bss:
	cmpw	3,4
	bne	__clear_loop

CopyDATA:	
	LDA	5,_INIT_-1
	LDA	3,_DATA_START_-1
	LDA	4,_DATA_END_-1
	b	__copy_data
__copy_loop:
	lbzu	0,1(5)
	stbu	0,1(3)
__copy_data:
	cmpw	3,4
	bne	__copy_loop
	
	bl      HWInit
GotoMain:		
	b	main

__eabi:
	blr

.text	
HWInit:
	/* For running the same image from flash or ram we rely the
	 * reset behavior of IMMR:FLEN=1, BDM init files making
	 * IMMR:FLEN=0. Beyond this, we demand that BR0/OR0 be
	 * disabled and that BR1/OR1 are enbled and map to address 0 
	 */ 

	/* Set BR0 : invalid */
	LDA	3,0x000000000
	LDA	4,0x002FC100
	stw     3,0(4)	

	/* Set BR1 : valid at 0 */
	LDA	3,0x000000001
	LDA	4,0x002FC108
	stw     3,0(4)	

	/* Set OR1 : Addresses for 0xFFC00000 */
	LDA	3,0xFFC00000
	LDA	4,0x002FC10C
	stw     3,0(4)	

	/* SIUMCR - SIU Module Configuration Register */
	LDA	3,0x000000
	LDA	4,0x2FC000
	stw     3,0(4)	
	
	/* SYPCR - System Protection Control Register */
	LDA	3,0x7FFFFF03
	LDA	4,0x2FC004
	stw     3,0(4)	
	
	/* SCCR */
	LDA	3,0x81210100
	LDA	4,0x2FC280
	stw     3,0(4)	

	/* PLPRCR */	
	LDA	3,0x00015000
	LDA	4,0x2FC284
	stw     3,0(4)	
	
ReturnToInitVector:	
	blr


.section	".except_0000","a"
__except_0000:
	b	__except_0000
	
/* reset
.section	".except_0100","a"
__except_0100:
	b	__except_0100
*/
		
.section	".except_0200","a"
__except_0200:
	b	__except_0200
	
.section	".except_0300","a"
__except_0300:
	b	__except_0300
	
.section	".except_0400","a"
__except_0400:
	b	__except_0400
	
/* vectab
.section	".except_0500","a"
__except_0500:
	b	__except_0500
*/
		
.section	".except_0600","a"
__except_0600:
	b	__except_0600
	
.section	".except_0700","a"
__except_0700:
	b	__except_0700
	
.section	".except_0800","a"
__except_0800:
	b	__except_0800
	
/* decrementer */
.section	".decrementer","a"
__decrementer:
	rfi

.section	".except_0A00","a"
__except_0A00:
	b	__except_0A00
	
.section	".except_0B00","a"
__except_0B00:
	b	__except_0B00
	
.section	".except_0C00","a"
__except_0C00:
	b	__except_0C00
	
.section	".except_0D00","a"
__except_0D00:
	b	__except_0D00
	
.section	".except_0E00","a"
__except_0E00:
	b	__except_0E00
	
.section	".except_0F00","a"
__except_0F00:
	b	__except_0F00
	
.section	".except_1000","a"
__except_1000:
	b	__except_1000
	
.section	".except_1100","a"
__except_1100:
	b	__except_1100
	
.section	".except_1200","a"
__except_1200:
	b	__except_1200
	
.section	".except_1300","a"
__except_1300:
	b	__except_1300
	
.section	".except_1400","a"
__except_1400:
	b	__except_1400
	
.section	".except_1500","a"
__except_1500:
	b	__except_1500
	
.section	".except_1600","a"
__except_1600:
	b	__except_1600
	
.section	".except_1700","a"
__except_1700:
	b	__except_1700
	
.section	".except_1800","a"
__except_1800:
	b	__except_1800
	
.section	".except_1900","a"
__except_1900:
	b	__except_1900
	
.section	".except_1A00","a"
__except_1A00:
	b	__except_1A00
	
.section	".except_1B00","a"
__except_1B00:
	b	__except_1B00
	
.section	".except_1C00","a"
__except_1C00:
	b	__except_1C00
	
.section	".except_1D00","a"
__except_1D00:
	b	__except_1D00
	
.section	".except_1E00","a"
__except_1E00:
	b	__except_1E00
	
.section	".except_1F00","a"
__except_1F00:
	b	__except_1F00

