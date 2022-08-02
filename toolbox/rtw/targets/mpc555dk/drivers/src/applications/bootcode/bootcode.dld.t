/* File: bootcode.dld
 * 
 *
 * $Revision: 1.1.6.2 $
 * $Date: 2003/12/11 03:48:40 $
 *
 * Modified from the original file
 *    diab\4.3g\conf\default.dld
 * in the Windriver Diab Compiler.
 *
 * There was no copyright in the original file.
 */

MEMORY
\{
    bootrom:   org = {$bootrom_org} ,   len = {$bootrom_len} /* CMF Flash A : Boot Sector */
    ram:       org = {$ram_org},        len = {$ram_len}    /* Internal SRAM for bootcode */ 
\}


SECTIONS 
\{
    GROUP ALIGN (4) : 
    \{
        __BOOT_ROM = .;
        /* Boot bios should live at 0x104 which is the end of the exception_table. The
         * exception table is located with absolute .org statements in exception_table.o
         * The next available address will be 0x104. The boot_bios is a function pointer
         * table available to any application. The functions will generally be a instruction
         * to perform a processor reset then execute some post reset action. */
        .boot_bios       : \{ *(.boot_bios) *(.boot_bios_u) \}
        .init            : \{  \}
        .usr_init   : \{ \}
        /* Place all text sections not required during the flash process in
        * flash so as to preserve as much internal RAM as possible */
        . = ( . + 3 ) & ~3;
        .text_init : \{ main.o(.text) init.o(.text) memcpy.o(.text) memset.o(.text) crt0.o(.text) boot_bios.o(.text) \}
        .fini            : \{ \}
        __END_BOOT_ROM = . ;
    \} > bootrom

    GROUP  : 
    \{
        APPLICATION_EXCEPTION_TABLE_BASE = .;

        /* Advance the code above the application exception table */
        . = . + 0x78;

        /* Obtain the next valid 4-byte aligned address to place ROM based data or code */
        __DATA_ROM = (__END_BOOT_ROM + 3) & ~3;

        __DATA_RAM = .;

        /* The application bios is the application exception table. Though we load it here when
         * the bootcode loads an application it will be over-written by the applications version
         * of this section. */
        .text              LOAD(__DATA_ROM + ADDR( .text)            -  ADDR(.text)) : \{\}
        .data              LOAD(__DATA_ROM + ADDR( .data)            -  ADDR(.text)) : \{\}
        .sdata             LOAD(__DATA_ROM + ADDR(.sdata)            -  ADDR(.text)) : \{\}
        .sdata2            LOAD(__DATA_ROM + ADDR(.sdata2)           -  ADDR(.text)) : \{\}

        __DATA_END = .;

        __BSS_START = .;
        .sbss : \{\}
        .bss (BSS) : \{\}
        __BSS_END = .;

		/* Any remaining space will be used as stack.  */
		_stack_end = .;


    \} > ram


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

__HEAP_START   = addr(ram   ) + SIZEOF(ram   );
__HEAP_END     = ADDR(ram   ) + SIZEOF(ram   );
__SP_INIT = 0x{$x = eval($ram_org) + eval($ram_len) - 8;sprintf('%x',$x)};
__SP_END  = _stack_end;

/* See memlayout.h for these required symbols */
_bootrom_org =  {$bootrom_org};
_bootrom_len =  {$bootrom_len};
_flash_org   =  {$flash_org};
_flash_len   =  {$flash_len};
_ram_org	    =	 {$ram_org};
_ram_len	    =	 {$ram_len};
_e_ram_org   =  {$e_ram_org};
_e_ram_len   =  {$e_ram_len};

/* ----------------------------------------------------------------------------
 * Additional notes:
 * ----------------------------------------------------------------------------
 * (1)  Constants and strings will be in the .text segment unless the
 *      -Xconst-in-text=0 option is used.
 *
 * (2)  If __SP_END and __HEAP_END point to the same address (i.e., the "ram"
 *      and "stack" memory areas are contiguous), then programs compiled with
 *      -Xstack-probe or -Xrtc will allocate more stack from the top of the
 *      heap on stack overflow if possible (see __sp_grow() in sbrk.c).
 * ------------------------------------------------------------------------- */
