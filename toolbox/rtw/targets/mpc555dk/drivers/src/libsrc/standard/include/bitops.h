/*
 * File: bitops.h
 *
 * Abstract: Required header file for TouCAN / TPU interrupts
 *
 * $Revision: 1.2 $
 * $Date: 2002/11/12 11:51:00 $
 *
 * Copyright 2002 The MathWorks, Inc.
 */

#ifndef _BITOPS_H_
#define _BITOPS_H_

#define BITAT(bit) ( 0x1U << (bit)) 
#define BITSET(src,bit) ( src = (src | BITAT(bit)) )
#define BITCLR(src,bit) ( src = ( src & (~BITAT(bit)) ) )
#define BITGET(src,bit) (( (src) >> bit ) & 0x1U)

/* Insertion Utilities similar to C Bit Field Operations */

/* Generate an n ones bit pattern, right adjusted by 'shift' */
#define N_ONES_RA(n,shift) (((1 << n) - 1) << shift) 

/* Generate an n zeros bit pattern, right adjusted by 'shift' */
#define N_ZEROS_RA(n,shift) (~N_ONES_RA(n,shift))

/* Generate the bit pattern created by inserting 'source' bits of given 'size', 
 * into the 'target', at the specified, right adjusted, 'shift' position */
#define INSERT_RA(source, target, size, shift)                                             \
   /* mask target and source, shift source, then or together */                            \
   ((target & N_ZEROS_RA(size, shift)) | (((source & N_ONES_RA(size,0)) << shift)))

#endif
