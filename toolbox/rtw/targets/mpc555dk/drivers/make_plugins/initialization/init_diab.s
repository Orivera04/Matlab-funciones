; File: diab_init.s
;
; Abstract:
;   Links in the user initialization code so that we don't have to
;	 modify the diab startup code. This is a diab specific file.
;
; $Revision: 1.1 $
; $Date: 2002/09/13 09:03:23 $ 
;
; Copyright 2002 The MathWorks, Inc.

	.import usr_init
	.export __usr_init_link
	.globl  __usr_init_link
    ; Create a link into the user initialization code.
	.section .init$50,4,C
__usr_init_link:
	bl usr_init

.ifdef DIAB
    ; The DIAB startup code uses _start whilst the codewarrior uses __start.
    ; To make it easier in our application we will always refer to __start
    ; and if a DIAB build occurs create a mapping between __start and _start
    .export __start
    .globl  __start
    .section ".usr_init"
__start:
    b _start
.endif
