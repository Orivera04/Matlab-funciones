/*===========================================================================*
 * mtypes.h								     *
 *									     *
 *	MPEG data types							     *
 *									     *
 *===========================================================================*/

/*
 * Copyright (c) 1993 The Regents of the University of California.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice and the following
 * two paragraphs appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 */

/*  
 *  $Header: /home/daf/mpeg/mpgwrite/RCS/mtypes.h,v 1.3 1994/01/12 21:10:58 daf Exp $
 *  $Log: mtypes.h,v $
 * Revision 1.3  1994/01/12  21:10:58  daf
 * Changed ERRCHK macro to send error messages to Matlab.
 *
 * Revision 1.2  1994/01/07  18:14:22  daf
 * Modified for use as .mex file.
 *
 * Revision 1.8  1993/07/22  22:24:23  keving
 * nothing
 *
 * Revision 1.7  1993/07/09  00:17:23  keving
 * nothing
 *
 * Revision 1.6  1993/06/03  21:08:53  keving
 * nothing
 *
 * Revision 1.5  1993/02/17  23:18:20  dwallach
 * checkin prior to keving's joining the project
 *
 * Revision 1.4  1993/01/18  10:20:02  dwallach
 * *** empty log message ***
 *
 * Revision 1.3  1993/01/18  10:17:29  dwallach
 * RCS headers installed, code indented uniformly
 *
 * Revision 1.3  1993/01/18  10:17:29  dwallach
 * RCS headers installed, code indented uniformly
 *
 */


#ifndef MTYPES_INCLUDED
#define MTYPES_INCLUDED


/*==============*
 * HEADER FILES *
 *==============*/

#include "pbmplus.h"
#include "pnm.h"
#include "general.h"
#include "dct.h"


/*===========*
 * CONSTANTS *
 *===========*/

#define TYPE_BOGUS	0   /* for the header of the circular list */
#define TYPE_VIRGIN	1

#define STATUS_EMPTY	0
#define STATUS_LOADED	1
#define STATUS_WRITTEN	2


/*==================*
 * TYPE DEFINITIONS *
 *==================*/

/*  
 *  your basic Block type
 */
typedef int16 Block[DCTSIZE][DCTSIZE];
typedef int16 FlatBlock[DCTSIZE_SQ];
typedef	    int32   LumBlock[2*DCTSIZE][2*DCTSIZE];


/*========*
 * MACROS *
 *========*/

#ifdef ABS
#undef ABS
#endif

#define ABS(x) (((x)<0)?-(x):(x))

#ifdef HEINOUS_DEBUG_MODE
#define DBG_PRINT(x) {printf x; fflush(stdout);}
#else
#define DBG_PRINT(x)
#endif

#define ERRCHK(bool, str) {if(!(bool)) {mexErrMsgTxt("Out of Memory.");}}



#endif /* MTYPES_INCLUDED */
