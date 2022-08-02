;**************************************************************************
;*                                            COPYRIGHT (c) MOTOROLA 1998 *
;* FILE NAME: ex_tblc.s                                                   *
;*                                                                        *
;* INCLUDE FILES: none                                                    *
;* VERSION: 1.0                                                           *
;*                                                                        *
;*========================================================================*
;*                                                                        *
;* DESCRIPTION:                                                           *
;* This file contains the reduced size exception table definitions for    *
;* the MPC555 using the exception table relocation feature.               *
;* All exception routines are extern and imported to this file.           *
;*                                                                        *
;*========================================================================*
;*                                                                        *
;* ASSEMBLER: Diab Data        VERSION: 4.1a:1                            *
;*                                                                        *
;* AUTHOR: Jeff Loeliger                   CREATION DATE:   8/Apr/98      *
;* LOCATION: East Kilbride, Scotland.                                     *
;*                                                                        *
;* UPDATE HISTORY                                                         *
;* REV      AUTHOR      DATE       DESCRIPTION OF CHANGE                  *
;* ---   -----------  ---------    ---------------------                  *
;* 1.0   J. Loeliger   8/Apr/98    Inital version of file                 *
;*                                                                        *
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

	.name "ex_tblc.s"

	.org 0x000			;Reserved this exception should
	b reserved			;never occur

	.org 0x008			;System Reset Exception
	b _start			;This is defined in the crt0.s file

	.org 0x010			;Machine Check Exception
	b machine_check_exception

	.org 0x018			;Data Access Exception
	b data_access_exception

	.org 0x020			;Instruction Access Exception
	b instruct_access_exception

	.org 0x028			;External Interrupt Exception
	b external_interrupt

	.org 0x030			;Alignment Exception
	b alignment_exception

	.org 0x038			;Program Exception
	b program_exception

	.org 0x040			;Floating Point Unavailable Exception
	b fp_unavailable_exception

	.org 0x048			;Decrementer Exception
	b decrementer_exception

	.org 0x050			;Reserved this exception should
	b reserved			;never occur

	.org 0x058			;Reserved this exception should
	b reserved			;never occur

	.org 0x060			;System Call Exception
	b system_call_exception

	.org 0x068			;Trace Exception
	b trace_exception

	.org 0x070			;Floating Point Assist Exception
	b fp_assist_exception

	.org 0x078			;Reserved this exception should
	b reserved			;never occur

	.org 0x080			;Software Emulation Exception
	b software_emulation_exception

	.org 0x088			;Reserved this exception should
	b reserved			;never occur

	.org 0x090			;Reserved this exception should
	b reserved			;never occur

	.org 0x098			;Instruction Protection Exception
	b instruction_protection_exception

	.org 0x0A0			;Data Protection Exception
	b data_protection_exception

	.org 0x0A8			;Reserved this exception should
	b reserved			;never occur

	.org 0x0B0			;Reserved this exception should
	b reserved			;never occur

	.org 0x0B8			;Reserved this exception should
	b reserved			;never occur

	.org 0x0C0			;Reserved this exception should
	b reserved			;never occur

	.org 0x0C8			;Reserved this exception should
	b reserved			;never occur

	.org 0x0D0			;Reserved this exception should
	b reserved			;never occur

	.org 0x0D8			;Reserved this exception should
	b reserved			;never occur

	.org 0x0E0			;Data Breakpoint Exception
	b data_breakpoint

	.org 0x0E8			;Instruction Breakpoint Exception
	b instruct_breakpoint

	.org 0x0F0			;Maskable External Breakpoint
	b maskable_external_breakpoint

	.org 0x0F8			;Nonmaskable External Breakpoint
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



