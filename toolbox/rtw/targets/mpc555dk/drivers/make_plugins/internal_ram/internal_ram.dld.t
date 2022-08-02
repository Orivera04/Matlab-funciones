/*
 * File: app_ram.dld
 *
 * Abstract:
 * 	Linker Command File
 *
 * 	For DIAB Compiler Suite
 *
 * 	For RAM Applications
 *
 * $Revision: 1.1.6.1 $
 * $Date: 2003/12/11 03:48:21 $
 *
 * Modified from the original file
 *    diab\4.3g\conf\default.dld
 * in the Windriver Diab Compiler.
 *
 * There was no copyright in the original file.
 */

MEMORY
\{
	/* External SRAM 128 k for heap */
	iram:   org = {$ram_org}, len = {$ram_len} 
\}

SECTIONS
\{
    /* Collect all code sections from all input files to make a single output
     * .text section and locate it in "rom1" memory (except for .text2 code
     * sections).                                                            */

    GROUP : \{

		.text (TEXT) : \{ 
			*(.extint) 
			*(.text) 
			*(.init) 
            *(.usr_init)
			*(.fini) 
		\}
		.sdata2 (DATA) : \{\}

		/* This must be the first item */

		.data (DATA) : \{\}

		.sdata (DATA) : \{\}

		__DATA_END	= .;

		/* Allocate uninitialized sections.			    */

		__BSS_START	= .;
		.sbss : \{\}
		.bss  : \{\}
		__BSS_END	= .;

		__DATA_ROM	= .;
		__DATA_RAM	= .;

		/* Any remaining space will be used as stack.  */
		_stack_end = .;

    \} > iram

\}


/* Definitions of identifiers used by sbrk.c, init.c and the different
 * crt0.s files. Their purpose is to control initialization and memory
 * memory allocation.
 *
 * __HEAP_START : Used by sbrk.c: start of memory used by malloc() etc.
 * __HEAP_END   : Used by sbrk.c: end of heap memory
 * __SP_INIT    : Used by crt0.s: initial address of stack pointer
 * __SP_END     : Used by sbrk.c: only used when stack probing
 * __DATA_ROM   : Used by init.c: start of initialized data in ROM
 * __DATA_RAM   : Used by init.c: start of initialized data in RAM
 * __DATA_END   : Used by init.c: end of initialized data in RAM
 * __BSS_START  : Used by init.c: start of uninitialized data
 * __BSS_END    : Used by init.c: end of data to be cleared
 * ------------------------------------------------------------------------- */

/* No Heap Used */
__HEAP_START   = 0;
__HEAP_END     = 0;
__SP_INIT      = 0x{$x = eval($ram_org) + eval($ram_len) - 8;sprintf('%x',$x)};
__SP_END       = _stack_end;

/* See memlayout.h for these required symbols */
_bootrom_org =  {$bootrom_org};
_bootrom_len =  {$bootrom_len};
_flash_org   =  {$flash_org};
_flash_len   =  {$flash_len};
_ram_org	    =	 {$ram_org};
_ram_len	    =	 {$ram_len};
_e_ram_org   =  {$e_ram_org};
_e_ram_len   =  {$e_ram_len};

