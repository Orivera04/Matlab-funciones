/*  File: internal_flash.lcf
 *
 *  Abstract :
 * 	    Linker Command File	For Code Warrior Compiler Suite
 * 	    For FLASH Applications
 *
 * $Revision: 1.1.6.4 $
 * $Date: 2004/04/19 01:24:31 $
 *
 * Copyright 2003-2004 The MathWorks, Inc.
 *
*/

MEMORY \{
   bootrom:    org = {$bootrom_org}, len = {$bootrom_len}   /* Flash Boot Sector */
   rom:        org = {$bootrom_len}, len = 0x{sprintf('%x',eval($flash_len)-eval($bootrom_len))}  /* Flash Application Sector */       
   iram:       org = {$ram_org},     len = {$ram_len} 
\}

/* avoid dead stripping these files */
FORCEFILES \{ start.o __ppc_eabi_init.o exceptions.o \}

SECTIONS \{

   GROUP : \{
			.flash_entry : \{\} /* Locate the entry point at ${romorg} */
         .text  : \{\} 
         .rodata (CONST) : \{
             *(.rdata)
             *(.rodata)
         \}
         .application_bios : \{ \} /* For forwarding of exceptions */ 
         .ctors : \{\}
         .dtors : \{\}
         .BINARY : \{\}
         extab : \{\}
         extabindex : \{\}

        .init : \{\}
        .usr_init : \{\}
        .fini : \{\}
    \} > rom

   /* APPLICATION_EXCEPTION_TABLE will be copied to 
      IRAM during initialisation - save space for it */ 
	GROUP : \{
      _application_exception_table_target_base = .;

      /* Advance the code above the application exception table */
      . = . + _application_exception_table_size;
		
      .data : \{\}
      .sdata : \{\}
      .sbss : \{\}
      .sdata2 : \{\}
      .sbss2 : \{\}
      .bss : \{\}
      .PPC.EMB.sdata0 : \{\}
      .PPC.EMB.sbss0 : \{\}
      _stack_end = .;
    \} > iram

\}

_stack_addr = 0x{$x = eval($ram_org) + eval($ram_len) - 8;sprintf('%x',$x)};

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

/* Note we do not specify any heap address as there is no
   heap requirement. If a heap is required then we must
   define some heap space. */

/* Release 2 of the linker generated slightly different names.  */
/* The following are aliases to the new names and are only      */
/* necessary if you are using Release 2 startup code with the   */
/* current linker.                                              */

_finit = _f_init;
_finit_rom = _f_init_rom;
_init_size = SIZEOF(.init);

_ftext = _f_text;
_ftext_rom = _f_text_rom;
_text_size = SIZEOF(.text);

_frdata = _f_rodata;
_frdata_rom = _f_rodata_rom;
_rdata_size = SIZEOF(.rodata);

_extab_size = SIZEOF(extab);

_feti = _fextabindex;
_feti_rom = _fextabindex_rom;
_eti_size = SIZEOF(extabindex);

_fdata = _f_data;
_fdata_rom = _f_data_rom;
_data_size = SIZEOF(.data);

_fsdata = _f_sdata;
_fsdata_rom = _f_sdata_rom;
_sdata_size = SIZEOF(.sdata);

_fsbss = _f_sbss;
_sbss_size = SIZEOF(.sbss);

_fsdata2 = _f_sdata2;
_fsdata2_rom = _f_sdata2_rom;
_sdata2_size = SIZEOF(.sdata2);

_fsbss2 = _f_sbss2;
_sbss2_size = SIZEOF(.sbss2);

_fbss = _f_bss;
_bss_size = SIZEOF(.bss);

_fsdata0 = _f_PPC_EMB_sdata0;
_fsdata0_rom = _f_PPC_EMB_sdata0_rom;
_sdata0_size = SIZEOF(.PPC.EMB.sdata0);

_fsbss0 = _f_PPC_EMB_sbss0;
_sbss0_size = SIZEOF(.PPC.EMB.sbss0);

_stack_size = _stack_addr - _stack_end;
_heap_size = _heap_end - _heap_addr;
