/**************************************************************************/
/* FILE NAME: m_tpu3.h                        COPYRIGHT (c) MOTOROLA 2002 */
/* VERSION:  0.2                                  All Rights Reserved     */
/*                                                                        */
//* DESCRIPTION:                                                          */
/* This file defines all of the registers and bit fields on the TPU3      */
/* modules and declares an instance of the TPU3 structure.                */
/*========================================================================*/
/* AUTHOR: Jeff Loeliger                                                  */
/* COMPILER: Diab Data        VERSION: 4.2b                               */
/*                                                                        */
/* HISTORY                                                                */
/* REV      AUTHOR      DATE       DESCRIPTION OF CHANGE                  */
/* ---   -----------  ---------    ---------------------                  */
/* 0.1   J. Loeliger  13/Sep/99    Initial version of file for MPC565.    */
/* 0.2   J. Loeliger  16/Apr/02    Created generic version for all MPC5xx.*/
/*                                   Merged DPTRAM module to TPU3.        */
/**************************************************************************/
#ifndef _M_TPU3_H
#define _M_TPU3_H

#ifndef _M_COMMON_H
#include "m_common.h"
#endif /*  ifndef _M_COMMON_H  */

#ifdef  __cplusplus
extern "C" {
#endif

/****************************************************************************/
/*                              MODULE :TPU3                                */
/****************************************************************************/
    struct TPU3_tag {
        union {
            VUINT16 R;
            struct {
                VUINT16 STOP:1;
                VUINT16 TCR1P:2;
                VUINT16 TCR2P:2;
                VUINT16 EMU:1;
                VUINT16 T2CG:1;
                VUINT16 STF:1;
                VUINT16 SUPV:1;
                VUINT16 PSCK:1;
                VUINT16 TPU3:1;
                VUINT16 T2CSL:1;
                  VUINT16:4;
            } B;
        } TPUMCR;

        union {
            VUINT16 R;
            VUINT16 B;
        } TCR;

        union {
            VUINT16 R;
            struct {
                VUINT16 HOT4:1;
                  VUINT16:4;
                VUINT16 BLC:1;
                VUINT16 CLKS:1;
                VUINT16 FRZ:2;
                VUINT16 CCL:1;
                VUINT16 BP:1;
                VUINT16 BC:1;
                VUINT16 BH:1;
                VUINT16 BL:1;
                VUINT16 BM:1;
                VUINT16 BT:1;
            } B;
        } DSCR;

        union {
            VUINT16 R;
            struct {
                VUINT16:8;
                VUINT16 BKPT:1;
                VUINT16 PCBK:1;
                VUINT16 CHBK:1;
                VUINT16 SRBK:1;
                VUINT16 TPUF:1;
                  VUINT16:3;
            } B;
        } DSSR;

        union {
            VUINT16 R;
            struct {
                VUINT16:5;
                VUINT16 CIRL:3;
                VUINT16 ILBS:2;
                  VUINT16:6;
            } B;
        } TICR;

        union {
            VUINT16 R;
            struct {
                VUINT16 CH15:1;
                VUINT16 CH14:1;
                VUINT16 CH13:1;
                VUINT16 CH12:1;
                VUINT16 CH11:1;
                VUINT16 CH10:1;
                VUINT16 CH9:1;
                VUINT16 CH8:1;
                VUINT16 CH7:1;
                VUINT16 CH6:1;
                VUINT16 CH5:1;
                VUINT16 CH4:1;
                VUINT16 CH3:1;
                VUINT16 CH2:1;
                VUINT16 CH1:1;
                VUINT16 CH0:1;
            } B;
        } CIER;

        union {
            VUINT16 R;
            struct {
                VUINT16 CH15:4;
                VUINT16 CH14:4;
                VUINT16 CH13:4;
                VUINT16 CH12:4;
            } B;
        } CFSR0;

        union {
            VUINT16 R;
            struct {
                VUINT16 CH11:4;
                VUINT16 CH10:4;
                VUINT16 CH9:4;
                VUINT16 CH8:4;
            } B;
        } CFSR1;

        union {
            VUINT16 R;
            struct {
                VUINT16 CH7:4;
                VUINT16 CH6:4;
                VUINT16 CH5:4;
                VUINT16 CH4:4;
            } B;
        } CFSR2;

        union {
            VUINT16 R;
            struct {
                VUINT16 CH3:4;
                VUINT16 CH2:4;
                VUINT16 CH1:4;
                VUINT16 CH0:4;
            } B;
        } CFSR3;

        union {
            VUINT16 R;
            struct {
                VUINT16 CH15:2;
                VUINT16 CH14:2;
                VUINT16 CH13:2;
                VUINT16 CH12:2;
                VUINT16 CH11:2;
                VUINT16 CH10:2;
                VUINT16 CH9:2;
                VUINT16 CH8:2;
            } B;
        } HSQR0;

        union {
            VUINT16 R;
            struct {
                VUINT16 CH7:2;
                VUINT16 CH6:2;
                VUINT16 CH5:2;
                VUINT16 CH4:2;
                VUINT16 CH3:2;
                VUINT16 CH2:2;
                VUINT16 CH1:2;
                VUINT16 CH0:2;
            } B;
        } HSQR1;

        union {
            VUINT16 R;
            struct {
                VUINT16 CH15:2;
                VUINT16 CH14:2;
                VUINT16 CH13:2;
                VUINT16 CH12:2;
                VUINT16 CH11:2;
                VUINT16 CH10:2;
                VUINT16 CH9:2;
                VUINT16 CH8:2;
            } B;
        } HSRR0;

        union {
            VUINT16 R;
            struct {
                VUINT16 CH7:2;
                VUINT16 CH6:2;
                VUINT16 CH5:2;
                VUINT16 CH4:2;
                VUINT16 CH3:2;
                VUINT16 CH2:2;
                VUINT16 CH1:2;
                VUINT16 CH0:2;
            } B;
        } HSRR1;

        union {
            VUINT16 R;
            struct {
                VUINT16 CH15:2;
                VUINT16 CH14:2;
                VUINT16 CH13:2;
                VUINT16 CH12:2;
                VUINT16 CH11:2;
                VUINT16 CH10:2;
                VUINT16 CH9:2;
                VUINT16 CH8:2;
            } B;
        } CPR0;

        union {
            VUINT16 R;
            struct {
                VUINT16 CH7:2;
                VUINT16 CH6:2;
                VUINT16 CH5:2;
                VUINT16 CH4:2;
                VUINT16 CH3:2;
                VUINT16 CH2:2;
                VUINT16 CH1:2;
                VUINT16 CH0:2;
            } B;
        } CPR1;

        union {
            VUINT16 R;
            struct {
                VUINT16 CH15:1;
                VUINT16 CH14:1;
                VUINT16 CH13:1;
                VUINT16 CH12:1;
                VUINT16 CH11:1;
                VUINT16 CH10:1;
                VUINT16 CH9:1;
                VUINT16 CH8:1;
                VUINT16 CH7:1;
                VUINT16 CH6:1;
                VUINT16 CH5:1;
                VUINT16 CH4:1;
                VUINT16 CH3:1;
                VUINT16 CH2:1;
                VUINT16 CH1:1;
                VUINT16 CH0:1;
            } B;
        } CISR;

        union {
            VUINT16 R;
            VUINT16 B;
        } LR;

        union {
            VUINT16 R;
            VUINT16 B;
        } SGLR;

        union {
            VUINT16 R;
            VUINT16 B;
        } DCNR;

        union {
            VUINT16 R;
            struct {
                VUINT16:7;
                VUINT16 DIV2:1;
                VUINT16 SOFTRST:1;
                VUINT16 ETBANK:2;
                VUINT16 FPSCK:3;
                VUINT16 T2CF:1;
                VUINT16 DTPU:1;
            } B;
        } TPUMCR2;

        union {
            VUINT16 R;
            struct {
                VUINT16:7;
                VUINT16 PWOD:1;
                VUINT16 TCR2PCK2:1;
                VUINT16 EPSCKE:1;
                  VUINT16:1;
                VUINT16 EPSCK:5;
            } B;
        } TPUMCR3;

        union {
            VUINT16 R;
            VUINT16 B;
        } ISDR;

        union {
            VUINT16 R;
            VUINT16 B;
        } ISCR;

/*    VUINT16 res17; */
        VUINT32 res18[52];

/*Parameter RAM */
        union {
            VUINT16 R[16][8];
            VUINT16 B[16][8];
            VUINT32 L[16][4];
        } PARM;

/* Old parameter definition, if you need it for compatibility uncomment
   the union below and comment out the union above. */
/*    union {  
   VUINT16 R;
   } PARM[16][8];    */

    };


/****************************************************************************/
/*                              MODULE :TPU RAM                             */
/****************************************************************************/
    struct DPTRAM_tag {
        union {
            VUINT16 R;
            struct {
                VUINT16 STOP:1;
                  VUINT16:4;
                VUINT16 MISF:1;
                VUINT16 MISEN:1;
                VUINT16 RASP:1;
                  VUINT16:8;
            } B;
        } DPTMCR;

        union {
            VUINT16 R;
            VUINT16 B;
        } RAMTST;

        union {
            VUINT16 R;
            struct {
                VUINT16 A8:1;
                VUINT16 A9:1;
                VUINT16 A10:1;
                VUINT16 A11:1;
                VUINT16 A12:1;
                VUINT16 A13:1;
                VUINT16 A14:1;
                VUINT16 A15:1;
                VUINT16 A16:1;
                VUINT16 A17:1;
                VUINT16 A18:1;
                  VUINT16:4;
                VUINT16 RAMDS:1;
            } B;
        } RAMBAR;

        union {
            VUINT16 R;
            struct {
                VUINT16 D31:1;
                VUINT16 D30:1;
                VUINT16 D29:1;
                VUINT16 D28:1;
                VUINT16 D27:1;
                VUINT16 D26:1;
                VUINT16 D25:1;
                VUINT16 D24:1;
                VUINT16 D23:1;
                VUINT16 D22:1;
                VUINT16 D21:1;
                VUINT16 D20:1;
                VUINT16 D19:1;
                VUINT16 D18:1;
                VUINT16 D17:1;
                VUINT16 D16:1;
            } B;
        } MISRH;

        union {
            VUINT16 R;
            struct {
                VUINT16 D15:1;
                VUINT16 D14:1;
                VUINT16 D13:1;
                VUINT16 D12:1;
                VUINT16 D11:1;
                VUINT16 D10:1;
                VUINT16 D9:1;
                VUINT16 D8:1;
                VUINT16 D7:1;
                VUINT16 D6:1;
                VUINT16 D5:1;
                VUINT16 D4:1;
                VUINT16 D3:1;
                VUINT16 D2:1;
                VUINT16 D1:1;
                VUINT16 D0:1;
            } B;
        } MISRL;

        union {
            VUINT16 R;
            struct {
                VUINT16 A12:1;
                VUINT16 A11:1;
                VUINT16 A10:1;
                VUINT16 A9:1;
                VUINT16 A8:1;
                VUINT16 A7:1;
                VUINT16 A6:1;
                VUINT16 A5:1;
                VUINT16 A4:1;
                VUINT16 A3:1;
                VUINT16 A2:1;
                VUINT16 A1:1;
                VUINT16 A0:1;
                  VUINT16:3;
            } B;
        } MISCNT;
    };

#ifdef  __cplusplus
}
#endif

#endif
/* ifndef _M_TPU3_H  */
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

