;**************************************************************************
;* FILE NAME: ex_tbl.s                        COPYRIGHT (c) MOTOROLA 1999 *
;* VERSION: 1.2                                   All Rights Reserved     *
;*                                                                        *
;* DESCRIPTION:                                                           *
;* This file contains the exception table definitions for MPC500 devices. *
;* All exception routines are extern and imported to this file.           *
;*========================================================================*
;* ASSEMBLER: Diab Data        VERSION: 4.2b                              *
;* AUTHOR: Jeff Loeliger                                                  *
;*                                                                        *
;* HISTORY                                                                *
;* REV      AUTHOR      DATE       DESCRIPTION OF CHANGE                  *
;* ---   -----------  ---------    ---------------------                  *
;* 0.1   J. Dunlop      Jan/98     Initial version of file.               *
;* 1.0   J. Loeliger  14/Jan/98    Standard routine names and header added*
;* 1.1   J. Loeliger   8/Apr/98    Added support for MPC555               *
;*                                 Added all of the reserved entries      *
;*                                 Changed filename                       *
;* 1.2   J. Loeliger  22/Apr/98    Added support for alternate exception  *
;*                                 table location.                        *
;**************************************************************************

	.import _start, machine_check_exception, data_access_exception
	.import instruct_access_exception, external_interrupt
	.import alignment_exception, program_exception
	.import fp_unavailable_exception, decrementer_exception
	.import system_call_exception, trace_exception
	.import fp_assist_exception, software_emulation_exception
	.import instruction_protection_exception, data_protection_exception
	.import data_breakpoint, instruct_breakpoint
	.import maskable_external_breakpoint, nonmaskable_external_breakpoint
	.import reserved

	.name "ex_tbl.s"

base_add   .equ   0x00000000		;Can be 0x00000000 or 0xFFF00000

	.org base_add + 0x000		;Reserved this exception should
	b reserved			;never occur

	.org base_add + 0x100		;System Reset Exception
	b _start			;This is defined in the crt0.s file

	.org base_add + 0x200		;Machine Check Exception
	b machine_check_exception

	.org base_add + 0x300		;Data Access Exception
	b data_access_exception

	.org base_add + 0x400		;Instruction Access Exception
	b instruct_access_exception

	.org base_add + 0x500		;External Interrupt Exception
	b external_interrupt

	.org base_add + 0x600		;Alignment Exception
	b alignment_exception

	.org base_add + 0x700		;Program Exception
	b program_exception

	.org base_add + 0x800		;Floating Point Unavailable Exception
	b fp_unavailable_exception

	.org base_add + 0x900		;Decrementer Exception
	b decrementer_exception

	.org base_add + 0xA00		;Reserved this exception should
	b reserved			;never occur

	.org base_add + 0xB00		;Reserved this exception should
	b reserved			;never occur

	.org base_add + 0xC00		;System Call Exception
	b system_call_exception

	.org base_add + 0xD00		;Trace Exception
	b trace_exception

	.org base_add + 0xE00		;Floating Point Assist Exception
	b fp_assist_exception

	.org base_add + 0xF00		;Reserved this exception should
	b reserved			;never occur

	.org base_add + 0x1000		;Software Emulation Exception
	b software_emulation_exception

	.org base_add + 0x1100		;Reserved this exception should
	b reserved			;never occur

	.org base_add + 0x1200		;Reserved this exception should
	b reserved			;never occur

	.org base_add + 0x1300		;Instruction Protection Exception
	b instruction_protection_exception

	.org base_add + 0x1400		;Data Protection Exception
	b data_protection_exception

	.org base_add + 0x1500		;Reserved this exception should
	b reserved			;never occur

	.org base_add + 0x1600		;Reserved this exception should
	b reserved			;never occur

	.org base_add + 0x1700		;Reserved this exception should
	b reserved			;never occur

	.org base_add + 0x1800		;Reserved this exception should
	b reserved			;never occur

	.org base_add + 0x1900		;Reserved this exception should
	b reserved			;never occur

	.org base_add + 0x1A00		;Reserved this exception should
	b reserved			;never occur

	.org base_add + 0x1B00		;Reserved this exception should
	b reserved			;never occur

	.org base_add + 0x1C00		;Data Breakpoint Exception
	b data_breakpoint

	.org base_add + 0x1D00		;Instruction Breakpoint Exception
	b instruct_breakpoint

	.org base_add + 0x1E00		;Maskable External Breakpoint
	b maskable_external_breakpoint

	.org base_add + 0x1F00		;Nonmaskable External Breakpoint
	b nonmaskable_external_breakpoint

;*********************************************************************
;*
;* Copyright:
;*	MOTOROLA, INC. All Rights Reserved.  
;*  You are hereby granted a copyright license to use, modify, and
;*  distribute the SOFTWARE so long as this entire notice is
;*  retained without alteration in any modified and/or redistributed
;*  versions, and that such modified versions are clearly identified
;*  as such. No licenses are granted by implication, estoppel or
;*  otherwise under any patents or trademarks of Motorola, Inc. This 
;*  software is provided on an "AS IS" basis and without warranty.
;*
;*  To the maximum extent permitted by applicable law, MOTOROLA 
;*  DISCLAIMS ALL WARRANTIES WHETHER EXPRESS OR IMPLIED, INCLUDING 
;*  IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR
;*  PURPOSE AND ANY WARRANTY AGAINST INFRINGEMENT WITH REGARD TO THE 
;*  SOFTWARE (INCLUDING ANY MODIFIED VERSIONS THEREOF) AND ANY 
;*  ACCOMPANYING WRITTEN MATERIALS.
;* 
;*  To the maximum extent permitted by applicable law, IN NO EVENT
;*  SHALL MOTOROLA BE LIABLE FOR ANY DAMAGES WHATSOEVER (INCLUDING 
;*  WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS 
;*  INTERRUPTION, LOSS OF BUSINESS INFORMATION, OR OTHER PECUNIARY
;*  LOSS) ARISING OF THE USE OR INABILITY TO USE THE SOFTWARE.   
;* 
;*  Motorola assumes no responsibility for the maintenance and support
;*  of this software
;********************************************************************


