/**************************************************************************/
/* FILE NAME: m_sram.h                        COPYRIGHT (c) MOTOROLA 2002 */
/* VERSION:  1.3                                  All Rights Reserved     */
/*                                                                        */
//* DESCRIPTION:                                                          */
/* This file defines all of the registers and bit fields on the SRAM      */
/* modules and declares an instance of the SRAM structure.                */
/*========================================================================*/
/* AUTHOR: Jeff Loeliger                                                  */
/* COMPILER: Diab Data        VERSION: 4.3f                               */
/*                                                                        */
/* HISTORY                                                                */
/* REV      AUTHOR      DATE       DESCRIPTION OF CHANGE                  */
/* ---   -----------  ---------    ---------------------                  */
/* 0.1   J. Loeliger  06/Apr/98    Initial version of file.               */
/* 0.2                20/Dec/98    Broke header file into modules.        */
/* 1.0   J. Loeliger  12/Jan/99    Added three ways to create an instance */
/*                                   of the module and added PACK.        */
/* 1.1   J. Loeliger  22/Jun/99    Added ifdef to support C++             */
/* 1.2   J. Kobler    11/Jun/01    Added support for CodeWarrior Embedded */
/*                                   PowerPc 5.0.                         */
/* 1.3   J. Loeliger  16/Apr/02    Created generic version for all MPC5xx.*/
/*    								 Merged flash and uc3f.               */
/**************************************************************************/

#ifndef _M_SRAM_H
#define _M_SRAM_H

#ifndef _M_COMMON_H
#include "m_common.h"
#endif /*  ifndef _M_COMMON_H  */

#ifdef  __cplusplus
extern "C" {
#endif

#ifdef __MWERKS__
#pragma pack(push,1)
#endif

#ifndef _CALRAM
/****************************************************************************/
/*                              MODULE :SRAM                                */
/****************************************************************************/
struct SRAM_tag {
    union {
        VUINT32 R;
        struct {
            VUINT32 LCK:1;
            VUINT32 DIS:1;
            VUINT32 CY2:1;
              VUINT32:17;
            VUINT32 R0:1;
            VUINT32 D0:1;
            VUINT32 S0:1;
            VUINT32 R1:1;
            VUINT32 D1:1;
            VUINT32 S1:1;
            VUINT32 R2:1;
            VUINT32 D2:1;
            VUINT32 S2:1;
            VUINT32 R3:1;
            VUINT32 D3:1;
            VUINT32 S3:1;
        } B;
    } SRAMMCR;

    union {
        VUINT32 R;
        VUINT32 B;
    } SRAMTST;
};

#else

/****************************************************************************/
/*                              MODULE :CALRAM                                */
/****************************************************************************/
    struct CALRAM_tag {
        union {
            VUINT32 R;
            struct {
                VUINT32 LCK:1;
                VUINT32 DIS:1;
                VUINT32 CY2:1;
                  VUINT32:17;
                VUINT32 R0:1;
                VUINT32 D0:1;
                VUINT32 S0:1;
                VUINT32 R1:1;
                VUINT32 D1:1;
                VUINT32 S1:1;
                VUINT32 R2:1;
                VUINT32 D2:1;
                VUINT32 S2:1;
                VUINT32 R3:1;
                VUINT32 D3:1;
                VUINT32 S3:1;
            } B;
        } CRAMMCR;

        union {
            VUINT32 R;
            struct {
                VUINT32 RB:1;
                VUINT32 SOF:1;
                VUINT32 CLR:1;
                VUINT32 FALG:1;
                VUINT32 BDONE:1;
                VUINT32 PASS:1;
                VUINT32 UP:1;
                VUINT32 INV:1;
                VUINT32 BGND:3;
                VUINT32 RDCL:1;
                  VUINT32:16;
                VUINT32 ACTE:1;
                VUINT32 OCTI:1;
                VUINT32 OCTS:1;
                VUINT32 SDTE:1;
            } B;
        } CRAMTST;

        union {
            VUINT32 R;
            struct {
                VUINT32 RGN_SIZE:4;
                  VUINT32:7;
                VUINT32 RBA:19;
                  VUINT32:2;
            } B;
        } CRAM_RBA0;

        union {
            VUINT32 R;
            struct {
                VUINT32 RGN_SIZE:4;
                  VUINT32:7;
                VUINT32 RBA:19;
                  VUINT32:2;
            } B;
        } CRAM_RBA1;

        union {
            VUINT32 R;
            struct {
                VUINT32 RGN_SIZE:4;
                  VUINT32:7;
                VUINT32 RBA:19;
                  VUINT32:2;
            } B;
        } CRAM_RBA2;

        union {
            VUINT32 R;
            struct {
                VUINT32 RGN_SIZE:4;
                  VUINT32:7;
                VUINT32 RBA:19;
                  VUINT32:2;
            } B;
        } CRAM_RBA3;

        union {
            VUINT32 R;
            struct {
                VUINT32 RGN_SIZE:4;
                  VUINT32:7;
                VUINT32 RBA:19;
                  VUINT32:2;
            } B;
        } CRAM_RBA4;

        union {
            VUINT32 R;
            struct {
                VUINT32 RGN_SIZE:4;
                  VUINT32:7;
                VUINT32 RBA:19;
                  VUINT32:2;
            } B;
        } CRAM_RBA5;

        union {
            VUINT32 R;
            struct {
                VUINT32 RGN_SIZE:4;
                  VUINT32:7;
                VUINT32 RBA:19;
                  VUINT32:2;
            } B;
        } CRAM_RBA6;

        union {
            VUINT32 R;
            struct {
                VUINT32 RGN_SIZE:4;
                  VUINT32:7;
                VUINT32 RBA:19;
                  VUINT32:2;
            } B;
        } CRAM_RBA7;

        union {
            VUINT32 R;
            struct {
                VUINT32 OVL:1;
                VUINT32 DERR:1;
                VUINT32 CLPS:1;
                  VUINT32:29;
            } B;
        } CRAMOVLCR;

        union {
            VUINT32 R;
            VUINT32 B;
        } CRAMOTR;

    };

#endif

#ifdef __MWERKS__
#pragma pack(pop)
#endif


#ifdef  __cplusplus
}
#endif

#endif /* ifndef _M_SRAM_H  */
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

