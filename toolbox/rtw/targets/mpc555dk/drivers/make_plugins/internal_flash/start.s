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
;  $Revision: 1.1 $
;  $Date: 2002/09/13 09:03:34 $
; 
;  Copyright 2002 The MathWorks, Inc.

	.export flash_entry
	.import __start
	.section .flash_entry
flash_entry:
	b __start
