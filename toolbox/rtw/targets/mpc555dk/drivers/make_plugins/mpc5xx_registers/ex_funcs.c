/**************************************************************************/
/* FILE NAME: ex_funcs.c                      COPYRIGHT (c) MOTOROLA 1999 */
/* VERSION: 1.3                                   All Rights Reserved     */
/*                                                                        */
/* DESCRIPTION:                                                           */
/* This file contains empty exception routines that are referenced by     */
/* the exception table file ex_tbl.s or ex_tblc.s. The reset exception    */
/* _start is not in this file, it is normally in crt0.s or crt0etas.s     */
/*========================================================================*/
/* COMPILER: Diab Data        VERSION: 4.2b                               */
/* AUTHOR: Jeff Loeliger                                                  */
/*                                                                        */
/* HISTORY                                                                */
/* REV      AUTHOR      DATE       DESCRIPTION OF CHANGE                  */
/* ---   -----------  ---------    ---------------------                  */
/* 1.0   J. Loeliger  14/Jan/98    Initial version of function.           */
/* 1.1   J. Loeliger   8/Apr/98    Added reserved routine.                */
/* 1.2   J. Loeliger  22/Apr/98    Fixed #pragma interrupt syntax.        */
/* 1.3   J. Loeliger  12/Jan/98    Replaced #pragma with INTERRUPT to     */
/*                                 make file generic for other compilers. */
/**************************************************************************/

#include "m_common.h"

INTERRUPT void reserved (void)
{
    while (1) {
    }
}

INTERRUPT void machine_check_exception (void)
{
    while (1) {
    }
}

INTERRUPT void data_access_exception (void)
{
    while (1) {
    }
}

INTERRUPT void instruct_access_exception (void)
{
    while (1) {
    }
}

INTERRUPT void external_interrupt (void)
{
    while (1) {
    }
}

INTERRUPT void alignment_exception (void)
{
    while (1) {
    }
}

INTERRUPT void program_exception (void)
{
    while (1) {
    }
}

INTERRUPT void fp_unavailable_exception (void)
{
    while (1) {
    }
}

INTERRUPT void decrementer_exception (void)
{
    while (1) {
    }
}

INTERRUPT void system_call_exception (void)
{
    while (1) {
    }
}

INTERRUPT void trace_exception (void)
{
    while (1) {
    }
}

INTERRUPT void fp_assist_exception (void)
{
    while (1) {
    }
}

INTERRUPT void software_emulation_exception (void)
{
    while (1) {
    }
}

INTERRUPT void instruction_protection_exception (void)
{
    while (1) {
    }
}

INTERRUPT void data_protection_exception (void)
{
    while (1) {
    }
}

INTERRUPT void data_breakpoint (void)
{
    while (1) {
    }
}

INTERRUPT void instruct_breakpoint (void)
{
    while (1) {
    }
}

INTERRUPT void maskable_external_breakpoint (void)
{
    while (1) {
    }
}

INTERRUPT void nonmaskable_external_breakpoint (void)
{
    while (1) {
    }
}

/*********************************************************************
 *
 * Copyright:
 *	MOTOROLA, INC. All Rights Reserved.  
 *  You are hereby granted a copyright license to use, modify, and
 *  distribute the SOFTWARE so long as this entire notice is
 *  retained without alteration in any modified and/or redistributed
 *  versions, and that such modified versions are clearly identified
 *  as such. No licenses are granted by implication, estoppel or
 *  otherwise under any patents or trademarks of Motorola, Inc. This 
 *  software is provided on an "AS IS" basis and without warranty.
 *
 *  To the maximum extent permitted by applicable law, MOTOROLA 
 *  DISCLAIMS ALL WARRANTIES WHETHER EXPRESS OR IMPLIED, INCLUDING 
 *  IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR
 *  PURPOSE AND ANY WARRANTY AGAINST INFRINGEMENT WITH REGARD TO THE 
 *  SOFTWARE (INCLUDING ANY MODIFIED VERSIONS THEREOF) AND ANY 
 *  ACCOMPANYING WRITTEN MATERIALS.
 * 
 *  To the maximum extent permitted by applicable law, IN NO EVENT
 *  SHALL MOTOROLA BE LIABLE FOR ANY DAMAGES WHATSOEVER (INCLUDING 
 *  WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS 
 *  INTERRUPTION, LOSS OF BUSINESS INFORMATION, OR OTHER PECUNIARY
 *  LOSS) ARISING OF THE USE OR INABILITY TO USE THE SOFTWARE.   
 * 
 *  Motorola assumes no responsibility for the maintenance and support
 *  of this software
 ********************************************************************/

