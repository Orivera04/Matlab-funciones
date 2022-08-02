/**************************************************************************/
/* FILE NAME: m_qsmcm.h                       COPYRIGHT (c) MOTOROLA 2002 */
/* VERSION:  1.4                                  All Rights Reserved     */
/*                                                                        */
//* DESCRIPTION:                                                          */
/* This file defines all of the registers and bit fields on the QSMCM     */
/* module and declares an instance of the QSMCM structure.                */
/*========================================================================*/
/* AUTHOR: Jeff Loeliger                                                  */
/* COMPILER: Diab Data        VERSION: 4.3f                               */
/*                                                                        */
/* HISTORY                                                                */
/* REV      AUTHOR      DATE       DESCRIPTION OF CHANGE                  */
/* ---   -----------  ---------    ---------------------                  */
/* 0.1   J. Loeliger  06/Apr/98    Initial version of file.               */
/* 0.2                20/Dec/98    Broke header file into modules.        */
/* 1.0   J. Loeliger  13/Jan/99    Added three ways to create an instance */
/*                                   of the module and added PACK.        */
/* 1.1   J. Loeliger  22/Jan/99    Changed buffers to arrays.             */
/* 1.2   J. Loeliger  22/Jun/99    Added ifdef to support C++             */
/*       K. Muto                   Renamed bits fields as MPC555UM(1/3/99)*/
/*                                 Changes are on: PORTQS, PQSPAR, SPCR0  */
/* 1.3   J. Kobler    11/Jun/01    Added support for CodeWarrior Embedded */
/*                                   PowerPc 5.0.                         */
/* 1.4   J. Loeliger  16/Apr/02    Created generic version for all MPC5xx.*/
/**************************************************************************/

#ifndef _M_QSMCM_H
#define _M_QSMCM_H

#ifndef _M_COMMON_H
#include "m_common.h"
#endif /*  ifndef _M_COMMON_H  */

#ifdef  __cplusplus
extern "C" {
#endif

#ifdef __MWERKS__
#pragma pack(push,1)
#endif

/****************************************************************************/
/*                              MODULE :QSMCM                               */
/****************************************************************************/
struct QSMCM_tag {
    union {
        VUINT16 R;
        struct {
            VUINT16 STOP:1;
            VUINT16 FRZ1:1;
              VUINT16:6;
            VUINT16 SUPV:1;
              VUINT16:3;
            VUINT16 IARB:4;
        } B;
    } QSMCR;

    union {
        VUINT16 R;
        VUINT16 B;
    } QTEST;

    union {
        VUINT16 R;
        struct {
            VUINT16:3;
            VUINT16 ILDSCI:5;
              VUINT16:8;
        } B;
    } QDSCI_IL;

    union {
        VUINT16 R;
        struct {
            VUINT16:11;
            VUINT16 ILQSPI:5;
        } B;
    } QSPI_IL;

    union {
        VUINT16 R;
        struct {
            VUINT16 OTHR:1;
            VUINT16 LNKBD:1;
              VUINT16:1;
            VUINT16 SC1BR:13;
        } B;
    } SCC1R0;

    union {
        VUINT16 R;
        struct {
            VUINT16:1;
            VUINT16 LOOPS:1;
            VUINT16 WOMS:1;
            VUINT16 ILT:1;
            VUINT16 PT:1;
            VUINT16 PE:1;
            VUINT16 M:1;
            VUINT16 WAKE:1;
            VUINT16 TIE:1;
            VUINT16 TCIE:1;
            VUINT16 RIE:1;
            VUINT16 ILIE:1;
            VUINT16 TE:1;
            VUINT16 RE:1;
            VUINT16 RWU:1;
            VUINT16 SBK:1;
        } B;
    } SCC1R1;

    union {
        VUINT16 R;
        struct {
            VUINT16:7;
            VUINT16 TDRE:1;
            VUINT16 TC:1;
            VUINT16 RDRF:1;
            VUINT16 RAF:1;
            VUINT16 IDLE:1;
            VUINT16 OR:1;
            VUINT16 NF:1;
            VUINT16 FE:1;
            VUINT16 PF:1;
        } B;
    } SC1SR;

    union {
        VUINT16 R;
        struct {
            VUINT16:7;
            VUINT16 R8_T8:1;
            VUINT16 R7_T7:1;
            VUINT16 R6_T6:1;
            VUINT16 R5_T5:1;
            VUINT16 R4_T4:1;
            VUINT16 R3_T3:1;
            VUINT16 R2_T2:1;
            VUINT16 R1_T1:1;
            VUINT16 R0_T0:1;
        } B;
    } SC1DR;

    VUINT16 res22;
    VUINT16 res23;

    union {
        VUINT16 R;
        struct {
            VUINT16:4;
            VUINT16 QDRXD2:1;
            VUINT16 QDTXD2:1;
            VUINT16 QDRXD1:1;
            VUINT16 QDTXD1:1;
              VUINT16:1;
            VUINT16 QDPCS3:1;
            VUINT16 QDPCS2:1;
            VUINT16 QDPCS1:1;
            VUINT16 QDPCS0:1;
            VUINT16 QDSCK:1;
            VUINT16 QDMOSI:1;
            VUINT16 QDMISO:1;
        } B;
    } PORTQS;

    union {
        VUINT8 R;
        struct {
            VUINT8:1;
            VUINT8 QPAPCS3:1;
            VUINT8 QPAPCS2:1;
            VUINT8 QPAPCS1:1;
            VUINT8 QPAPCS0:1;
              VUINT8:1;
            VUINT8 QPAMOSI:1;
            VUINT8 QPAMISO:1;
        } B;
    } PQSPAR;

    union {
        VUINT8 R;
        struct {
            VUINT8:1;
            VUINT8 QDDPCS3:1;
            VUINT8 QDDPCS2:1;
            VUINT8 QDDPCS1:1;
            VUINT8 QDDPCS0:1;
            VUINT8 QDDSCK:1;
            VUINT8 QDDMOSI:1;
            VUINT8 QDDMISO:1;
        } B;
    } DDRQS;

    union {
        VUINT16 R;
        struct {
            VUINT16 MSTR:1;
            VUINT16 WOMQ:1;
            VUINT16 BITS:4;
            VUINT16 CPOL:1;
            VUINT16 CPHA:1;
            VUINT16 SPBR:8;
        } B;
    } SPCR0;

    union {
        VUINT16 R;
        struct {
            VUINT16 SPE:1;
            VUINT16 DSCKL:7;
            VUINT16 DTL:8;
        } B;
    } SPCR1;

    union {
        VUINT16 R;
        struct {
            VUINT16 SPIFIE:1;
            VUINT16 WREN:1;
            VUINT16 WRTO:1;
            VUINT16 ENDQP:5;
              VUINT16:3;
            VUINT16 NEWQP:5;
        } B;
    } SPCR2;

    union {
        VUINT8 R;
        struct {
            VUINT8:5;
            VUINT8 LOOPQ:1;
            VUINT8 HMIE:1;
            VUINT8 HALT:1;
        } B;
    } SPCR3;

    union {
        VUINT8 R;
        struct {
            VUINT8 SPIF:1;
            VUINT8 MODF:1;
            VUINT8 HALTA:1;
            VUINT8 CPTQP:5;
        } B;
    } SPSR;

    union {
        VUINT16 R;
        struct {
            VUINT16 OTHR:1;
            VUINT16 LNKBD:1;
              VUINT16:1;
            VUINT16 SC2BR:13;
        } B;
    } SCC2R0;

    union {
        VUINT16 R;
        struct {
            VUINT16:1;
            VUINT16 LOOPS:1;
            VUINT16 WOMS:1;
            VUINT16 ILT:1;
            VUINT16 PT:1;
            VUINT16 PE:1;
            VUINT16 M:1;
            VUINT16 WAKE:1;
            VUINT16 TIE:1;
            VUINT16 TCIE:1;
            VUINT16 RIE:1;
            VUINT16 ILIE:1;
            VUINT16 TE:1;
            VUINT16 RE:1;
            VUINT16 RWU:1;
            VUINT16 SBK:1;
        } B;
    } SCC2R1;

    union {
        VUINT16 R;
        struct {
            VUINT16:7;
            VUINT16 TDRE:1;
            VUINT16 TC:1;
            VUINT16 RDRF:1;
            VUINT16 RAF:1;
            VUINT16 IDLE:1;
            VUINT16 OR:1;
            VUINT16 NF:1;
            VUINT16 FE:1;
            VUINT16 PF:1;
        } B;
    } SC2SR;

    union {
        VUINT16 R;
        struct {
            VUINT16:7;
            VUINT16 R8_T8:1;
            VUINT16 R7_T7:1;
            VUINT16 R6_T6:1;
            VUINT16 R5_T5:1;
            VUINT16 R4_T4:1;
            VUINT16 R3_T3:1;
            VUINT16 R2_T2:1;
            VUINT16 R1_T1:1;
            VUINT16 R0_T0:1;
        } B;
    } SC2DR;

    union {
        VUINT16 R;
        struct {
            VUINT16 QTPNT:4;
            VUINT16 QTHFI:1;
            VUINT16 QBHFI:1;
            VUINT16 QTHEI:1;
            VUINT16 QBHEI:1;
              VUINT16:1;
            VUINT16 QTE:1;
            VUINT16 QRE:1;
            VUINT16 QTWE:1;
            VUINT16 QTSZ:4;
        } B;
    } QSCI1CR;

    union {
        VUINT16 R;
        struct {
            VUINT16:3;
            VUINT16 QOR:1;
            VUINT16 QTHF:1;
            VUINT16 QBHF:1;
            VUINT16 QTHE:1;
            VUINT16 QBHE:1;
            VUINT16 QRPNT:4;
            VUINT16 QPEND:4;
        } B;
    } QSCI1SR;

    union {
        VUINT16 R;
        VUINT16 B;
    } SCTQ[16];

    union {
        VUINT16 R;
        VUINT16 B;
    } SCRQ[16];

    VUINT16 RES25[106];

    union {
        VUINT16 R;
        VUINT16 B;
    } RECRAM[32];

    union {
        VUINT16 R;
        VUINT16 B;
    } TRANRAM[32];

    union {
        VUINT8 R;
        struct {
            VUINT8 CONT:1;
            VUINT8 BITSE:1;
            VUINT8 DT:1;
            VUINT8 DSCK:1;
            VUINT8 PCS3:1;
            VUINT8 PCS2:1;
            VUINT8 PCS1:1;
            VUINT8 PCS0:1;
        } B;
    } COMDRAM[32];
};

#ifdef __MWERKS__
#pragma pack(pop)
#endif

#ifdef  __cplusplus
}
#endif

#endif /* ifndef _M_QSMCM_H  */

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

