#
#	crt0m500.s: startup for an embedded environment, PowerPC 500
#	------------------------------------------------------------
#
#	Copyright 1998 Diab Data, Inc.
#
# This code was modified by Motorola for use with the Motorola PowerPC 500
# version 1.0 Jeff Loeliger 13 Jan 1999.
# version 1.1 Jeff Loeliger 25 Jun 1999, changed filename and comments
#

	.file		"crt0m500.s"
	.text
	.globl		_start
	.align		2
	addi		r0,r0,0		# Debuggers may object to starting at 0.

_start:
	addis		r11,r0,__SP_INIT@ha	# Initialize stack pointer r1 to
	addi		r1,r11,__SP_INIT@l	# value in linker command file.
	addis		r13,r0,_SDA_BASE_@ha	# Initialize r13 to sdata base
	addi		r13,r13,_SDA_BASE_@l	# (provided by linker).
	addis		r2,r0,_SDA2_BASE_@ha	# Initialize r2 to sdata2 base
	addi		r2,r2,_SDA2_BASE_@l	# (provided by linker).
	addi		r0,r0,0			# Clear r0.
	stwu		r0,-64(r1)		# Terminate stack.

#
# Insert other initialize code here.
#
#------------------------------------------------------------
# Start of code added to initialize the Motorola/ETAS MPC555 EVB.
#
#	bl		setup_mpc555
#
# End of code added for Motorola/ETAS MPC555 EVB
#------------------------------------------------------------

	bl		__init_main	# Finish initialization; call main().
	b		exit		# Never returns.
	bl		main		# Dummy to pull in main() as soon as
					# possible.
    
#------------------------------------------------------------- .init section --
	.section	.init$00,2,C
	.globl		__init
__init:					# Entry to __init, called by
	mfspr		r0,8		# __init_main called above.
	stwu		r1,-64(r1)
	stw		r0,68(r1)

	# Linker places .init sections from other modules, containing	    
	# calls to initialize global objects, here.			    

	.section	.init$99,2,C
	lwz		r0,68(r1)	# Return from __init.
	addi		r1,r1,64
	mtspr		8,r0
	blr

#------------------------------------------------------------- .fini section --
	.section	.fini$00,2,C
	.globl		__fini
__fini:					# Entry to __fini, called by exit().
	mfspr		r0,8
	stwu		r1,-64(r1)
	stw		r0,68(r1)

	# Linker places .fini sections from other modules, containing	    
	# calls to destroy global objects, here.			    

	.section	.fini$99,2,C
	lwz		r0,68(r1)	# Return from __fini.
	addi		r1,r1,64
	mtspr		8,r0
	blr
