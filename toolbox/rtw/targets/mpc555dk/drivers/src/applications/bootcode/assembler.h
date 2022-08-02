/*
 * File : assembler.h
 *
 * Abstract :
 * 
 * Low level assembler related utility functions
 *
 *	Copyright 2003 The MathWorks, Inc.
 *
 * $Revision: 1.1.6.2 $
 * $Date: 2004/04/19 01:24:46 $ 
*/
#ifndef _ASSEMBLER_H
#define _ASSEMBLER_H

#include "mpc5xx.h"

/* Assemble a RELATIVE branch instruction at instruction_address.
 * The instruction at instruction_address will branch to branch_target.
 * 
 * This function may be useful for installing simple exception handlers to aid
 * debugging.    For example, the code:
 *
 * assemble_relative_branch(c_decrementer_handler, (void *) 0x3F9824);
 *
 * would cause a branch instruction to the C-function c_decrementer_handler to 
 * be assembled at location 0x3F9824 (this is the location of the decrementer exception
 * entry in the secondary exception table in RAM that the bootcode forwards all exceptions 
 * to).
 *
 */
void assemble_relative_branch(void * branch_target, void * instruction_address); 

/* Assemble a rfi (Return From Interrupt) instruction at instruction_address.
 *
 * This function is useful for returning from interrupts immediately, and 
 * continuing normal program execution - this effectively ignores the interrupt. 
 *
 */
void assemble_rfi(void * instruction_address);

#endif
