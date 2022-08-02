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
	mtspr	81,0
	li	0,((1<<6)|(1<<7))
	lis	3,0x2fc200@ha
	sth	0,0x2fc200@l(3)
	lis	3,0x2fc240@ha
	sth	0,0x2fc240@l(3)
	lis	1,st_stacks+128@ha
	addi	1,1,st_stacks+128@l
	lis	13,_SDA_BASE_@ha
	addi	13,13,_SDA_BASE_@l
	lis	2,_SDA2_BASE_@ha
	addi	2,2,_SDA2_BASE_@l
	li	5,0
	lis	3,_BSS_START_-1@ha
	addi	3,3,_BSS_START_-1@l
	lis	4,_BSS_END_-1@ha
	addi	4,4,_BSS_END_-1@l
	bl	__clear_bss
__clear_loop:
	stbu	5,1(3)
__clear_bss:
	cmpw	3,4
	bne	__clear_loop
	lis	3,_DATA_START_-1@ha
	addi	3,3,_DATA_START_-1@l
	lis	4,_DATA_END_-1@ha
	addi	4,4,_DATA_END_-1@l
	lis	5,_INIT_-1@ha
	addi	5,5,_INIT_-1@l
	bl	__copy_data
__copy_loop:
	lbzu	0,1(5)
	stbu	0,1(3)
__copy_data:
	cmpw	3,4
	bne	__copy_loop
	b	main
__eabi:
		blr
