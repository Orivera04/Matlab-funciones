/**************************************************************************/
/* FILE NAME: m_mios.h                        COPYRIGHT (c) MOTOROLA 2002 */
/* VERSION:  1.0                                  All Rights Reserved     */
/*                                                                        */
//* DESCRIPTION:                                                          */
/* This file defines all of the registers and bit fields on the MIOS14    */
/* module and declares an instance of the MIOS14 structure.               */
/*========================================================================*/
/* AUTHOR: Jeff Loeliger                                                  */
/* COMPILER: Diab Data        VERSION: 4.3f                               */
/*                                                                        */
/* HISTORY                                                                */
/* REV      AUTHOR      DATE       DESCRIPTION OF CHANGE                  */
/* ---   -----------  ---------    ---------------------                  */
/* 0.1   J. Loeliger  13/Sep/99    Initial version of file for MPC565.    */
/* 0.2   S. Markos    28/Sep/99    Updated MIOS1 with MIOS14 registers    */
/* 0.3   J. Loeliger  21/Jul/00    Created 32 bit MRTCSMFRC register.     */
/* 0.4   J. Loeliger  16/Apr/02    Created generic version for all MPC5xx.*/
/*                                 Added support for CodeWarrior Embedded */
/*                                   PowerPc 5.0.                         */
/* 1.0   J. Loeliger  16/Apr/02    Created generic version for all MPC5xx.*/
/*                                   Merged MIOS1 & MIOS14.               */
/**************************************************************************/
#ifndef _M_MIOS_H
#define _M_MIOS_H

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
/*                              MODULE :MIOS                                */
/****************************************************************************/
    struct MIOS_tag {

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM0PERR;          /*MPWMSM0 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM0PULR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM0CNTR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PIN:1;
                VUINT16 DDR:1;
                VUINT16 FREN:1;
                VUINT16 TRSP:1;
                VUINT16 POL:1;
                VUINT16 EN:1;
                  VUINT16:2;
                VUINT16 CP:8;
            } B;
        } MPWMSM0SCR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM1PERR;          /*MPWMSM1 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM1PULR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM1CNTR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PIN:1;
                VUINT16 DDR:1;
                VUINT16 FREN:1;
                VUINT16 TRSP:1;
                VUINT16 POL:1;
                VUINT16 EN:1;
                  VUINT16:2;
                VUINT16 CP:8;
            } B;
        } MPWMSM1SCR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM2PERR;          /*MPWMSM2 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM2PULR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM2CNTR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PIN:1;
                VUINT16 DDR:1;
                VUINT16 FREN:1;
                VUINT16 TRSP:1;
                VUINT16 POL:1;
                VUINT16 EN:1;
                  VUINT16:2;
                VUINT16 CP:8;
            } B;
        } MPWMSM2SCR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM3PERR;          /*MPWMSM3 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM3PULR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM3CNTR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PIN:1;
                VUINT16 DDR:1;
                VUINT16 FREN:1;
                VUINT16 TRSP:1;
                VUINT16 POL:1;
                VUINT16 EN:1;
                  VUINT16:2;
                VUINT16 CP:8;
            } B;
        } MPWMSM3SCR;

#ifdef _MIOS1
 VUINT32 res42a[4];
#else
        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM4PERR;          /*MPWMSM4 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM4PULR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM4CNTR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PIN:1;
                VUINT16 DDR:1;
                VUINT16 FREN:1;
                VUINT16 TRSP:1;
                VUINT16 POL:1;
                VUINT16 EN:1;
                  VUINT16:2;
                VUINT16 CP:8;
            } B;
        } MPWMSM4SCR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM5PERR;          /*MPWMSM5 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM5PULR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM5CNTR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PIN:1;
                VUINT16 DDR:1;
                VUINT16 FREN:1;
                VUINT16 TRSP:1;
                VUINT16 POL:1;
                VUINT16 EN:1;
                  VUINT16:2;
                VUINT16 CP:8;
            } B;
        } MPWMSM5SCR;
#endif

        union {
            VUINT16 R;
            VUINT16 B;
        } MMCSM6CNT;            /*MMCSM6 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MMCSM6MLR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PINC:1;
                VUINT16 PINL:1;
                VUINT16 FREN:1;
                VUINT16 EDGN:1;
                VUINT16 EDGP:1;
                VUINT16 CLS:2;
                  VUINT16:1;
                VUINT16 CP:8;
            } B;
        } MMCSM6SCRD, MMCSM6SCR;
#ifdef _MIOS1
    VUINT32 res42b[8];
#else
        union {
            VUINT16 R;
            VUINT16 B;
        } MMCSM7CNT;            /*MMCSM7 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MMCSM7MLR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PINC:1;
                VUINT16 PINL:1;
                VUINT16 FREN:1;
                VUINT16 EDGN:1;
                VUINT16 EDGP:1;
                VUINT16 CLS:2;
                  VUINT16:1;
                VUINT16 CP:8;
            } B;
        } MMCSM7SCRD, MMCSM7SCR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MMCSM8CNT;            /*MMCSM8 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MMCSM8MLR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PINC:1;
                VUINT16 PINL:1;
                VUINT16 FREN:1;
                VUINT16 EDGN:1;
                VUINT16 EDGP:1;
                VUINT16 CLS:2;
                  VUINT16:1;
                VUINT16 CP:8;
            } B;
        } MMCSM8SCRD, MMCSM8SCR;
#ifdef _MIOS14_RTC
        VUINT32 res42b[2];

        /*MRTCSM */
        union {
            VUINT32 S;
            struct {
                VUINT16 H;
                VUINT16 L;
            } R;
            VUINT32 B;
        } MRTCSMFRC;

        union {
            VUINT16 R;
            VUINT16 B;
        } MRTCPR;

        union {
            VUINT16 R;
            struct {
                VUINT16 WIP:1;
                  VUINT16:3;
                VUINT16 WEN:1;
                VUINT16 EN:1;
                  VUINT16:2;
                VUINT16 TEST:1;
                VUINT16 STB:1;
                  VUINT16:3;
                VUINT16 IR2:1;
                VUINT16 IR1:1;
                VUINT16 IR0:1;
            } B;
        } MRTCSCR;
#else
VUINT32 res42z[4];
#endif
#endif


        union {
            VUINT16 R;
            VUINT16 B;
        } MDASM11AR;            /*MDASM11 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MDASM11BR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PIN:1;
                VUINT16 WOR:1;
                VUINT16 FREN:1;
                  VUINT16:1;
                VUINT16 EDPOL:1;
                VUINT16 FORCA:1;
                VUINT16 FORCB:1;
                  VUINT16:2;
                VUINT16 BSL:2;
                  VUINT16:1;
                VUINT16 MOD:4;
            } B;
        } MDASM11SCRD, MDASM11SCR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MDASM12AR;            /*MDASM12 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MDASM12BR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PIN:1;
                VUINT16 WOR:1;
                VUINT16 FREN:1;
                  VUINT16:1;
                VUINT16 EDPOL:1;
                VUINT16 FORCA:1;
                VUINT16 FORCB:1;
                  VUINT16:2;
                VUINT16 BSL:2;
                  VUINT16:1;
                VUINT16 MOD:4;
            } B;
        } MDASM12SCRD, MDASM12SCR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MDASM13AR;            /*MDASM13 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MDASM13BR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PIN:1;
                VUINT16 WOR:1;
                VUINT16 FREN:1;
                  VUINT16:1;
                VUINT16 EDPOL:1;
                VUINT16 FORCA:1;
                VUINT16 FORCB:1;
                  VUINT16:2;
                VUINT16 BSL:2;
                  VUINT16:1;
                VUINT16 MOD:4;
            } B;
        } MDASM13SCRD, MDASM13SCR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MDASM14AR;            /*MDASM14 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MDASM14BR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PIN:1;
                VUINT16 WOR:1;
                VUINT16 FREN:1;
                  VUINT16:1;
                VUINT16 EDPOL:1;
                VUINT16 FORCA:1;
                VUINT16 FORCB:1;
                  VUINT16:2;
                VUINT16 BSL:2;
                  VUINT16:1;
                VUINT16 MOD:4;
            } B;
        } MDASM14SCRD, MDASM14SCR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MDASM15AR;            /*MDASM15 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MDASM15BR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PIN:1;
                VUINT16 WOR:1;
                VUINT16 FREN:1;
                  VUINT16:1;
                VUINT16 EDPOL:1;
                VUINT16 FORCA:1;
                VUINT16 FORCB:1;
                  VUINT16:2;
                VUINT16 BSL:2;
                  VUINT16:1;
                VUINT16 MOD:4;
            } B;
        } MDASM15SCRD, MDASM15SCR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM16PERR;         /*MPWMSM16 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM16PULR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM16CNTR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PIN:1;
                VUINT16 DDR:1;
                VUINT16 FREN:1;
                VUINT16 TRSP:1;
                VUINT16 POL:1;
                VUINT16 EN:1;
                  VUINT16:2;
                VUINT16 CP:8;
            } B;
        } MPWMSM16SCR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM17PERR;         /*MPWMSM17 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM17PULR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM17CNTR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PIN:1;
                VUINT16 DDR:1;
                VUINT16 FREN:1;
                VUINT16 TRSP:1;
                VUINT16 POL:1;
                VUINT16 EN:1;
                  VUINT16:2;
                VUINT16 CP:8;
            } B;
        } MPWMSM17SCR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM18PERR;         /*MPWMSM18 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM18PULR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM18CNTR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PIN:1;
                VUINT16 DDR:1;
                VUINT16 FREN:1;
                VUINT16 TRSP:1;
                VUINT16 POL:1;
                VUINT16 EN:1;
                  VUINT16:2;
                VUINT16 CP:8;
            } B;
        } MPWMSM18SCR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM19PERR;         /*MPWMSM19 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM19PULR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM19CNTR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PIN:1;
                VUINT16 DDR:1;
                VUINT16 FREN:1;
                VUINT16 TRSP:1;
                VUINT16 POL:1;
                VUINT16 EN:1;
                  VUINT16:2;
                VUINT16 CP:8;
            } B;
        } MPWMSM19SCR;
#ifdef _MIOS1
    VUINT32 res42c[4];
#else
        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM20PERR;         /*MPWMSM20 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM20PULR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM20CNTR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PIN:1;
                VUINT16 DDR:1;
                VUINT16 FREN:1;
                VUINT16 TRSP:1;
                VUINT16 POL:1;
                VUINT16 EN:1;
                  VUINT16:2;
                VUINT16 CP:8;
            } B;
        } MPWMSM20SCR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM21PERR;         /*MPWMSM21 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM21PULR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MPWMSM21CNTR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PIN:1;
                VUINT16 DDR:1;
                VUINT16 FREN:1;
                VUINT16 TRSP:1;
                VUINT16 POL:1;
                VUINT16 EN:1;
                  VUINT16:2;
                VUINT16 CP:8;
            } B;
        } MPWMSM21SCR;
#endif

        union {
            VUINT16 R;
            VUINT16 B;
        } MMCSM22CNT;           /*MMCSM22 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MMCSM22MLR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PINC:1;
                VUINT16 PINL:1;
                VUINT16 FREN:1;
                VUINT16 EDGN:1;
                VUINT16 EDGP:1;
                VUINT16 CLS:2;
                  VUINT16:1;
                VUINT16 CP:8;
            } B;
        } MMCSM22SCRD, MMCSM22SCR;
#ifdef _MIOS1
    VUINT32 res42d[8];
#else
        union {
            VUINT16 R;
            VUINT16 B;
        } MMCSM23CNT;           /*MMCSM23 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MMCSM23MLR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PINC:1;
                VUINT16 PINL:1;
                VUINT16 FREN:1;
                VUINT16 EDGN:1;
                VUINT16 EDGP:1;
                VUINT16 CLS:2;
                  VUINT16:1;
                VUINT16 CP:8;
            } B;
        } MMCSM23SCRD, MMCSM23SCR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MMCSM24CNT;           /*MMCSM24 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MMCSM24MLR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PINC:1;
                VUINT16 PINL:1;
                VUINT16 FREN:1;
                VUINT16 EDGN:1;
                VUINT16 EDGP:1;
                VUINT16 CLS:2;
                  VUINT16:1;
                VUINT16 CP:8;
            } B;
        } MMCSM24SCRD, MMCSM24SCR;

        VUINT32 res42d[4];
#endif
        union {
            VUINT16 R;
            VUINT16 B;
        } MDASM27AR;            /*MDASM27 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MDASM27BR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PIN:1;
                VUINT16 WOR:1;
                VUINT16 FREN:1;
                  VUINT16:1;
                VUINT16 EDPOL:1;
                VUINT16 FORCA:1;
                VUINT16 FORCB:1;
                  VUINT16:2;
                VUINT16 BSL:2;
                  VUINT16:1;
                VUINT16 MOD:4;
            } B;
        } MDASM27SCRD, MDASM27SCR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MDASM28AR;            /*MDASM28 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MDASM28BR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PIN:1;
                VUINT16 WOR:1;
                VUINT16 FREN:1;
                  VUINT16:1;
                VUINT16 EDPOL:1;
                VUINT16 FORCA:1;
                VUINT16 FORCB:1;
                  VUINT16:2;
                VUINT16 BSL:2;
                  VUINT16:1;
                VUINT16 MOD:4;
            } B;
        } MDASM28SCRD, MDASM28SCR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MDASM29AR;            /*MDASM29 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MDASM29BR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PIN:1;
                VUINT16 WOR:1;
                VUINT16 FREN:1;
                  VUINT16:1;
                VUINT16 EDPOL:1;
                VUINT16 FORCA:1;
                VUINT16 FORCB:1;
                  VUINT16:2;
                VUINT16 BSL:2;
                  VUINT16:1;
                VUINT16 MOD:4;
            } B;
        } MDASM29SCRD, MDASM29SCR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MDASM30AR;            /*MDASM30 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MDASM30BR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PIN:1;
                VUINT16 WOR:1;
                VUINT16 FREN:1;
                  VUINT16:1;
                VUINT16 EDPOL:1;
                VUINT16 FORCA:1;
                VUINT16 FORCB:1;
                  VUINT16:2;
                VUINT16 BSL:2;
                  VUINT16:1;
                VUINT16 MOD:4;
            } B;
        } MDASM30SCRD, MDASM30SCR;

        union {
            VUINT16 R;
            VUINT16 B;
        } MDASM31AR;            /*MDASM31 */

        union {
            VUINT16 R;
            VUINT16 B;
        } MDASM31BR;

        union {
            VUINT16 R;
            struct {
                VUINT16 PIN:1;
                VUINT16 WOR:1;
                VUINT16 FREN:1;
                  VUINT16:1;
                VUINT16 EDPOL:1;
                VUINT16 FORCA:1;
                VUINT16 FORCB:1;
                  VUINT16:2;
                VUINT16 BSL:2;
                  VUINT16:1;
                VUINT16 MOD:4;
            } B;
        } MDASM31SCRD, MDASM31SCR;

        union {                 /*MPIOSM32 */
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
        } MPIOSM32DR;

        union {
            VUINT16 R;
            struct {
                VUINT16 DDR15:1;
                VUINT16 DDR14:1;
                VUINT16 DDR13:1;
                VUINT16 DDR12:1;
                VUINT16 DDR11:1;
                VUINT16 DDR10:1;
                VUINT16 DDR9:1;
                VUINT16 DDR8:1;
                VUINT16 DDR7:1;
                VUINT16 DDR6:1;
                VUINT16 DDR5:1;
                VUINT16 DDR4:1;
                VUINT16 DDR3:1;
                VUINT16 DDR2:1;
                VUINT16 DDR1:1;
                VUINT16 DDR0:1;
            } B;
        } MPIOSM32DDR;

        VUINT16 res42e[894];

#ifdef _MIOS1
    union {                     /*BIS */
        VUINT16 R;
        struct {
            VUINT16 TEST:1;
              VUINT16:13;
            VUINT16 VF:1;
            VUINT16 VFLS:1;
        } B;
    } MIOS1TPCR;

    VUINT16 res42ee;

    union {
        VUINT16 R;
        struct {
            VUINT16 MN:8;
            VUINT16 VN:8;
        } B;
    } MIOS1VNR;

    union {
        VUINT16 R;
        struct {
            VUINT16 STOP:1;
              VUINT16:1;
            VUINT16 FRZ:1;
            VUINT16 RST:1;
              VUINT16:4;
            VUINT16 SUPV:1;
              VUINT16:3;
            VUINT16 IARB:4;
        } B;
    } MIOS1MCR;

    VUINT32 res42f[3];
    VUINT16 res42y;

    union {                     /*PSM */
        VUINT16 R;
        struct {
            VUINT16 PREN:1;
            VUINT16 FREN:1;
              VUINT16:10;
            VUINT16 PSL:4;
        } B;
    } MCPSMSCR;

    VUINT16 res42g[500];

    union {                     /*IRSM0 */
        VUINT16 R;
        struct {
            VUINT16 FLG15:1;
            VUINT16 FLG14:1;
            VUINT16 FLG13:1;
            VUINT16 FLG12:1;
            VUINT16 FLG11:1;
              VUINT16:4;
            VUINT16 FLG6:1;
              VUINT16:2;
            VUINT16 FLG3:1;
            VUINT16 FLG2:1;
            VUINT16 FLG1:1;
            VUINT16 FLG0:1;
        } B;
    } MIOS1SR0;

    VUINT16 res42h;

    union {
        VUINT16 R;
        struct {
            VUINT16 EN15:1;
            VUINT16 EN14:1;
            VUINT16 EN13:1;
            VUINT16 EN12:1;
            VUINT16 EN11:1;
              VUINT16:4;
            VUINT16 EN6:1;
              VUINT16:2;
            VUINT16 EN3:1;
            VUINT16 EN2:1;
            VUINT16 EN1:1;
            VUINT16 EN0:1;
        } B;
    } MIOS1ER0;

    union {
        VUINT16 R;
        struct {
            VUINT16 IRP15:1;
            VUINT16 IRP14:1;
            VUINT16 IRP13:1;
            VUINT16 IRP12:1;
            VUINT16 IRP11:1;
              VUINT16:4;
            VUINT16 IRP6:1;
              VUINT16:2;
            VUINT16 IRP3:1;
            VUINT16 IRP2:1;
            VUINT16 IRP1:1;
            VUINT16 IRP0:1;
        } B;
    } MIOS1RPR0;

    VUINT32 res42i[10];

    union {
        VUINT16 R;
        struct {
            VUINT16:5;
            VUINT16 LVL:3;
            VUINT16 TM:2;
              VUINT16:6;
        } B;
    } MIOS1LVL0;

    VUINT16 res42j[7];

    union {                     /*IRSM1 */
        VUINT16 R;
        struct {
            VUINT16 FLG31:1;
            VUINT16 FLG30:1;
            VUINT16 FLG29:1;
            VUINT16 FLG28:1;
            VUINT16 FLG27:1;
              VUINT16:4;
            VUINT16 FLG22:1;
              VUINT16:2;
            VUINT16 FLG19:1;
            VUINT16 FLG18:1;
            VUINT16 FLG17:1;
            VUINT16 FLG16:1;
        } B;
    } MIOS1SR1;

    VUINT16 res42k;

    union {
        VUINT16 R;
        struct {
            VUINT16 EN31:1;
            VUINT16 EN30:1;
            VUINT16 EN29:1;
            VUINT16 EN28:1;
            VUINT16 EN27:1;
              VUINT16:4;
            VUINT16 EN22:1;
              VUINT16:2;
            VUINT16 EN19:1;
            VUINT16 EN18:1;
            VUINT16 EN17:1;
            VUINT16 EN16:1;
        } B;
    } MIOS1ER1;

    union {
        VUINT16 R;
        struct {
            VUINT16 IRP31:1;
            VUINT16 IRP30:1;
            VUINT16 IRP29:1;
            VUINT16 IRP28:1;
            VUINT16 IRP27:1;
              VUINT16:4;
            VUINT16 IRP22:1;
              VUINT16:2;
            VUINT16 IRP19:1;
            VUINT16 IRP18:1;
            VUINT16 IRP17:1;
            VUINT16 IRP16:1;
        } B;
    } MIOS1RPR1;

    VUINT32 res42l[10];

    union {
        VUINT16 R;
        struct {
            VUINT16:5;
            VUINT16 LVL:3;
            VUINT16 TM:2;
              VUINT16:6;
        } B;
    } MIOS1LVL1;
};
#else
#ifdef _MPC565_H_
        union {                 /*BIS */
            VUINT16 R;
            struct {
                VUINT16 TEST:1;
                  VUINT16:7;
                VUINT16 VMUX7:1;
                VUINT16 VMUX6:1;
                VUINT16 VMUX5:1;
                VUINT16 VMUX4:1;
                VUINT16 VMUX3:1;
                VUINT16 VMUX2:1;
                VUINT16 VMUX1:1;
                VUINT16 VMUX0:1;
            } B;
        } MIOS14TPCR;
#else
    union {                     /*BIS */
        VUINT16 R;
        struct {
            VUINT16 TEST:1;
           	VUINT16		:13;
            VUINT16 VF	:1;
            VUINT16 VFLS:1;
        } B;
    } MIOS14TPCR;
#endif

        union {
            VUINT16 R;
            struct {
                VUINT16:8;
                VUINT16 VECT7:1;
                VUINT16 VECT6:1;
                VUINT16 VECT5:1;
                VUINT16 VECT4:1;
            } B;
        } MIOS14VECT;

        union {
            VUINT16 R;
            struct {
                VUINT16 MN:8;
                VUINT16 VN:8;
            } B;
        } MIOS14VNR;

        union {
            VUINT16 R;
            struct {
                VUINT16 STOP:1;
                  VUINT16:1;
                VUINT16 FRZ:1;
                VUINT16 RST:1;
                  VUINT16:4;
                VUINT16 SUPV:1;
                  VUINT16:3;
                VUINT16 IARB:4;
            } B;
        } MIOS14MCR;

        VUINT32 res42f[3];
        VUINT16 res42x;

        union {                 /*PSM */
            VUINT16 R;
            struct {
                VUINT16 PREN:1;
                VUINT16 FREN:1;
                  VUINT16:10;
                VUINT16 PSL:4;
            } B;
        } MCPSMSCR;

        VUINT16 res42g[500];

        union {                 /*IRSM0 */
            VUINT16 R;
            struct {
                VUINT16 FLG15:1;
                VUINT16 FLG14:1;
                VUINT16 FLG13:1;
                VUINT16 FLG12:1;
                VUINT16 FLG11:1;
                VUINT16 FLG10:1;
                  VUINT16:1;
                VUINT16 FLG8:1;
                VUINT16 FLG7:1;
                VUINT16 FLG6:1;
                VUINT16 FLG5:1;
                VUINT16 FLG4:1;
                VUINT16 FLG3:1;
                VUINT16 FLG2:1;
                VUINT16 FLG1:1;
                VUINT16 FLG0:1;
            } B;
        } MIOS14SR0;

        VUINT16 res42h;

        union {
            VUINT16 R;
            struct {
                VUINT16 EN15:1;
                VUINT16 EN14:1;
                VUINT16 EN13:1;
                VUINT16 EN12:1;
                VUINT16 EN11:1;
                VUINT16 EN10:1;
                  VUINT16:1;
                VUINT16 EN8:1;
                VUINT16 EN7:1;
                VUINT16 EN6:1;
                VUINT16 EN5:1;
                VUINT16 EN4:1;
                VUINT16 EN3:1;
                VUINT16 EN2:1;
                VUINT16 EN1:1;
                VUINT16 EN0:1;
            } B;
        } MIOS14ER0;

#ifdef _MPC565_H_
        union {
            VUINT16 R;
            struct {
                VUINT16 IRP15:1;
                VUINT16 IRP14:1;
                VUINT16 IRP13:1;
                VUINT16 IRP12:1;
                VUINT16 IRP11:1;
                VUINT16 IRP10:1;
                  VUINT16:1;
                VUINT16 IRP9:1;
                VUINT16 IRP8:1;
                VUINT16 IRP6:1;
                VUINT16 IRP5:1;
                VUINT16 IRP4:1;
                VUINT16 IRP3:1;
                VUINT16 IRP2:1;
                VUINT16 IRP1:1;
                VUINT16 IRP0:1;
            } B;
        } MIOS14RPR0;
#else
   union {
        VUINT16 R;
        struct {
            VUINT16 IRP15:1;
            VUINT16 IRP14:1;
            VUINT16 IRP13:1;
            VUINT16 IRP12:1;
            VUINT16 IRP11:1;
						VUINT16 IRP10:1;
              VUINT16:1;

						VUINT16 IRP8:1;
						VUINT16 IRP7:1;
            VUINT16 IRP6:1;
						VUINT16 IRP5:1;
						VUINT16 IRP4:1;
            VUINT16 IRP3:1;
            VUINT16 IRP2:1;
            VUINT16 IRP1:1;
            VUINT16 IRP0:1;
        } B;
    } MIOS14RPR0;
#endif

        VUINT32 res42i[10];

        union {
            VUINT16 R;
            struct {
                VUINT16:5;
                VUINT16 LVL:3;
                VUINT16 TM:2;
                  VUINT16:6;
            } B;
        } MIOS14LVL0;

        VUINT16 res42j[7];

        union {                 /*IRSM1 */
            VUINT16 R;
            struct {
                VUINT16 FLG31:1;
                VUINT16 FLG30:1;
                VUINT16 FLG29:1;
                VUINT16 FLG28:1;
                VUINT16 FLG27:1;
                  VUINT16:2;
                VUINT16 FLG24:1;
                VUINT16 FLG23:1;
                VUINT16 FLG22:1;
                VUINT16 FLG21:1;
                VUINT16 FLG20:1;
                VUINT16 FLG19:1;
                VUINT16 FLG18:1;
                VUINT16 FLG17:1;
                VUINT16 FLG16:1;
            } B;
        } MIOS14SR1;

        VUINT16 res42k;

        union {
            VUINT16 R;
            struct {
                VUINT16 EN31:1;
                VUINT16 EN30:1;
                VUINT16 EN29:1;
                VUINT16 EN28:1;
                VUINT16 EN27:1;
                  VUINT16:2;
                VUINT16 EN24:1;
                VUINT16 EN23:1;
                VUINT16 EN22:1;
                VUINT16 EN21:1;
                VUINT16 EN20:1;
                VUINT16 EN19:1;
                VUINT16 EN18:1;
                VUINT16 EN17:1;
                VUINT16 EN16:1;
            } B;
        } MIOS14ER1;

        union {
            VUINT16 R;
            struct {
                VUINT16 IRP31:1;
                VUINT16 IRP30:1;
                VUINT16 IRP29:1;
                VUINT16 IRP28:1;
                VUINT16 IRP27:1;
                  VUINT16:2;
                VUINT16 IRP24:1;
                VUINT16 IRP23:1;
                VUINT16 IRP22:1;
                VUINT16 IRP21:1;
                VUINT16 IRP20:1;
                VUINT16 IRP19:1;
                VUINT16 IRP18:1;
                VUINT16 IRP17:1;
                VUINT16 IRP16:1;
            } B;
        } MIOS14RPR1;

        VUINT32 res42l[10];

        union {
            VUINT16 R;
            struct {
                VUINT16:5;
                VUINT16 LVL:3;
                VUINT16 TM:2;
                  VUINT16:6;
            } B;
        } MIOS14LVL1;
    };
#endif

#ifdef __MWERKS__
#pragma pack(pop)
#endif

#ifdef  __cplusplus
}
#endif

#endif
/* ifndef _M_MIOS14_H  */
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

