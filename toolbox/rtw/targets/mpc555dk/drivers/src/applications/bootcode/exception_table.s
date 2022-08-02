#
# File: exception_table.s
#
# Abstract:
# 	The bootcode exception table. The exception
# 	table is in compressed mode located at 0x0
#
#
# $Revision: 1.6.8.5 $
# $Date: 2004/04/19 01:25:03 $
#
# Copyright 2001-2004 The MathWorks, Inc.
   
   .import __start

   .file "exception_table.s"

   .ifdef DIAB
      ;Do nothing
   .else
      #ifdef CODE_WARRIOR
         ;Metrowerks doesn't like assembly code in unamed
         ;sections 
         .section .exception_table
      #else
         .error Not Supported
      #endif
   .endif

   .include "bootver.s"

   ;APPLICATION_EXCEPTION_TABLE_BASE will be passed in as a flag on the compile
   ;line. The makefile will detect the processor variant and choose the value.
   ;The APPLICATION_EXCEPTION_TABLE_BASE is the location that applications will
   ;intercept exceptions forwarded by the bootcode.
   RESET_EXCEPTION			                  .equ APPLICATION_EXCEPTION_TABLE_BASE + 4*1
   MACHINE_CHECK_EXCEPTION                   .equ APPLICATION_EXCEPTION_TABLE_BASE + 4*2
   DATA_ACCESS_EXCEPTION                     .equ APPLICATION_EXCEPTION_TABLE_BASE + 4*3
   INSTRUCT_ACCESS_EXCEPTION                 .equ APPLICATION_EXCEPTION_TABLE_BASE + 4*4
   EXTERNAL_INTERRUPT_EXCEPTION              .equ APPLICATION_EXCEPTION_TABLE_BASE + 4*5
   ALIGNMENT_EXCEPTION                       .equ APPLICATION_EXCEPTION_TABLE_BASE + 4*6
   PROGRAM_EXCEPTION                         .equ APPLICATION_EXCEPTION_TABLE_BASE + 4*7
   FP_UNAVAILABLE_EXCEPTION                  .equ APPLICATION_EXCEPTION_TABLE_BASE + 4*8
   DECREMENTER_EXCEPTION                     .equ APPLICATION_EXCEPTION_TABLE_BASE + 4*9
   SYSTEM_CALL_EXCEPTION                     .equ APPLICATION_EXCEPTION_TABLE_BASE + 4*10
   TRACE_EXCEPTION                           .equ APPLICATION_EXCEPTION_TABLE_BASE + 4*11
   FP_ASSIST_EXCEPTION                       .equ APPLICATION_EXCEPTION_TABLE_BASE + 4*12
   SOFTWARE_EMULATION_EXCEPTION              .equ APPLICATION_EXCEPTION_TABLE_BASE + 4*13
   INSTRUCTION_PROTECTION_EXCEPTION          .equ APPLICATION_EXCEPTION_TABLE_BASE + 4*14
   DATA_PROTECTION_EXCEPTION                 .equ APPLICATION_EXCEPTION_TABLE_BASE + 4*15
   DATA_BREAKPOINT_EXCEPTION                 .equ APPLICATION_EXCEPTION_TABLE_BASE + 4*16 
   INSTRUCT_BREAKPOINT_EXCEPTION             .equ APPLICATION_EXCEPTION_TABLE_BASE + 4*17
   MASKABLE_EXTERNAL_BREAKPOINT_EXCEPTION    .equ APPLICATION_EXCEPTION_TABLE_BASE + 4*18
   NONMASKABLE_EXTERNAL_BREAKPOINT_EXCEPTION .equ APPLICATION_EXCEPTION_TABLE_BASE + 4*19
  
;System Reset Exception
    .org  0x8        
__start_bootcode_entry:
   ba __start
    
;Machine Check Exception
    .org  0x10        
machine_check_exception_bootcode_entry:
   ba MACHINE_CHECK_EXCEPTION

;Data Access Exception
    .org  0x18        
data_access_exception_bootcode_entry:
   ba DATA_ACCESS_EXCEPTION

;Instruction Access Exception
    .org  0x20        
instruct_access_exception_bootcode_entry:
   ba INSTRUCT_ACCESS_EXCEPTION

;External Interrupt Exception
    .org  0x28        
external_interrupt_exception_bootcode_entry:
   ba EXTERNAL_INTERRUPT_EXCEPTION

;Alignment Exception
    .org  0x30        
alignment_exception_bootcode_entry:
   ba ALIGNMENT_EXCEPTION

;Program Exception
    .org  0x38    
program_exception_bootcode_entry:
   ba PROGRAM_EXCEPTION

;Floating Point Unavailable Exception
    .org  0x40    
fp_unavailable_exception_bootcode_entry:
   ba FP_UNAVAILABLE_EXCEPTION

;Decrementer Exception
    .org  0x48    
decrementer_exception_bootcode_entry:
   ba DECREMENTER_EXCEPTION

;Reserved this exception should
;never occur
    .org  0x50        
   ba reserved                  

;Reserved this exception should
;never occur                    
    .org  0x58        
   ba reserved                  

;System Call Exception
    .org  0x60        
system_call_exception_bootcode_entry:
   ba SYSTEM_CALL_EXCEPTION 

;Trace Exception
    .org  0x68        
trace_exception_bootcode_entry:
   ba TRACE_EXCEPTION 

;Floating Point Assist Exception
    .org  0x70    
fp_assist_exception_bootcode_entry:
   ba FP_ASSIST_EXCEPTION 

;Reserved this exception should
;never occur
    .org  0x78   
   ba reserved             

;Software Emulation Exception
software_emulation_exception_bootcode_entry:
    .org  0x80    
   ba SOFTWARE_EMULATION_EXCEPTION 

;Reserved this exception should
;never occur
    .org  0x88   
   ba reserved             

;Reserved this exception should
;never occur
    .org  0x90   
   ba reserved             

    .org  0x98    ;Storage Exception
instruction_protection_bootcode_entry:
   ba INSTRUCTION_PROTECTION_EXCEPTION 

	 .org  0xA0    ;Data Protection Exception
data_protection_bootcode_entry:
   ba DATA_PROTECTION_EXCEPTION 

    .org  0xA8    ;Reserved this exception should
   ba reserved              ;never occur

    .org  0xB0    ;Reserved this exception should
   ba reserved              ;never occur

    .org  0xB8    ;Reserved this exception should
   ba reserved              ;never occur

    .org  0xC0    ;Reserved this exception should
   ba reserved              ;never occur

    .org  0xC8    ;Reserved this exception should
   ba reserved              ;never occur

    .org  0xD0    ;Reserved this exception should
   ba reserved              ;never occur

    .org  0xD8    ;Reserved this exception should
   ba reserved              ;never occur

    .org  0xE0    ;Data Breakpoint Exception
data_breakpoint_bootcode_entry:
   ba DATA_BREAKPOINT_EXCEPTION 

    .org  0xE8    ;Instruction Breakpoint Exception
instruct_breakpoint_bootcode_entry:
   ba INSTRUCT_BREAKPOINT_EXCEPTION

;Maskable External Breakpoint
    .org  0xF0    
maskable_external_breakpoint_bootcode_entry:
   ba MASKABLE_EXTERNAL_BREAKPOINT_EXCEPTION 

;Nonmaskable External Breakpoint
    .org  0xF8    
nonmaskable_external_breakpoint_bootcode_entry:
   ba NONMASKABLE_EXTERNAL_BREAKPOINT_EXCEPTION

    .org  0x100      ; Hard Reset Entry Point. At reset the
                     ; the exception table is not yet compressed
                     ; so we need to use the default entry point.
hard_reset_entry:
   ba __start

    ; The next available memory location is 0x104


	.text

; infinite loop handler for reserved exceptions
reserved:
  b reserved
