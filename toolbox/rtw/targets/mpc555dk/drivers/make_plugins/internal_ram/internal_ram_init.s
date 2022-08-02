 ; internal_flash_init.s
 ;
 ; General initialization code for RAM applications
 ;
 ; $Revision: 1.1.6.3 $
 ; $Date: 2004/04/19 01:24:36 $
 ;
 ; Copyright 2003-2004 The MathWorks, Inc.
.export usr_init

.ifdef DIAB
	.section ".usr_init"
.else
    #ifdef CODE_WARRIOR
	.section .usr_init
    #else
    .error Not Supported
    #endif
.endif

usr_init:
	; Set the NON IEEE mode bit in the FPSCR
	NI .equ 29;
	mtfsb1 NI;
	blr;
