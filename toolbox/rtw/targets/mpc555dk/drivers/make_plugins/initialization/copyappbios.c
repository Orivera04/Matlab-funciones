/*
 * File : copyappbios.c
 *
 * Abstract:
 *    Shift Application BIOS to runtime position using
 *    symbols defined by the linker (memlayout.h)
 *
 * $Revision: 1.1.6.1 $
 * $Date: 2004/04/08 20:57:48 $
 *
 * Copyright 2004 The MathWorks, Inc.
 */

#include "memlayout.h"

/* Function to copy the Application BIOS from its
 * text location to its runtime Internal RAM location */
extern void copyappbios(void);

/* see header file for documentation */
extern void copyappbios(void) {
   /* relocate APPLICATION_EXCEPTION_TABLE */
   memcpy(_application_exception_table_target_base, 
          _application_exception_table_text_base, 
          _application_exception_table_size);
   return;
}
