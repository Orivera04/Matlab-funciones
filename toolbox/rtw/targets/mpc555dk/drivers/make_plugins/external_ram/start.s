;  File: start.s
;
;  Abstract :
;  	Entry point for bootcode to call an external RAM program
;
;  	The bootcode will jump to the location of external RAM when
;  	ready to execute the RAM application. this
;  	means that this section .ram_entry must be
;  	forced to be located at the start of external RAM in the linker
;  	command files for all toolchains.
;
;  $Revision: 1.1.6.1 $
;  $Date: 2004/04/08 20:57:47 $
; 
;  Copyright 2004 The MathWorks, Inc.

	.export ram_entry
	.import __start
	.section .ram_entry
ram_entry:
	b __start
