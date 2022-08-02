/* $Revision: 1.1.6.1 $ */
/**************************************************************************/
/* FILE NAME: m_mios1.h                       COPYRIGHT (c) MOTOROLA 1999 */
/* VERSION:  1.3                                  All Rights Reserved     */
/*                                                                        */
//* DESCRIPTION:                                                          */
/* This file defines all of the registers and bit fields on the MIOS1     */
/* module and declares an instance of the MIOS1 structure.                */
/*========================================================================*/
/* AUTHOR: Jeff Loeliger                                                  */
/* COMPILER: Diab Data        VERSION: 4.2b                               */
/*                                                                        */
/* HISTORY                                                                */
/* REV      AUTHOR      DATE       DESCRIPTION OF CHANGE                  */
/* ---   -----------  ---------    ---------------------                  */
/* 0.1   J. Loeliger  06/Apr/98    Initial version of file.               */
/* 0.2                20/Dec/98    Broke header file into modules.        */
/* 1.0   J. Loeliger  12/Jan/99    Added three ways to create an instance */
/*                                   of the module and added PACK.        */
/* 1.1   J. Loeliger  03/Jun/99    Changed PIO registers names to match   */
/*                                   changes in the user's manual.        */
/* 1.2   J. Loeliger  22/Jun/99    Added ifdef to support C++             */
/*       K. Muto                   Rename registers as defined in MPC555  */
/*                                 manual rev 1/Mar/99. Changes are       */
/*                                 PWM->MPWMSM, MC->MMCSM, DASM->MDASM    */
/*                                 PIO->MPIOSM.                           */
/* 1.3   J. Kobler    11/Jun/01    Added support for CodeWarrior Embedded */
/*                                   PowerPc 5.0.                         */
/**************************************************************************/

#ifndef _MPC555_MIOS1_H
#define _MPC555_MIOS1_H

#ifndef _MPC555_COMMON_H
#include "m_common.h"
#endif /*  ifndef _MPC555_COMMON_H  */

#ifdef  __cplusplus
extern "C" {
#endif

#ifdef __MWERKS__
#pragma pack(push,1)
#endif

/****************************************************************************/
/*                              MODULE :MIOS1                               */
/****************************************************************************/
struct MIOS1_tag {

    union {
        VUINT16 R;
        VUINT16 B;
    } MPWMSM0PERR;                 /*MPWMSM0 */

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
    } MPWMSM1PERR;                 /*MPWMSM1 */

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
    } MPWMSM2PERR;                 /*MPWMSM2 */

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
    } MPWMSM3PERR;                 /*MPWMSM3 */

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

    VUINT32 res42a[4];

    union {
        VUINT16 R;
        VUINT16 B;
    } MMCSM6CNT;                   /*MMCSM6 */

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

    VUINT32 res42b[8];

    union {
        VUINT16 R;
        VUINT16 B;
    } MDASM11AR;                 /*MDASM11 */

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
    } MDASM12AR;                 /*MDASM12 */

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
    } MDASM13AR;                 /*MDASM13 */

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
    } MDASM14AR;                 /*MDASM14 */

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
    } MDASM15AR;                 /*MDASM15 */

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
    } MPWMSM16PERR;                /*MPWMSM16 */

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
    } MPWMSM17PERR;                /*MPWMSM17 */

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
    } MPWMSM18PERR;                /*MPWMSM18 */

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
    } MPWMSM19PERR;                /*MPWMSM19 */

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

    VUINT32 res42c[4];

    union {
        VUINT16 R;
        VUINT16 B;
    } MMCSM22CNT;                  /*MMCSM22 */

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

    VUINT32 res42d[8];

    union {
        VUINT16 R;
        VUINT16 B;
    } MDASM27AR;                 /*MDASM27 */

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
    } MDASM28AR;                 /*MDASM28 */

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
    } MDASM29AR;                 /*MDASM29 */

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
    } MDASM30AR;                 /*MDASM30 */

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
    } MDASM31AR;                 /*MDASM31 */

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

    union {                     /*MPIOSM32 */
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
    VUINT16 res42z;

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

#ifdef __MWERKS__
#pragma pack(pop)
#endif

/******************************************************************/
/* There are three way to create an instance of the MIOS1 module: */
/* -Use a fixed structure (Default)                               */
/* -Use the Diab compiler sections (if DIAB_SCETIONS is defined)  */
/* -Use a pointer (if HEADER_POINTERS is defined)                 */
/******************************************************************/
#ifdef DIAB_SECTIONS            /* Diab Compiler Only */

#pragma section MIOS1  address=0x306000  /* Map modules to fixed addresses. */
#pragma use_section MIOS1 MIOS1
EXT struct MIOS1_tag MIOS1;

#else
#ifdef HEADER_POINTERS

/* Create a global pointer. */

#ifdef Main_Program
struct MIOS1_tag *MIOS1 = (struct MIOS1_tag *) (INTERNAL_MEMORY_BASE + 0x306000);
#else
EXT struct MIOS1_tag *MIOS1;
#endif

#else

/* Use a fixed structure, this is the default */
#define MIOS1  (*( struct MIOS1_tag *)  (INTERNAL_MEMORY_BASE + 0x306000))

#endif /* HEADER_POINTERS */

#endif /* DIAB_SECTIONS */

#ifdef  __cplusplus
}
#endif

#endif /* ifndef _MPC555_MIOS1_H  */

/*****************************************************************************/
/* Motorola reserves the right to make changes without further notice to any */
/* product herein to improve reliability, function, or design. Motorola does */
/* not assume any  liability arising  out  of the  application or use of any */
/* product,  circuit, or software described herein;  neither  does it convey */
/* any license under its patent rights  nor the  rights of others.  Motorola */
/* products are not designed, intended,  or authorized for use as components */
/* in  systems  intended  for  surgical  implant  into  the  body, or  other */
/* applications intended to support life, or  for any  other application  in */
/* which the failure of the Motorola product  could create a situation where */
/* personal injury or death may occur. Should Buyer purchase or use Motorola */
/* products for any such intended  or unauthorized  application, Buyer shall */
/* indemnify and  hold  Motorola  and its officers, employees, subsidiaries, */
/* affiliates,  and distributors harmless against all claims costs, damages, */
/* and expenses, and reasonable  attorney  fees arising  out of, directly or */
/* indirectly,  any claim of personal injury  or death  associated with such */
/* unintended or unauthorized use, even if such claim alleges that  Motorola */
/* was negligent regarding the  design  or manufacture of the part. Motorola */
/* and the Motorola logo* are registered trademarks of Motorola Ltd.         */
/*****************************************************************************/
