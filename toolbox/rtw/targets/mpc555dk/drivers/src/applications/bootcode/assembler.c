/*
 * File : assembler.c
 *
 * Abstract:
 * 	Low level assembler related utility functions
 *
 * $Revision: 1.1.6.1 $
 * $Date: 2003/07/31 18:06:47 $
 *
 * Copyright 2003 The MathWorks, Inc.
 */

#include "assembler.h"

void assemble_relative_branch(void * branch_target, void * instruction_address) {
   /* calculate the offset required to branch to the branch_target */
   UINT32 offset = (UINT32) branch_target - (UINT32) instruction_address;
   /* Note: offset must be a signed 26 bit value and word aligned.
    * 
    * If the branch_target is some place in the bootcode (perhaps a C-fcn) then
    * this should always be the case --> do not check offset, just mask it
    * with 0x3FFFFFC .
    *
    * The branch instruction is 0x12 in the top 6 bits, hence the shift.
    *
    * See the RCPU Instruction Set manual for more details of the
    * branch instruction. */
   UINT32 branchinst = (0x12000000 << 2) | ( offset & 0x3FFFFFC );
   /* Set the generated branch instruction at the instruction_address */
   *((UINT32 *) instruction_address) = branchinst;
}

void assemble_rfi(void * instruction_address) {
   /* set the RFI instruction code at the instruction_address */
   #define RFI_INSTRUCTION 0x4C000064
   *((UINT32 *) instruction_address) = RFI_INSTRUCTION;
   #undef RFI_INSTRUCTION
}
