/*
 * File: internal_flash.dld
 * 
 * Abstract:
 * 	Linker Command File
 *
 * 	For DIAB Compiler Suite
 *
 * 	For FLASH Applications
 *
 * Copyright 2003-2004 The MathWorks, Inc.
 *
 * $Revision: 1.1.6.4 $
 * $Date: 2004/04/19 01:24:30 $
 *
 */

MEMORY
\{
   bootrom:    org = {$bootrom_org}, len = {$bootrom_len}   /* Flash Boot Sector */
   rom:        org = {$bootrom_len}, len = 0x{sprintf('%x',eval($flash_len)-eval($bootrom_len))}  /* Flash Application Sector */       
   iram:       org = {$ram_org},     len = {$ram_len} 
\}

SECTIONS
\{
    /* Collect all code sections from all input files to make a single output
     * .text section and locate it in "rom" memory (except for .text2 code
     * sections).                                                            */

    GROUP : \{
		.flash_entry : \{\} /* Locate the entry point at ${romorg} */
		.text (TEXT) : \{ 
			*(.extint) 
			*(.text) 
			*(.init) 
			*(.usr_init)
			*(.fini) 
		\}

      /* special application bios section */
      .application_bios (TEXT) : \{\}

      /* ROM location of data items */
		__END_BOOT_ROM = . ;

    \} > rom 

GROUP : \{
      _application_exception_table_target_base = .;

      /* Advance the code above the application exception table */
      . = . + _application_exception_table_size;
      
	  	/* Obtain the next valid 4-byte aligned address to place ROM based data or code */
      /* ROM location of data items */
	  	__DATA_ROM = (__END_BOOT_ROM + 3) & ~3;

      /* RAM location of data items */
		__DATA_RAM	= .;

      

      .data              LOAD(__DATA_ROM + ADDR( .data)            -  ADDR(.data)) : \{\}
      .sdata             LOAD(__DATA_ROM + ADDR(.sdata)            -  ADDR(.data)) : \{\}
      .sdata2            LOAD(__DATA_ROM + ADDR(.sdata2)           -  ADDR(.data)) : \{\}

		__DATA_END	= .;

		/* Allocate uninitialized sections.				 */

		__BSS_START	= .;
		.sbss : \{\}
		.bss  : \{\}
		__BSS_END	= .;

		/* Any remaining space will be used as stack.  */
		_stack_end = .;
	\} > iram

\}

_stack_addr = 0x{$x = eval($ram_org) + eval($ram_len) - 8;sprintf('%x',$x)};  /* End of internal RAM */

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
/* generate symbols for Application Exception table relocation */
_application_exception_table_text_base = ADDR(.application_bios);
_application_exception_table_size = SIZEOF(.application_bios);

