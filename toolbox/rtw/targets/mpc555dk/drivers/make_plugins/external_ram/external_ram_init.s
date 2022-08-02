 ; external_ram_init.s
 ;
 ; General initialization code for RAM applications
 ;
 ; $Revision: 1.1.6.4 $
 ; $Date: 2004/04/19 01:24:23 $
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

.extern copyappbios

usr_init:
   ; save link register before calling c func
   mflr r0;
   ; create stack frame
   stwu r1,-8(r1);
   stw r0, 12(r1);
   ; copy Application BIOS to desired location
   bl copyappbios;
   ; restore stack frame
   lwz r0, 12(r1);
   addi r1, r1, 8;
   ; restore link register
   mtlr r0;
   
	; Set the NON IEEE mode bit in the FPSCR
	NI .equ 29;
	mtfsb1 NI;
	blr;
