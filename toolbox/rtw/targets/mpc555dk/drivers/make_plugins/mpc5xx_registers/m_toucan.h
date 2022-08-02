/**************************************************************************/
/* FILE NAME: m_toucan.h                      COPYRIGHT (c) MOTOROLA 2002 */
/* VERSION:  0.2                                  All Rights Reserved     */
/*                                                                        */
//* DESCRIPTION:                                                          */
/* This file defines all of the registers and bit fields on the TOUCAN    */
/* modules and declares an instance of the TOUCAN structure.              */
/*========================================================================*/
/* AUTHOR: Jeff Loeliger                                                  */
/* COMPILER: Diab Data        VERSION: 4.2b                               */
/*                                                                        */
/* HISTORY                                                                */
/* REV      AUTHOR      DATE       DESCRIPTION OF CHANGE                  */
/* ---   -----------  ---------    ---------------------                  */
/* 0.1   J. Loeliger  13/Sep/99    Initial version of file for MPC565.    */
/* 0.2   J. Loeliger  16/Apr/02    Created generic version for all MPC5xx.*/
/*                                   Merged DLCMD2 module.                */
/**************************************************************************/
#ifndef _M_TOUCAN_H
#define _M_TOUCAN_H

#ifndef _M_COMMON_H
#include "m_common.h"
#endif /*  ifndef _M_COMMON_H  */

#ifdef  __cplusplus
extern "C" {
#endif

/****************************************************************************/
/*                              MODULE :TOUCAN                              */
/****************************************************************************/
    struct TOUCAN_tag {
        union {
            VUINT16 R;
            struct {
                VUINT16 STOP:1;
                VUINT16 FRZ:1;
                  VUINT16:1;
                VUINT16 HALT:1;
                VUINT16 NOTRDY:1;
                VUINT16 WAKEMSK:1;
                VUINT16 SOFTRST:1;
                VUINT16 FRZACK:1;
                VUINT16 SUPV:1;
                VUINT16 SELFWAKE:1;
                VUINT16 APS:1;
                VUINT16 STOPACK:1;
                  VUINT16:4;
            } B;
        } TCNMCR;

        union {
            VUINT16 R;
            VUINT16 B;
        } CANTCR;

        union {
            VUINT16 R;
            struct {
                VUINT16:5;
                VUINT16 IRL:3;
                VUINT16 ILBS:2;
                  VUINT16:6;
            } B;
        } CANICR;

        union {
            VUINT8 R;
            struct {
                VUINT8 BOFFMSK:1;
                VUINT8 ERRMSK:1;
                  VUINT8:2;
                VUINT8 RXMODE:2;
                VUINT8 TXMODE:2;
            } B;
        } CANCTRL0;

        union {
            VUINT8 R;
            struct {
                VUINT8 SAMP:1;
                  VUINT8:1;
                VUINT8 TSYNC:1;
                VUINT8 LBUF:1;
                  VUINT8:1;
                VUINT8 PROPSE:3;
            } B;
        } CANCTRL1;

        union {
            VUINT8 R;
            VUINT8 B;
        } PRESDIV;

        union {
            VUINT8 R;
            struct {
                VUINT8 RJW:2;
                VUINT8 PSEG:3;
                VUINT8 PSEG2:3;
            } B;
        } CANCTRL2;

        union {
            VUINT16 R;
            VUINT16 B;
        } TIMER;

        VUINT32 res43;

        union {
            VUINT16 R;
            struct {
                VUINT16 MID28:1;
                VUINT16 MID27:1;
                VUINT16 MID26:1;
                VUINT16 MID25:1;
                VUINT16 MID24:1;
                VUINT16 MID23:1;
                VUINT16 MID22:1;
                VUINT16 MID21:1;
                VUINT16 MID20:1;
                VUINT16 MID19:1;
                VUINT16 MID18:1;
                  VUINT16:2;
                VUINT16 MID17:1;
                VUINT16 MID16:1;
                VUINT16 MID15:1;
            } B;
        } RXGMSKHI;

        union {
            VUINT16 R;
            struct {
                VUINT16 MID14:1;
                VUINT16 MID13:1;
                VUINT16 MID12:1;
                VUINT16 MID11:1;
                VUINT16 MID10:1;
                VUINT16 MID9:1;
                VUINT16 MID8:1;
                VUINT16 MID7:1;
                VUINT16 MID6:1;
                VUINT16 MID5:1;
                VUINT16 MID4:1;
                VUINT16 MID3:1;
                VUINT16 MID2:1;
                VUINT16 MID1:1;
                VUINT16 MID0:1;
                  VUINT16:1;
            } B;
        } RXGMSKLO;

        union {
            VUINT16 R;
            struct {
                VUINT16 MID28:1;
                VUINT16 MID27:1;
                VUINT16 MID26:1;
                VUINT16 MID25:1;
                VUINT16 MID24:1;
                VUINT16 MID23:1;
                VUINT16 MID22:1;
                VUINT16 MID21:1;
                VUINT16 MID20:1;
                VUINT16 MID19:1;
                VUINT16 MID18:1;
                  VUINT16:2;
                VUINT16 MID17:1;
                VUINT16 MID16:1;
                VUINT16 MID15:1;
            } B;
        } RX14MSKHI;

        union {
            VUINT16 R;
            struct {
                VUINT16 MID14:1;
                VUINT16 MID13:1;
                VUINT16 MID12:1;
                VUINT16 MID11:1;
                VUINT16 MID10:1;
                VUINT16 MID9:1;
                VUINT16 MID8:1;
                VUINT16 MID7:1;
                VUINT16 MID6:1;
                VUINT16 MID5:1;
                VUINT16 MID4:1;
                VUINT16 MID3:1;
                VUINT16 MID2:1;
                VUINT16 MID1:1;
                VUINT16 MID0:1;
                  VUINT16:1;
            } B;
        } RX14MSKLO;

        union {
            VUINT16 R;
            struct {
                VUINT16 MID28:1;
                VUINT16 MID27:1;
                VUINT16 MID26:1;
                VUINT16 MID25:1;
                VUINT16 MID24:1;
                VUINT16 MID23:1;
                VUINT16 MID22:1;
                VUINT16 MID21:1;
                VUINT16 MID20:1;
                VUINT16 MID19:1;
                VUINT16 MID18:1;
                  VUINT16:2;
                VUINT16 MID17:1;
                VUINT16 MID16:1;
                VUINT16 MID15:1;
            } B;
        } RX15MSKHI;

        union {
            VUINT16 R;
            struct {
                VUINT16 MID14:1;
                VUINT16 MID13:1;
                VUINT16 MID12:1;
                VUINT16 MID11:1;
                VUINT16 MID10:1;
                VUINT16 MID9:1;
                VUINT16 MID8:1;
                VUINT16 MID7:1;
                VUINT16 MID6:1;
                VUINT16 MID5:1;
                VUINT16 MID4:1;
                VUINT16 MID3:1;
                VUINT16 MID2:1;
                VUINT16 MID1:1;
                VUINT16 MID0:1;
                  VUINT16:1;
            } B;
        } RX15MSKLO;

        VUINT32 res44;

        union {
            VUINT16 R;
            struct {
                VUINT16 BITER:2;
                VUINT16 ACKERR:1;
                VUINT16 CRCERR:1;
                VUINT16 FORMERR:1;
                VUINT16 STUFFERR:1;
                VUINT16 TXWARN:1;
                VUINT16 RXWARN:1;
                VUINT16 IDLE:1;
                VUINT16 TX_RX:1;
                VUINT16 FCS:2;
                  VUINT16:1;
                VUINT16 BOFFINT:1;
                VUINT16 ERRINT:1;
                VUINT16 WAKEINT:1;
            } B;
        } ESTAT;

        union {
            VUINT16 R;
            struct {
                VUINT16 IMASKH:8;
                VUINT16 IMASKL:8;
            } B;
        } IMASK;

        union {
            VUINT16 R;
            struct {
                VUINT16 IFLAGH:8;
                VUINT16 IFLAGL:8;
            } B;
        } IFLAG;
        union {
            VUINT8 R;
            VUINT8 B;
        } RXECTR;

        union {
            VUINT8 R;
            VUINT8 B;
        } TXECTR;

        VUINT32 res45[22];

        struct {
            union {
                VUINT16 R;
                struct {
                    VUINT16 TIMESTAMP:8;
                    VUINT16 CODE:4;
                    VUINT16 LENGTH:4;
                } B;
            } SCR;
            union {
                VUINT16 R;
                VUINT16 B;
            } ID_HIGH;
            union {
                VUINT16 R;
                VUINT16 B;
            } ID_LOW;
            union {
                VUINT8 R;
                VUINT8 B;
            } DATA[8];
            VUINT16 res45a;
        } MBUFF[16];

    };


/****************************************************************************/
/*                              MODULE :DLCMD2                              */
/****************************************************************************/
    struct DLCMD2_tag {
        union {
            VUINT16 R;
            struct {
                VUINT16 STOP:1;
                VUINT16 FRZ:2;
                VUINT16 DSAE:1;
                VUINT16 X4MD:1;
                VUINT16 SOFT_FRZ:1;
                VUINT16 NOT_RDY:1;
                VUINT16 FREEZ_ACK:1;
                VUINT16 SUPV:1;
                  VUINT16:2;
                VUINT16 STOP_ACK:1;
                VUINT16 IARB:4;
            } B;
        } DLCMCR;

        union {
            VUINT16 R;
            struct {
                VUINT16 TTPOP:1;
                VUINT16 TCA:1;
                VUINT16 TCD:1;
                VUINT16 RDFST:1;
                VUINT16 RSYNC:1;
                VUINT16 DLOOP:1;
                VUINT16 TRPSH:1;
                VUINT16 DIVTE:1;
                VUINT16 COUNTE:1;
                VUINT16 FIFOTE:1;
                VUINT16 SFSCRBIT:1;
                VUINT16 SFSCC2:1;
                  VUINT16:1;
                VUINT16 SCPT2:1;
                VUINT16 SCPT1:1;
                VUINT16 SCPT0:1;
            } B;
        } DLCTCR;

        union {
            VUINT16 R;
            struct {
                VUINT16:11;
                VUINT16 IPR_4:1;
                VUINT16 IPR_3:1;
                VUINT16 IPR_2:1;
                VUINT16 IPR_1:1;
                VUINT16 IPR_0:1;
            } B;
        } DLCIPR;

        union {
            VUINT8 R;
            struct {
                VUINT8 INTMODE:1;
                VUINT8 INTACL2E:1;
                  VUINT8:1;
                VUINT8 ILBS:2;
                VUINT8 ILR:3;
            } B;
        } DLCILR;

        union {
            VUINT8 R;
            VUINT8 B;
        } DLCIVR;

        union {
            VUINT16 R;
            struct {
                VUINT16:1;
                VUINT16 NBFS:1;
                VUINT16 RXPOL:1;
                  VUINT16:3;
                VUINT16 LCK:1;
                VUINT16 SEL:1;
                  VUINT16:2;
                VUINT16 PS:6;
            } B;
        } DLCSCTL;

        union {
            VUINT16 R;
            struct {
                VUINT16:5;
                VUINT16 S10:1;
                VUINT16 S9:1;
                VUINT16 S8:1;
                VUINT16 S7:1;
                VUINT16 S6:1;
                VUINT16 S5:1;
                VUINT16 S4:1;
                VUINT16 S3:1;
                VUINT16 S2:1;
                VUINT16 S1:1;
                VUINT16 S0:1;
            } B;
        } DLCSDATA;

        union {
            VUINT8 R;
            VUINT8 B;
        } DLCCMD;

        union {
            VUINT8 R;
            VUINT8 B;
        } DLCTDATA;

        union {
            VUINT8 R;
            VUINT8 B;
        } DLCSTAT;

        union {
            VUINT8 R;
            VUINT8 B;
        } DLCRDATA;
    };

#ifdef  __cplusplus
}
#endif

#endif
/* ifndef _M_TOUCAN_H  */
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

