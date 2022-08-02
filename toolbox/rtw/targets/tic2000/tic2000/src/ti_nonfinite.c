/* Copyright 2003-2004 The MathWorks, Inc.
 *
 * File: ti_nonfinite.c
 *
 * Abstract:
 *      Real-Time Workshop function to initialize non-finites,
 *      (Inf, NaN and -Inf).  Re-implemented and renamed for 
 *      use with c2000 TI target.
 *
 * $Revision: 1.2.4.2 $ $Date: 2004/04/08 20:58:51 $
 */

#include <stdio.h>
#include <stdlib.h>
#include "rt_nonfinite.h"

real_T rtInf;
real_T rtMinusInf;
real_T rtNaN;

/* Function: rt_InitInfAndNaN ==================================================
 * Abstract:
 *	Initialize the rtInf, rtMinusInf, and rtNaN needed by the 
 *	generated code. NaN is initialized as non-signaling. Assumes IEEE.
 */
void rt_InitInfAndNaN(int_T realSize)
{
	typedef struct {
		uint16_T fractionLo  : 16;
		uint16_T fractionHi  : 7;
		uint16_T exponent    : 8;
		uint16_T sign        : 1;
	} LittleEndianIEEEDouble;	
		
	/* This chip is always Little Endian */

	(*(LittleEndianIEEEDouble*)&rtInf).sign        = 0;
	(*(LittleEndianIEEEDouble*)&rtInf).exponent    = 0xFF;
	(*(LittleEndianIEEEDouble*)&rtInf).fractionLo  = 0;
	(*(LittleEndianIEEEDouble*)&rtInf).fractionHi  = 0;              
	rtMinusInf = rtInf;
	rtNaN = rtInf;
	(*(LittleEndianIEEEDouble*)&rtMinusInf).sign   = 1;
	(*(LittleEndianIEEEDouble*)&rtNaN).fractionLo  = 0xFFFF;
	(*(LittleEndianIEEEDouble*)&rtNaN).fractionHi  = 0x7F;

} /* end rt_InitInfAndNaN */
