;  File: start.s
;
;  Abstract :
;  	Entry point for bootcode to call a flash program
;
;  	The bootcode will jump to location 0x8000 when
;  	ready to execute the flash application. this
;  	means that this section .flash_entry must be
;  	forced to be located at 0x8000 in the linker
;  	command files for all toolchains.
;
;  $Revision: 1.1.6.1 $
;  $Date: 2004/04/08 20:57:58 $
; 
;  Copyright 2004 The MathWorks, Inc.

	.export flash_entry
	.import __start
	.section .flash_entry
flash_entry:
	b __start
