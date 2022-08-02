; File: dec_handler.s
;
; Abstract:
;   Handle the decrementer exception.
;
; $Revision: 1.1.6.1 $
; $Date: 2003/04/23 06:26:49 $ 
;
; Copyright 2003 The MathWorks, Inc.

	.file "dec_handler.s"
	.text
	.export decrementer_isr
decrementer_isr:
	;; A simple return from interrupt means that the decrementer exception
	;; is effectively ignored.
	rfi
