/**************************************************************************/
/* FILE NAME: m_qadc64.h                      COPYRIGHT (c) MOTOROLA 2002 */
/* VERSION:  1.3                                  All Rights Reserved     */
/*                                                                        */
//* DESCRIPTION:                                                          */
/* This file defines all of the registers and bit fields on the QADC      */
/* module and declares an instance of the QADC structure.                 */
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
/* 1.1   J. Loeliger  22/Jan/99    Changed result and command buffers to  */
/*                                   arrays.                              */
/* 1.2   J. Loeliger  22/Jun/99    Added ifdef to support C++             */
/* 1.3   J. Kobler    11/Jun/01    Added support for CodeWarrior Embedded */
/*                                   PowerPc 5.0.                         */
/**************************************************************************/

#ifndef _M_QADC64_H
#define _M_QADC64_H

#ifndef _M_COMMON_H
#include "m_common.h"
#endif 

#ifdef  __cplusplus
extern "C" {
#endif


#ifdef __MWERKS__
#pragma pack(push,1)
#endif

/****************************************************************************/
/*                              MODULE :QADC                                */
/****************************************************************************/
struct QADC64_tag {

#ifndef _QADC64E
    union {
        VUINT16 R;
        struct {
            VUINT16 STOP:1;
            VUINT16 FRZ:1;
              VUINT16:6;
            VUINT16 SUPV:1;
              VUINT16:7;
        } B;
    } QADC64MCR;
#else
    union {
        VUINT16 R;
        struct {
            VUINT16 STOP:1;
            VUINT16 FRZ:1;
              VUINT16:6;
            VUINT16 SUPV:1;
            VUINT16 MSTR:1;
            VUINT16 EXTCLK:1;
              VUINT16:1;
            VUINT16 IARB:4;
        } B;
    } QADC64MCR;
#endif

    union {
        VUINT16 R;
        VUINT16 B;
    } QADC64TEST;

    union {
        VUINT16 R;
        struct {
            VUINT16 IRL1:5;
            VUINT16 IRL2:5;
              VUINT16:6;
        } B;
    } QADC64INT;

    union {
        VUINT8 R;
        struct {
            VUINT8 PQA7:1;
            VUINT8 PQA6:1;
            VUINT8 PQA5:1;
            VUINT8 PQA4:1;
            VUINT8 PQA3:1;
            VUINT8 PQA2:1;
            VUINT8 PQA1:1;
            VUINT8 PQA0:1;
        } B;
    } PORTQA;

    union {
        VUINT8 R;
        struct {
            VUINT8 PQB7:1;
            VUINT8 PQB6:1;
            VUINT8 PQB5:1;
            VUINT8 PQB4:1;
            VUINT8 PQB3:1;
            VUINT8 PQB2:1;
            VUINT8 PQB1:1;
            VUINT8 PQB0:1;
        } B;
    } PORTQB;

#ifndef _QADC64E
    union {
        VUINT16 R;
        struct {
            VUINT16 DDQA7:1;
            VUINT16 DDQA6:1;
            VUINT16 DDQA5:1;
            VUINT16 DDQA4:1;
            VUINT16 DDQA3:1;
            VUINT16 DDQA2:1;
            VUINT16 DDQA1:1;
            VUINT16 DDQA0:1;
              VUINT16:8;
        } B;
    } DDRQA;

    union {
        VUINT16 R;
        struct {
            VUINT16 MUX:1;
              VUINT16:2;
            VUINT16 TRG:1;
              VUINT16:3;
            VUINT16 PSH:5;
            VUINT16 PSA:1;
            VUINT16 PSL:3;
        } B;
    } QACR0;

#else
        union {
            VUINT16 R;
            struct {
                VUINT16 DDQA7:1;
                VUINT16 DDQA6:1;
                VUINT16 DDQA5:1;
                VUINT16 DDQA4:1;
                VUINT16 DDQA3:1;
                VUINT16 DDQA2:1;
                VUINT16 DDQA1:1;
                VUINT16 DDQA0:1;
                VUINT16 DDQB7:1;
                VUINT16 DDQB6:1;
                VUINT16 DDQB5:1;
                VUINT16 DDQB4:1;
                VUINT16 DDQB3:1;
                VUINT16 DDQB2:1;
                VUINT16 DDQB1:1;
                VUINT16 DDQB0:1;
            } B;
        } DDRQA;

   union {
        VUINT16 R;
        struct {
            VUINT16 MUX:1;
              VUINT16:2;
            VUINT16 TRG:1;
               VUINT16:5;
            VUINT16 PRESCALER:7;
       } B;
    } QACR0;
#endif

    union {
        VUINT16 R;
        struct {
            VUINT16 CIE1:1;
            VUINT16 PIE1:1;
            VUINT16 SSE1:1;
            VUINT16 MQ1:5;
              VUINT16:8;
        } B;
    } QACR1;

    union {
        VUINT16 R;
        struct {
            VUINT16 CIE2:1;
            VUINT16 PIE2:1;
            VUINT16 SSE2:1;
            VUINT16 MQ2:5;
            VUINT16 RESUME:1;
            VUINT16 BQ2:7;
        } B;
    } QACR2;

    union {
        VUINT16 R;
        struct {
            VUINT16 CF1:1;
            VUINT16 PF1:1;
            VUINT16 CF2:1;
            VUINT16 PF2:1;
            VUINT16 TOR1:1;
            VUINT16 TOR2:1;
            VUINT16 QS:4;
            VUINT16 CWP:6;
        } B;
    } QASR0;

    union {
        VUINT16 R;
        struct {
            VUINT16:2;
            VUINT16 CWPQ1:6;
              VUINT16:2;
            VUINT16 CWPQ2:6;
        } B;
    } QASR1;

    VUINT16 res19[246];

    /*Command Convertion Word Table */
#ifndef _QADC64E
    union {
        VUINT16 R;
        struct {
            VUINT16:6;
            VUINT16 P:1;
            VUINT16 BYP:1;
            VUINT16 IST:2;
            VUINT16 CHAN:6;
        } B;
    } CCW[64];
#else
#ifdef _QADC64E_LEGACY
    union {
        VUINT16 R;
        struct {
            VUINT16:6;
            VUINT16 P:1;
            VUINT16 BYP:1;
            VUINT16 IST:2;
            VUINT16 CHAN:6;
        } B;
    } CCW[64];
#else
       union {
            VUINT16 R;
            struct {
                VUINT16:6;
                VUINT16 P:1;
                VUINT16 REF:1;
                VUINT16 IST:1;
                VUINT16 CHAN:7;
            } B;
        } CCW[64];
#endif
#endif

    /*Result Word Table, Unsigned Right Justified */
    union {
        VUINT16 R;
        struct {
            VUINT16:6;
            VUINT16 RESULT:10;
        } B;
    } RJURR[64];

    /*Result Word Table, Signed Left Justified */
    union {
        VUINT16 R;
        struct {
            VUINT16 RESULT:10;
              VUINT16:6;
        } B;
    } LJSRR[64];

    /*Result Word Table, Unsigned Left Justified */
    union {
        VUINT16 R;
        struct {
            VUINT16 RESULT:10;
              VUINT16:6;
        } B;
    } LJURR[64];

};

#ifdef __MWERKS__
#pragma pack(pop)
#endif

#ifdef  __cplusplus
}
#endif

#endif /* ifndef _M_QADC64_H  */

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

