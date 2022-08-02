/* MEMLAYOUT.H
 *
 * This header file imports symbols that the build process for any
 * application must define. Generally the symbols will be generated
 * by the linker command file. These symbols allow the application
 * at run time to know which areas of memory can be read from and/or
 * written to.
 *
 *	Copyright 2003-2004 The MathWorks, Inc.
 *
 * $Revision: 1.1.6.3 $
 * $Date: 2004/04/19 01:25:39 $ 
 *
 * */
#ifndef _MEMLAYOUT_H_
#define _MEMLAYOUT_H_

#ifdef _MWERKS_
#define LINKER_SYMBOL_MOD __declspec(section ".init")
#else
#define LINKER_SYMBOL_MOD 
#endif

LINKER_SYMBOL_MOD extern char		 	_bootrom_org[];	/* Start of the boot rom */
LINKER_SYMBOL_MOD extern char		 	_bootrom_len[];	/* Length of boot rom    */
LINKER_SYMBOL_MOD extern char		 	_flash_org[];	   /* Start of the internal flash */
LINKER_SYMBOL_MOD extern char		 	_flash_len[];	   /* Length of the internal flash */
LINKER_SYMBOL_MOD extern char		 	_ram_org[];	      /* Start of the internal ram */
LINKER_SYMBOL_MOD extern char		 	_ram_len[];	      /* Length of internal ram */
LINKER_SYMBOL_MOD extern char		 	_e_ram_org[];	   /* Start of the external ram */
LINKER_SYMBOL_MOD extern char		 	_e_ram_len[];	   /* Length of the external ram */
LINKER_SYMBOL_MOD extern char       _application_exception_table_target_base[]; /* Run time location of Application Exception table */
LINKER_SYMBOL_MOD extern char       _application_exception_table_text_base[]; /* Text location of Application Exception table */
LINKER_SYMBOL_MOD extern char       _application_exception_table_size[]; /* Size of Application Exception table */

#endif
