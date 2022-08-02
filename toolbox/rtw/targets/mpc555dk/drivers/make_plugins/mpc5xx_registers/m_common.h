/**************************************************************************/
/* FILE NAME: m_common.h                      COPYRIGHT (c) MOTOROLA 2002 */
/* VERSION:  1.3                                  All Rights Reserved     */
/*                                                                        */
/* DESCRIPTION:                                                           */
/* This file defines all of the data types for the MPC500 family. It also */
/* defines compiler specific paramaters. This file is included by all     */
/* individual modules.                                                    */
/*========================================================================*/
/* AUTHOR: Jeff Loeliger                                                  */
/* COMPILER: Diab Data        VERSION: 4.2b                               */
/*                                                                        */
/* UPDATE HISTORY                                                         */
/* REV      AUTHOR      DATE       DESCRIPTION OF CHANGE                  */
/* ---   -----------  ---------    ---------------------                  */
/* 0.1   J. Loeliger  06/Apr/98    Initial version of file.               */
/* 0.2                20/Dec/98    Added EXT section for new mpc555 files */
/* 1.0   J. Loeliger  12/Jan/99    Updated for new mpc555 files.          */
/* 1.1   J. Loeliger  25/Jan/99    Added setup comments.                  */
/* 1.2   J. Kobler    11/Jun/01    Added support for CodeWarrior.         */
/* 1.3   J. Loeliger  16/Apr/02    Created generic version for all MPC5xx.*/
/**************************************************************************/

#ifndef _M_COMMON_H
#define _M_COMMON_H

typedef signed char INT8;
typedef unsigned char UINT8;
typedef volatile signed char VINT8;
typedef volatile unsigned char VUINT8;

typedef signed short INT16;
typedef unsigned short UINT16;
typedef volatile signed short VINT16;
typedef volatile unsigned short VUINT16;

typedef signed int INT32;
typedef unsigned int UINT32;
typedef volatile signed int VINT32;
typedef volatile unsigned int VUINT32;

typedef float FLOAT32;
typedef double FLOAT64;

/**************************************************************************/
/* INTERNAL_MEMORY_BASE must be assigned to one of the following values:  */
/*  0x00000000  0x00400000  0x00800000  0x00C00000                        */
/*  0x01000000  0x01400000  0x01800000  0x01C00000                        */
/* The INTERMAL_MEMERY_BASE can be defined on the command line by using   */
/* option -D INTERNAL_MEMORY_BASE 0x00400000. If it is not defined on the */
/* command line then it will use the value in this file.                  */
/**************************************************************************/

/*  CodeWarrior EPPC:           __MWERKS__, Kobler

INTERNAL_MEMORY_BASE can be defined in a prefix file.
If it is not defined there it will use the value in this file.

*/

#ifndef INTERNAL_MEMORY_BASE
#define INTERNAL_MEMORY_BASE 0x00000000
#endif

#ifdef __DCC__                  /* only valid for Diab Compiler */
typedef signed long long INT64;
typedef unsigned long long UINT64;
typedef volatile signed long long VINT64;
typedef volatile unsigned long long VUINT64;

#define INTERRUPT __interrupt__

#else

/*****************************************************************/
/* The compiler specific modifier for interruput routines should */
/* be added here.                                                */
/*****************************************************************/ 
#define INTERRUPT

#endif /* ifdef __DCC__  */

#endif /* ifndef _M_COMMON_H  */

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

