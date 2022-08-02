/**************************************************************************/
/* FILE NAME: m_usiu.h                        COPYRIGHT (c) MOTOROLA 2002 */
/* VERSION:  1.61                                 All Rights Reserved     */
/*                                                                        */
/* DESCRIPTION:                                                           */
/* This file defines all of the registers and bit fields on the USIU      */
/* * UIMB modules.                                                        */
/*========================================================================*/
/* AUTHOR: Jeff Loeliger                                                  */
/* COMPILER: Diab Data        VERSION: 4.3f                               */
/*                                                                        */
/* HISTORY                                                                */
/* REV      AUTHOR      DATE       DESCRIPTION OF CHANGE                  */
/* ---   -----------  ---------    ---------------------                  */
/* 0.1   J. Loeliger  06/Apr/98    Initial version of file.               */
/* 0.2                20/Dec/98    Broke  header file into modules.       */
/* 1.0   J. Loeliger  12/Jan/99    Added three ways to create an instance */
/*                                   of the module and added PACK.        */
/* 1.1   J. Loeliger  29/Mar/99    Added new WEBS field to BRx.           */
/* 1.2   J. Loeliger  22/Jun/99    Added ifdef to support C++             */
/*       K. Muto                   Added MTSC field to SIUMCR  and        */
/*                                 DBCT,DCSLR,MFPDL,LPML field to SCCR    */
/* 1.3   J. Loeliger  01/Sep/99    Changed RSRK to 32 bits and removed    */
/*                                   bit fields from key registers.       */
/* 1.4   J. Loeliger  04/Oct/00    Fixed location of COLIE bit. There is  */
/*                                   was incorrect in the user's manual.  */
/* 1.5   J. Kobler    11/Jun/01    Added support for CodeWarrior Embedded */
/*                                   PowerPc 5.0.                         */
/* 1.6   J. Loeliger  16/Apr/02    Created generic version for all MPC5xx.*/
/*                                   Merged 555 and 56x USIU files.       */
/*                                   Merged UIMB module.                  */
/* 1.61  J. Loeliger  11/Jun/02    Changed device defines.                */
/**************************************************************************/

#ifndef _M_USIU_H
#define _M_USIU_H
																							  
#ifndef _M_COMMON_H
#include "m_common.h"
#endif /*  ifndef _M_COMMON_H  */

#ifdef  __cplusplus
extern "C" {
#endif

#ifdef __MWERKS__
#pragma pack(push,1)
#endif

#ifdef _MPC555_H_
/****************************************************************************/
/*                              MODULE : USIU - MPC555                      */
/****************************************************************************/
struct USIU_tag {
    union {
        VUINT32 R;
        struct {
            VUINT32 EARB:1;
            VUINT32 EARP:3;
              VUINT32:4;
            VUINT32 DSHW:1;
            VUINT32 DBGC:2;
            VUINT32 DBPC:1;
            VUINT32 ATWC:1;
            VUINT32 GPC:2;
            VUINT32 DLK:1;
              VUINT32:1;
            VUINT32 SC:2;
            VUINT32 RCTX:1;
            VUINT32 MLRC:2;
              VUINT32:2;
            VUINT32 MTSC:1;
              VUINT32:7;
        } B;
    } SIUMCR;

    union {
        VUINT32 R;
        struct {
            VUINT32 SWTC:16;
            VUINT32 BMT:8;
            VUINT32 BME:1;
              VUINT32:3;
            VUINT32 SWF:1;
            VUINT32 SWE:1;
            VUINT32 SWRI:1;
            VUINT32 SWP:1;
        } B;
    } SYPCR;

    VUINT32 res0;
    VUINT16 res1;

    union {
        VUINT16 R;
        struct {
            VUINT16 SWSR:16;
        } B;
    } SWSR;

    union {
        VUINT32 R;
        struct {
            VUINT32 IRQ0:1;
            VUINT32 LVL0:1;
            VUINT32 IRQ1:1;
            VUINT32 LVL1:1;
            VUINT32 IRQ2:1;
            VUINT32 LVL2:1;
            VUINT32 IRQ3:1;
            VUINT32 LVL3:1;
            VUINT32 IRQ4:1;
            VUINT32 LVL4:1;
            VUINT32 IRQ5:1;
            VUINT32 LVL5:1;
            VUINT32 IRQ6:1;
            VUINT32 LVL6:1;
            VUINT32 IRQ7:1;
            VUINT32 LVL7:1;
              VUINT32:16;
        } B;
    } SIPEND;

    union {
        VUINT32 R;
        struct {
            VUINT32 IRM0:1;
            VUINT32 LVM0:1;
            VUINT32 IRM1:1;
            VUINT32 LVM1:1;
            VUINT32 IRM2:1;
            VUINT32 LVM2:1;
            VUINT32 IRM3:1;
            VUINT32 LVM3:1;
            VUINT32 IRM4:1;
            VUINT32 LVM4:1;
            VUINT32 IRM5:1;
            VUINT32 LVM5:1;
            VUINT32 IRM6:1;
            VUINT32 LVM6:1;
            VUINT32 IRM7:1;
            VUINT32 LVM7:1;
              VUINT32:16;
        } B;
    } SIMASK;

    union {
        VUINT32 R;
        struct {
            VUINT32 ED0:1;
            VUINT32 WM0:1;
            VUINT32 ED1:1;
            VUINT32 WM1:1;
            VUINT32 ED2:1;
            VUINT32 WM2:1;
            VUINT32 ED3:1;
            VUINT32 WM3:1;
            VUINT32 ED4:1;
            VUINT32 WM4:1;
            VUINT32 ED5:1;
            VUINT32 WM5:1;
            VUINT32 ED6:1;
            VUINT32 WM6:1;
            VUINT32 ED7:1;
            VUINT32 WM7:1;
              VUINT32:16;
        } B;
    } SIEL;

    union {
        VUINT32 R;
        struct {
            VUINT32 INTERRUPT_CODE:8;
              VUINT32:24;
        } B;
    } SIVEC;

    union {
        VUINT32 R;
        struct {
            VUINT32:18;
            VUINT32 IEXT:1;
            VUINT32 IBMT:1;
              VUINT32:6;
            VUINT32 DEXT:1;
            VUINT32 DBM:1;
              VUINT32:4;
        } B;
    } TESR;

    union {
        VUINT32 R;
        VUINT32 B;
    } SGPIODT1;

    union {
        VUINT32 R;
        struct {
            VUINT32 SGPIOC:8;
            VUINT32 SGPIOA:24;
        } B;
    } SGPIODT2;

    union {
        VUINT32 R;
        struct {
            VUINT32 SDDRC:8;
              VUINT32:8;
            VUINT32 GDDR0:1;
            VUINT32 GDDR1:1;
            VUINT32 GDDR2:1;
            VUINT32 GDDR3:1;
            VUINT32 GDDR4:1;
            VUINT32 GDDR5:1;
              VUINT32:2;
            VUINT32 SDDRD:8;
        } B;
    } SGPIOCR;

    union {
        VUINT32 R;
        struct {
            VUINT32:16;
            VUINT32 PRPM:1;
            VUINT32 SLVM:1;
              VUINT32:1;
            VUINT32 SIZE:2;
            VUINT32 SUPU:1;
            VUINT32 INST:1;
              VUINT32:2;
            VUINT32 RESV:1;
            VUINT32 CONT:1;
              VUINT32:1;
            VUINT32 TRAC:1;
            VUINT32 SIZEN:1;
              VUINT32:2;
        } B;
    } EMCR;

    VUINT32 res1aa;
    VUINT32 res1ab;

    union {
        VUINT32 R;
        struct {
            VUINT32 SLRC0:1;
            VUINT32 SLRC1:1;
            VUINT32 SLRC2:1;
            VUINT32 SLRC3:1;
            VUINT32:2;
            VUINT32 PRDS:1;
            VUINT32 SPRDS:1;
			VUINT32 FTPU_PU:1;
            VUINT32:23;
        } B;
    } PDMCR;

    VUINT32 res2[48];

    /*Memory Controller Registers */
    union {
        VUINT32 R;
        struct {
            VUINT32 BA:17;
            VUINT32 AT:3;
            VUINT32 PS:2;
              VUINT32:1;
            VUINT32 WP:1;
              VUINT32:2;
            VUINT32 WEBS:1;
            VUINT32 TBDIP:1;
            VUINT32 LBDIP:1;
            VUINT32 SETA:1;
            VUINT32 BI:1;
            VUINT32 V:1;
        } B;
    } BR0;

    union {
        VUINT32 R;
        struct {
            VUINT32 AM:17;
            VUINT32 ATM:3;
            VUINT32 CSNT:1;
            VUINT32 ACS:2;
            VUINT32 EHTR:1;
            VUINT32 SCY:4;
            VUINT32 BSCY:3;
            VUINT32 TRLX:1;
        } B;
    } OR0;

    union {
        VUINT32 R;
        struct {
            VUINT32 BA:17;
            VUINT32 AT:3;
            VUINT32 PS:2;
              VUINT32:1;
            VUINT32 WP:1;
              VUINT32:2;
            VUINT32 WEBS:1;
            VUINT32 TBDIP:1;
            VUINT32 LBDIP:1;
            VUINT32 SETA:1;
            VUINT32 BI:1;
            VUINT32 V:1;
        } B;
    } BR1;

    union {
        VUINT32 R;
        struct {
            VUINT32 AM:17;
            VUINT32 ATM:3;
            VUINT32 CSNT:1;
            VUINT32 ACS:2;
            VUINT32 EHTR:1;
            VUINT32 SCY:4;
            VUINT32 BSCY:3;
            VUINT32 TRLX:1;
        } B;
    } OR1;

    union {
        VUINT32 R;
        struct {
            VUINT32 BA:17;
            VUINT32 AT:3;
            VUINT32 PS:2;
              VUINT32:1;
            VUINT32 WP:1;
              VUINT32:2;
            VUINT32 WEBS:1;
            VUINT32 TBDIP:1;
            VUINT32 LBDIP:1;
            VUINT32 SETA:1;
            VUINT32 BI:1;
            VUINT32 V:1;
        } B;
    } BR2;

    union {
        VUINT32 R;
        struct {
            VUINT32 AM:17;
            VUINT32 ATM:3;
            VUINT32 CSNT:1;
            VUINT32 ACS:2;
            VUINT32 EHTR:1;
            VUINT32 SCY:4;
            VUINT32 BSCY:3;
            VUINT32 TRLX:1;
        } B;
    } OR2;

    union {
        VUINT32 R;
        struct {
            VUINT32 BA:17;
            VUINT32 AT:3;
            VUINT32 PS:2;
              VUINT32:1;
            VUINT32 WP:1;
              VUINT32:2;
            VUINT32 WEBS:1;
            VUINT32 TBDIP:1;
            VUINT32 LBDIP:1;
            VUINT32 SETA:1;
            VUINT32 BI:1;
            VUINT32 V:1;
        } B;
    } BR3;

    union {
        VUINT32 R;
        struct {
            VUINT32 AM:17;
            VUINT32 ATM:3;
            VUINT32 CSNT:1;
            VUINT32 ACS:2;
            VUINT32 EHTR:1;
            VUINT32 SCY:4;
            VUINT32 BSCY:3;
            VUINT32 TRLX:1;
        } B;
    } OR3;

    VUINT32 res3[8];

    union {
        VUINT32 R;
        struct {
            VUINT32:1;
            VUINT32 BA:6;
              VUINT32:3;
            VUINT32 AT:3;
              VUINT32:15;
            VUINT32 DMCS:3;
            VUINT32 DME:1;
        } B;
    } DMBR;

    union {
        VUINT32 R;
        struct {
            VUINT32:1;
            VUINT32 AM:6;
              VUINT32:3;
            VUINT32 ATM:3;
              VUINT32:19;
        } B;
    } DMOR;

    VUINT32 res4[12];

    union {
        VUINT16 R;
        struct {
            VUINT16:8;
            VUINT16 WPER0:1;
            VUINT16 WPER1:1;
            VUINT16 WPER2:1;
            VUINT16 WPER3:1;
              VUINT16:4;
        } B;
    } MSTAT;

    VUINT16 res4a;
    VUINT32 res4b[33];

    /*System integration Timers */
    union {
        VUINT16 R;
        struct {
            VUINT16 TBIRQ:8;
            VUINT16 REFA:1;
            VUINT16 REFB:1;
              VUINT16:2;
            VUINT16 REFAE:1;
            VUINT16 REFBE:1;
            VUINT16 TBF:1;
            VUINT16 TBE:1;
        } B;
    } TBSCR;

    VUINT16 res4c;

    union {
        VUINT32 R;
        VUINT32 B;
    } TBREF0;

    union {
        VUINT32 R;
        VUINT32 B;
    } TBREF1;

    VUINT32 res5[5];

    union {
        VUINT16 R;
        struct {
            VUINT16 RTCIRQ:8;
            VUINT16 SEC:1;
            VUINT16 ALR:1;
              VUINT16:1;
            VUINT16 M:1;
            VUINT16 SIE:1;
            VUINT16 ALE:1;
            VUINT16 RTF:1;
            VUINT16 RTE:1;
        } B;
    } RTCSC;

    VUINT16 res5a;

    union {
        VUINT32 R;
        VUINT32 B;
    } RTC;

    union {
        VUINT32 R;
        VUINT32 B;
    } RTSEC;

    union {
        VUINT32 R;
        VUINT32 B;
    } RTCAL;

    VUINT32 res6[4];

    union {
        VUINT16 R;
        struct {
            VUINT16 PIRQ:8;
            VUINT16 PS:1;
              VUINT16:4;
            VUINT16 PIE:1;
            VUINT16 PITF:1;
            VUINT16 PTE:1;
        } B;
    } PISCR;

    VUINT16 res6a;

    union {
        VUINT32 R;
        struct {
            VUINT32 PITC:16;
              VUINT32:16;
        } B;
    } PITC;

    union {
        VUINT32 R;
        struct {
            VUINT32 PIT:16;
              VUINT32:16;
        } B;
    } PITR;

    VUINT32 res7[13];

    /*Clocks and Reset */
    union {
        VUINT32 R;
        struct {
            VUINT32 DBCT:1;
            VUINT32 COM:2;
            VUINT32 DCSLR:1;
            VUINT32 MFPDL:1;
            VUINT32 LPML:1;
            VUINT32 TBS:1;
            VUINT32 RTDIV:1;
            VUINT32 STBUC:1;
              VUINT32:1;
            VUINT32 PRQEN:1;
            VUINT32 RTSEL:1;
            VUINT32 BUCS:1;
            VUINT32 EBDF:2;
            VUINT32 LME:1;
            VUINT32 EECLK:2;
            VUINT32 ENGDIV:6;
              VUINT32:1;
            VUINT32 DFNL:3;
              VUINT32:1;
            VUINT32 DFNH:3;
        } B;
    } SCCR;

    union {
        VUINT32 R;
        struct {
            VUINT32 MF:12;
            VUINT32 MFPDL:1;
            VUINT32 LOCS:1;
            VUINT32 LOCSS:1;
            VUINT32 SPLS:1;
            VUINT32 SPLSS:1;
            VUINT32 TEXPS:1;
            VUINT32 LPML:1;
            VUINT32 TMIST:1;
              VUINT32:1;
            VUINT32 CSRC:1;
            VUINT32 LPM:2;
            VUINT32 CSR:1;
            VUINT32 LOLRE:1;
              VUINT32:1;
            VUINT32 DIVF:5;
        } B;
    } PLPRCR;

    union {
        VUINT16 R;
        struct {
            VUINT16 EHRS:1;
            VUINT16 ESRS:1;
            VUINT16 LLRS:1;
            VUINT16 SWRS:1;
            VUINT16 CSRS:1;
            VUINT16 DBHRS:1;
            VUINT16 DBSRS:1;
            VUINT16 JTRS:1;
            VUINT16 OCCS:1;
            VUINT16 ILBC:1;
            VUINT16 GPOR:1;
            VUINT16 GHRST:1;
            VUINT16 GSRST:1;
              VUINT16:3;
        } B;
    } RSR;

    VUINT16 res7a;

    union {
        VUINT16 R;
        struct {
            VUINT16 COLIRQ:8;
            VUINT16 COLIS:1;
              VUINT16:1;
            VUINT16 COLIE:1;
              VUINT16:5;
        } B;
    } COLIR;

    VUINT16 res7B;

    union {
        VUINT16 R;
        struct {
            VUINT16:1;
            VUINT16 LVSRS:4;
            VUINT16 VSRDE:1;
              VUINT16:10;
        } B;
    } VSRMCR;

    VUINT16 res7c;
    VUINT32 res8[27];

    /*System Inegration Timer Keys */
    union {
        VUINT32 R;
        VUINT32 B;
    } TBSCRK;

    union {
        VUINT32 R;
        VUINT32 B;
    } TBREF0K;

    union {
        VUINT32 R;
        VUINT32 B;
    } TBREF1K;

    union {
        VUINT32 R;
        VUINT32 B;
    } TBK;

    VUINT32 res9[4];

    union {
        VUINT32 R;
        VUINT32 B;
    } RTCSCK;

    union {
        VUINT32 R;
        VUINT32 B;
    } RTCK;

    union {
        VUINT32 R;
        VUINT32 B;
    } RTSECK;

    union {
        VUINT32 R;
        VUINT32 B;
    } RTCALK;

    VUINT32 res10[4];

    union {
        VUINT32 R;
        VUINT32 B;
    } PISCRK;

    union {
        VUINT32 R;
        VUINT32 B;
    } PITCK;

    VUINT32 res11[14];

    /*Clocks and Reset Keys */
    union {
        VUINT32 R;
        VUINT32 B;
    } SCCRK;

    union {
        VUINT32 R;
        VUINT32 B;
    } PLPRCRK;

    union {
        VUINT32 R;
        VUINT32 B;
    } RSRK;
};

#endif
#ifdef _MPC565_H_
/****************************************************************************/
/*                              MODULE : USIU - MPC565                      */
/****************************************************************************/
    struct USIU_tag {
        union {
            VUINT32 R;
            struct {
                VUINT32 EARB:1;
                VUINT32 EARP:3;
                  VUINT32:4;
                VUINT32 DSHW:1;
                VUINT32 DBGC:2;
                VUINT32 DBPC:1;
                VUINT32 ATWC:1;
                VUINT32 GPC:2;
                VUINT32 DLK:1;
                  VUINT32:1;
                VUINT32 SC:2;
                VUINT32 RCTX:1;
                VUINT32 MLRC:2;
                  VUINT32:2;
                VUINT32 MTSC:1;
                VUINT32 NOSHOW:1;
                VUINT32 EICEN:1;
                VUINT32 LPMASK_EN:1;
                  VUINT32:4;
            } B;
        } SIUMCR;
        union {
            VUINT32 R;
            struct {
                VUINT32 SWTC:16;
                VUINT32 BMT:8;
                VUINT32 BME:1;
                  VUINT32:3;
                VUINT32 SWF:1;
                VUINT32 SWE:1;
                VUINT32 SWRI:1;
                VUINT32 SWP:1;
            } B;
        } SYPCR;
        VUINT32 res0;
        VUINT16 res1;
        union {
            VUINT16 R;
            struct {
                VUINT16 SWSR:16;
            } B;
        } SWSR;
        union {
            VUINT32 R;
            struct {
                VUINT32 IRQ0:1;
                VUINT32 LVL0:1;
                VUINT32 IRQ1:1;
                VUINT32 LVL1:1;
                VUINT32 IRQ2:1;
                VUINT32 LVL2:1;
                VUINT32 IRQ3:1;
                VUINT32 LVL3:1;
                VUINT32 IRQ4:1;
                VUINT32 LVL4:1;
                VUINT32 IRQ5:1;
                VUINT32 LVL5:1;
                VUINT32 IRQ6:1;
                VUINT32 LVL6:1;
                VUINT32 IRQ7:1;
                VUINT32 LVL7:1;
                  VUINT32:16;
            } B;
        } SIPEND;
        union {
            VUINT32 R;
            struct {
                VUINT32 IRM0:1;
                VUINT32 LVM0:1;
                VUINT32 IRM1:1;
                VUINT32 LVM1:1;
                VUINT32 IRM2:1;
                VUINT32 LVM2:1;
                VUINT32 IRM3:1;
                VUINT32 LVM3:1;
                VUINT32 IRM4:1;
                VUINT32 LVM4:1;
                VUINT32 IRM5:1;
                VUINT32 LVM5:1;
                VUINT32 IRM6:1;
                VUINT32 LVM6:1;
                VUINT32 IRM7:1;
                VUINT32 LVM7:1;
                  VUINT32:16;
            } B;
        } SIMASK;
        union {
            VUINT32 R;
            struct {
                VUINT32 ED0:1;
                VUINT32 WM0:1;
                VUINT32 ED1:1;
                VUINT32 WM1:1;
                VUINT32 ED2:1;
                VUINT32 WM2:1;
                VUINT32 ED3:1;
                VUINT32 WM3:1;
                VUINT32 ED4:1;
                VUINT32 WM4:1;
                VUINT32 ED5:1;
                VUINT32 WM5:1;
                VUINT32 ED6:1;
                VUINT32 WM6:1;
                VUINT32 ED7:1;
                VUINT32 WM7:1;
                  VUINT32:16;
            } B;
        } SIEL;
        union {
            VUINT32 R;
            struct {
                VUINT32 INTERRUPT_CODE:8;
                  VUINT32:24;
            } B;
        } SIVEC;
        union {
            VUINT32 R;
            struct {
                VUINT32:18;
                VUINT32 IEXT:1;
                VUINT32 IBMT:1;
                  VUINT32:6;
                VUINT32 DEXT:1;
                VUINT32 DBM:1;
                  VUINT32:4;
            } B;
        } TESR;
        union {
            VUINT32 R;
            VUINT32 B;
        } SGPIODT1;
        union {
            VUINT32 R;
            struct {
                VUINT32 SGPIOC:8;
                VUINT32 SGPIOA:24;
            } B;
        } SGPIODT2;
        union {
            VUINT32 R;
            struct {
                VUINT32 SDDRC:8;
                  VUINT32:8;
                VUINT32 GDDR0:1;
                VUINT32 GDDR1:1;
                VUINT32 GDDR2:1;
                VUINT32 GDDR3:1;
                VUINT32 GDDR4:1;
                VUINT32 GDDR5:1;
                  VUINT32:2;
                VUINT32 SDDRD:8;
            } B;
        } SGPIOCR;
        union {
            VUINT32 R;
            struct {
                VUINT32:16;
                VUINT32 PRPM:1;
                VUINT32 SLVM:1;
                  VUINT32:1;
                VUINT32 SIZE:2;
                VUINT32 SUPU:1;
                VUINT32 INST:1;
                  VUINT32:2;
                VUINT32 RESV:1;
                VUINT32 CONT:1;
                  VUINT32:1;
                VUINT32 TRAC:1;
                VUINT32 SIZEN:1;
                  VUINT32:2;
            } B;
        } EMCR;
        VUINT32 res1aa;
        union {
            VUINT32 R;
            struct {
                VUINT32 PREDIS_EN:1;
                VUINT32:31;
            } B;
        } PDMCR2;
        union {
            VUINT32 R;
            struct {
                VUINT32 SLRC:4;
                  VUINT32:2;
                VUINT32 PRDS:1;
                VUINT32 SPRDS:1;
                VUINT32 FTPU_PU:1;
                VUINT32 GP_MASK:7;
                VUINT32 GSP_MASK:2;
                  VUINT32:14;
            } B;
        } PDMCR;
        /* New USIU registers added 04Oct99 */
        union {
            VUINT32 R;
            struct {
                VUINT32 IRQ0:1;
                VUINT32 LVL0:1;
                VUINT32 IMBIRQ0:1;
                VUINT32 IMBIRQ1:1;
                VUINT32 IMBIRQ2:1;
                VUINT32 IMBIRQ3:1;
                VUINT32 IRQ1:1;
                VUINT32 LVL1:1;
                VUINT32 IMBIRQ4:1;
                VUINT32 IMBIRQ5:1;
                VUINT32 IMBIRQ6:1;
                VUINT32 IMBIRQ7:1;
                VUINT32 IRQ2:1;
                VUINT32 LVL2:1;
                VUINT32 IMBIRQ8:1;
                VUINT32 IMBIRQ9:1;
                VUINT32 IMBIRQ10:1;
                VUINT32 IMBIRQ11:1;
                VUINT32 IRQ3:1;
                VUINT32 LVL3:1;
                VUINT32 IMBIRQ12:1;
                VUINT32 IMBIR13:1;
                VUINT32 IMBIR14:1;
                VUINT32 IMBIRQ15:1;
                VUINT32 IRQ4:1;
                VUINT32 LVL4:1;
                VUINT32 IMBIRQ16:1;
                VUINT32 IMBIRQ17:1;
                VUINT32 IMBIRQ18:1;
                VUINT32 IMBIRQ19:1;
                VUINT32 IRQ5:1;
                VUINT32 LVL5:1;
            } B;
        } SIPEND2;
        union {
            VUINT32 R;
            struct {
                VUINT32 IMBIRQ20:1;
                VUINT32 IMBIRQ21:1;
                VUINT32 IMBIRQ22:1;
                VUINT32 IMBIRQ23:1;
                VUINT32 IRQ6:1;
                VUINT32 LVL6:1;
                VUINT32 IMBIRQ24:1;
                VUINT32 IMBIRQ25:1;
                VUINT32 IMBIRQ26:1;
                VUINT32 IMBIRQ27:1;
                VUINT32 IRQ7:1;
                VUINT32 LVL7:1;
                VUINT32 IMBIRQ28:1;
                VUINT32 IMBIRQ29:1;
                VUINT32 IMBIRQ30:1;
                VUINT32 IMBIRQ31:1;
                  VUINT32:16;
            } B;
        } SIPEND3;
        union {
            VUINT32 R;
            struct {
                VUINT32 IRQ0:1;
                VUINT32 LVL0:1;
                VUINT32 IMBIRQ0:1;
                VUINT32 IMBIRQ1:1;
                VUINT32 IMBIRQ2:1;
                VUINT32 IMBIRQ3:1;
                VUINT32 IRQ1:1;
                VUINT32 LVL1:1;
                VUINT32 IMBIRQ4:1;
                VUINT32 IMBIRQ5:1;
                VUINT32 IMBIRQ6:1;
                VUINT32 IMBIRQ7:1;
                VUINT32 IRQ2:1;
                VUINT32 LVL2:1;
                VUINT32 IMBIRQ8:1;
                VUINT32 IMBIRQ9:1;
                VUINT32 IMBIRQ10:1;
                VUINT32 IMBIRQ11:1;
                VUINT32 IRQ3:1;
                VUINT32 LVL3:1;
                VUINT32 IMBIRQ12:1;
                VUINT32 IMBIRQ13:1;
                VUINT32 IMBIRQ14:1;
                VUINT32 IMBIRQ15:1;
                VUINT32 IRQ4:1;
                VUINT32 LVL4:1;
                VUINT32 IMBIRQ16:1;
                VUINT32 IMBIRQ17:1;
                VUINT32 IMBIRQ18:1;
                VUINT32 IMBIRQ19:1;
                VUINT32 IRQ5:1;
                VUINT32 LVL5:1;
            } B;
        } SIMASK2;
        union {
            VUINT32 R;
            struct {
                VUINT32 IMBIRQ20:1;
                VUINT32 IMBIRQ21:1;
                VUINT32 IMBIRQ22:1;
                VUINT32 IMBIRQ23:1;
                VUINT32 IRQ6:1;
                VUINT32 LVL6:1;
                VUINT32 IMBIRQ24:1;
                VUINT32 IMBIRQ25:1;
                VUINT32 IMBIRQ26:1;
                VUINT32 IMBIRQ27:1;
                VUINT32 IRQ7:1;
                VUINT32 LVL7:1;
                VUINT32 IMBIRQ28:1;
                VUINT32 IMBIRQ29:1;
                VUINT32 IMBIRQ30:1;
                VUINT32 IMBIRQ31:1;
                  VUINT32:16;
            } B;
        } SIMASK3;
        union {
            VUINT32 R;
            struct {
                VUINT32 IRQ0:1;
                VUINT32 LVL0:1;
                VUINT32 IMBIRQ0:1;
                VUINT32 IMBIRQ1:1;
                VUINT32 IMBIRQ2:1;
                VUINT32 IMBIRQ3:1;
                VUINT32 IRQ1:1;
                VUINT32 LVL1:1;
                VUINT32 IMBIRQ4:1;
                VUINT32 IMBIRQ5:1;
                VUINT32 IMBIRQ6:1;
                VUINT32 IMBIRQ7:1;
                VUINT32 IRQ2:1;
                VUINT32 LVL2:1;
                VUINT32 IMBIRQ8:1;
                VUINT32 IMBIRQ9:1;
                VUINT32 IMBIRQ10:1;
                VUINT32 IMBIRQ11:1;
                VUINT32 IRQ3:1;
                VUINT32 LVL3:1;
                VUINT32 IMBIRQ12:1;
                VUINT32 IMBIRQ13:1;
                VUINT32 IMBIRQ14:1;
                VUINT32 IMBIRQ15:1;
                VUINT32 IRQ4:1;
                VUINT32 LVL4:1;
                VUINT32 IMBIRQ16:1;
                VUINT32 IMBIRQ17:1;
                VUINT32 IMBIRQ18:1;
                VUINT32 IMBIRQ19:1;
                VUINT32 IRQ5:1;
                VUINT32 LVL5:1;
            } B;
        } SISR2;
        union {
            VUINT32 R;
            struct {
                VUINT32 IMBIRQ20:1;
                VUINT32 IMBIRQ21:1;
                VUINT32 IMBIRQ22:1;
                VUINT32 IMBIRQ23:1;
                VUINT32 IRQ6:1;
                VUINT32 LVL6:1;
                VUINT32 IMBIRQ24:1;
                VUINT32 IMBIRQ25:1;
                VUINT32 IMBIRQ26:1;
                VUINT32 IMBIRQ27:1;
                VUINT32 IRQ7:1;
                VUINT32 LVL7:1;
                VUINT32 IMBIRQ28:1;
                VUINT32 IMBIRQ29:1;
                VUINT32 IMBIRQ30:1;
                VUINT32 IMBIRQ31:1;
                  VUINT32:16;
            } B;
        } SISR3;
        VUINT32 res2[42];
        /*Memory Controller Registers */
        union {
            VUINT32 R;
            struct {
                VUINT32 BA:17;
                VUINT32 AT:3;
                VUINT32 PS:2;
                  VUINT32:1;
                VUINT32 WP:1;
                  VUINT32:2;
                VUINT32 WEBS:1;
                VUINT32 TBDIP:1;
                VUINT32 LBDIP:1;
                VUINT32 SETA:1;
                VUINT32 BI:1;
                VUINT32 V:1;
            } B;
        } BR0;
        union {
            VUINT32 R;
            struct {
                VUINT32 AM:17;
                VUINT32 ATM:3;
                VUINT32 CSNT:1;
                VUINT32 ACS:2;
                VUINT32 EHTR:1;
                VUINT32 SCY:4;
                VUINT32 BSCY:3;
                VUINT32 TRLX:1;
            } B;
        } OR0;
        union {
            VUINT32 R;
            struct {
                VUINT32 BA:17;
                VUINT32 AT:3;
                VUINT32 PS:2;
                  VUINT32:1;
                VUINT32 WP:1;
                  VUINT32:2;
                VUINT32 WEBS:1;
                VUINT32 TBDIP:1;
                VUINT32 LBDIP:1;
                VUINT32 SETA:1;
                VUINT32 BI:1;
                VUINT32 V:1;
            } B;
        } BR1;
        union {
            VUINT32 R;
            struct {
                VUINT32 AM:17;
                VUINT32 ATM:3;
                VUINT32 CSNT:1;
                VUINT32 ACS:2;
                VUINT32 EHTR:1;
                VUINT32 SCY:4;
                VUINT32 BSCY:3;
                VUINT32 TRLX:1;
            } B;
        } OR1;
        union {
            VUINT32 R;
            struct {
                VUINT32 BA:17;
                VUINT32 AT:3;
                VUINT32 PS:2;
                  VUINT32:1;
                VUINT32 WP:1;
                  VUINT32:2;
                VUINT32 WEBS:1;
                VUINT32 TBDIP:1;
                VUINT32 LBDIP:1;
                VUINT32 SETA:1;
                VUINT32 BI:1;
                VUINT32 V:1;
            } B;
        } BR2;
        union {
            VUINT32 R;
            struct {
                VUINT32 AM:17;
                VUINT32 ATM:3;
                VUINT32 CSNT:1;
                VUINT32 ACS:2;
                VUINT32 EHTR:1;
                VUINT32 SCY:4;
                VUINT32 BSCY:3;
                VUINT32 TRLX:1;
            } B;
        } OR2;
        union {
            VUINT32 R;
            struct {
                VUINT32 BA:17;
                VUINT32 AT:3;
                VUINT32 PS:2;
                  VUINT32:1;
                VUINT32 WP:1;
                  VUINT32:2;
                VUINT32 WEBS:1;
                VUINT32 TBDIP:1;
                VUINT32 LBDIP:1;
                VUINT32 SETA:1;
                VUINT32 BI:1;
                VUINT32 V:1;
            } B;
        } BR3;
        union {
            VUINT32 R;
            struct {
                VUINT32 AM:17;
                VUINT32 ATM:3;
                VUINT32 CSNT:1;
                VUINT32 ACS:2;
                VUINT32 EHTR:1;
                VUINT32 SCY:4;
                VUINT32 BSCY:3;
                VUINT32 TRLX:1;
            } B;
        } OR3;
        VUINT32 res3[8];
        union {
            VUINT32 R;
            struct {
                VUINT32:1;
                VUINT32 BA:6;
                  VUINT32:3;
                VUINT32 AT:3;
                  VUINT32:15;
                VUINT32 DMCS:3;
                VUINT32 DME:1;
            } B;
        } DMBR;
        union {
            VUINT32 R;
            struct {
                VUINT32:1;
                VUINT32 AM:6;
                  VUINT32:3;
                VUINT32 ATM:3;
                  VUINT32:19;
            } B;
        } DMOR;
        VUINT32 res4[12];
        union {
            VUINT16 R;
            struct {
                VUINT16:8;
                VUINT16 WPER0:1;
                VUINT16 WPER1:1;
                VUINT16 WPER2:1;
                VUINT16 WPER3:1;
                  VUINT16:4;
            } B;
        } MSTAT;
        VUINT16 res4a;
        VUINT32 res4b[33];
        /*System integration Timers */
        union {
            VUINT16 R;
            struct {
                VUINT16 TBIRQ:8;
                VUINT16 REFA:1;
                VUINT16 REFB:1;
                  VUINT16:2;
                VUINT16 REFAE:1;
                VUINT16 REFBE:1;
                VUINT16 TBF:1;
                VUINT16 TBE:1;
            } B;
        } TBSCR;
        VUINT16 res4c;
        union {
            VUINT32 R;
            VUINT32 B;
        } TBREF0;
        union {
            VUINT32 R;
            VUINT32 B;
        } TBREF1;
        VUINT32 res5[5];
        union {
            VUINT16 R;
            struct {
                VUINT16 RTCIRQ:8;
                VUINT16 SEC:1;
                VUINT16 ALR:1;
                  VUINT16:1;
                VUINT16 M:1;
                VUINT16 SIE:1;
                VUINT16 ALE:1;
                VUINT16 RTF:1;
                VUINT16 RTE:1;
            } B;
        } RTCSC;
        VUINT16 res5a;
        union {
            VUINT32 R;
            VUINT32 B;
        } RTC;
        union {
            VUINT32 R;
            VUINT32 B;
        } RTSEC;
        union {
            VUINT32 R;
            VUINT32 B;
        } RTCAL;
        VUINT32 res6[4];
        union {
            VUINT16 R;
            struct {
                VUINT16 PIRQ:8;
                VUINT16 PS:1;
                  VUINT16:4;
                VUINT16 PIE:1;
                VUINT16 PITF:1;
                VUINT16 PTE:1;
            } B;
        } PISCR;
        VUINT16 res6a;
        union {
            VUINT32 R;
            struct {
                VUINT32 PITC:16;
                  VUINT32:16;
            } B;
        } PITC;
        union {
            VUINT32 R;
            struct {
                VUINT32 PIT:16;
                  VUINT32:16;
            } B;
        } PITR;
        VUINT32 res7[13];
        /*Clocks and Reset */
        union {
            VUINT32 R;
            struct {
                VUINT32 DBCT:1;
                VUINT32 COM:2;
                VUINT32 DCSLR:1;
                VUINT32 MFPDL:1;
                VUINT32 LPML:1;
                VUINT32 TBS:1;
                VUINT32 RTDIV:1;
                VUINT32 STBUC:1;
                VUINT32 CQDS:1;
                VUINT32 PRQEN:1;
                VUINT32 RTSEL:1;
                VUINT32 BUCS:1;
                VUINT32 EBDF:2;
                VUINT32 LME:1;
                VUINT32 EECLK:2;
                VUINT32 ENGDIV:6;
                  VUINT32:1;
                VUINT32 DFNL:3;
                  VUINT32:1;
                VUINT32 DFNH:3;
            } B;
        } SCCR;
        union {
            VUINT32 R;
            struct {
                VUINT32 MF:12;
                VUINT32 MFPDL:1;
                VUINT32 LOCS:1;
                VUINT32 LOCSS:1;
                VUINT32 SPLS:1;
                VUINT32 SPLSS:1;
                VUINT32 TEXPS:1;
                VUINT32 LPML:1;
                VUINT32 TMIST:1;
                  VUINT32:1;
                VUINT32 CSRC:1;
                VUINT32 LPM:2;
                VUINT32 CSR:1;
                VUINT32 LOLRE:1;
                  VUINT32:1;
                VUINT32 DIVF:5;
            } B;
        } PLPRCR;
        union {
            VUINT16 R;
            struct {
                VUINT16 EHRS:1;
                VUINT16 ESRS:1;
                VUINT16 LLRS:1;
                VUINT16 SWRS:1;
                VUINT16 CSRS:1;
                VUINT16 DBHRS:1;
                VUINT16 DBSRS:1;
                VUINT16 JTRS:1;
                VUINT16 OCCS:1;
                VUINT16 ILBC:1;
                VUINT16 GPOR:1;
                VUINT16 GHRST:1;
                VUINT16 GSRST:1;
                  VUINT16:3;
            } B;
        } RSR;
        VUINT16 res7a;
        union {
            VUINT16 R;
            struct {
                VUINT16 COLIRQ:8;
                VUINT16 COLIS:1;
                  VUINT16:1;
                  VUINT16 COLIE:1;
                  VUINT16:5;
            } B;
        } COLIR;
        VUINT16 res7B;
        union {
            VUINT16 R;
            struct {
                VUINT16:1;
                VUINT16 LVSRS:4;
                VUINT16 VSRDE:1;
                VUINT16 LVDECRAM:1;
                  VUINT16:9;
            } B;
        } VSRMCR;
        VUINT16 res7c;
        VUINT32 res8[27];
        /*System Inegration Timer Keys */
        union {
            VUINT32 R;
            VUINT32 B;
        } TBSCRK;
        union {
            VUINT32 R;
            VUINT32 B;
        } TBREF0K;
        union {
            VUINT32 R;
            VUINT32 B;
        } TBREF1K;
        union {
            VUINT32 R;
            VUINT32 B;
        } TBK;
        VUINT32 res9[4];
        union {
            VUINT32 R;
            VUINT32 B;
        } RTCSCK;
        union {
            VUINT32 R;
            VUINT32 B;
        } RTCK;
        union {
            VUINT32 R;
            VUINT32 B;
        } RTSECK;
        union {
            VUINT32 R;
            VUINT32 B;
        } RTCALK;
        VUINT32 res10[4];
        union {
            VUINT32 R;
            VUINT32 B;
        } PISCRK;
        union {
            VUINT32 R;
            VUINT32 B;
        } PITCK;
        VUINT32 res11[14];
        /*Clocks and Reset Keys */
        union {
            VUINT32 R;
            VUINT32 B;
        } SCCRK;
        union {
            VUINT32 R;
            VUINT32 B;
        } PLPRCRK;
        union {
            VUINT32 R;
            VUINT32 B;
        } RSRK;
    };
#endif

#ifdef _USIU561_3
/****************************************************************************/
/*                              MODULE : USIU - 561/563                     */
/****************************************************************************/
struct USIU_tag {
    union {
        VUINT32 R;
        struct {
            VUINT32 EARB:1;
            VUINT32 EARP:3;
              VUINT32:4;
            VUINT32 DSHW:1;
            VUINT32 DBGC:2;
               VUINT32:1;
            VUINT32 ATWC:1;
            VUINT32 GPC:2;
            VUINT32 DLK:1;
              VUINT32:1;
            VUINT32 SC:2;
            VUINT32 RCTX:1;
            VUINT32 MLRC:2;
              VUINT32:2;
            VUINT32 MTSC:1;
            VUINT32 NOSHOW:1;
            VUINT32 EICEN:1;
            VUINT32 LPMASK_EN:1;
			VUINT32 BURST_EN:1;
              VUINT32:3;
        } B;
    } SIUMCR;
    union {
        VUINT32 R;
        struct {
            VUINT32 SWTC:16;
            VUINT32 BMT:8;
            VUINT32 BME:1;
              VUINT32:3;
            VUINT32 SWF:1;
            VUINT32 SWE:1;
            VUINT32 SWRI:1;
            VUINT32 SWP:1;
        } B;
    } SYPCR;
    VUINT32 res0;
    VUINT16 res1;
    union {
        VUINT16 R;
        struct {
            VUINT16 SWSR:16;
        } B;
    } SWSR;
    union {
        VUINT32 R;
        struct {
            VUINT32 IRQ0:1;
            VUINT32 LVL0:1;
            VUINT32 IRQ1:1;
            VUINT32 LVL1:1;
            VUINT32 IRQ2:1;
            VUINT32 LVL2:1;
            VUINT32 IRQ3:1;
            VUINT32 LVL3:1;
            VUINT32 IRQ4:1;
            VUINT32 LVL4:1;
            VUINT32 IRQ5:1;
            VUINT32 LVL5:1;
            VUINT32 IRQ6:1;
            VUINT32 LVL6:1;
            VUINT32 IRQ7:1;
            VUINT32 LVL7:1;
              VUINT32:16;
        } B;
    } SIPEND;
    union {
        VUINT32 R;
        struct {
            VUINT32 IRM0:1;
            VUINT32 LVM0:1;
            VUINT32 IRM1:1;
            VUINT32 LVM1:1;
            VUINT32 IRM2:1;
            VUINT32 LVM2:1;
            VUINT32 IRM3:1;
            VUINT32 LVM3:1;
            VUINT32 IRM4:1;
            VUINT32 LVM4:1;
            VUINT32 IRM5:1;
            VUINT32 LVM5:1;
            VUINT32 IRM6:1;
            VUINT32 LVM6:1;
            VUINT32 IRM7:1;
            VUINT32 LVM7:1;
              VUINT32:16;
        } B;
    } SIMASK;
    union {
        VUINT32 R;
        struct {
            VUINT32 ED0:1;
            VUINT32 WM0:1;
            VUINT32 ED1:1;
            VUINT32 WM1:1;
            VUINT32 ED2:1;
            VUINT32 WM2:1;
            VUINT32 ED3:1;
            VUINT32 WM3:1;
            VUINT32 ED4:1;
            VUINT32 WM4:1;
            VUINT32 ED5:1;
            VUINT32 WM5:1;
            VUINT32 ED6:1;
            VUINT32 WM6:1;
            VUINT32 ED7:1;
            VUINT32 WM7:1;
              VUINT32:16;
        } B;
    } SIEL;
    union {
        VUINT32 R;
        struct {
            VUINT32 INTERRUPT_CODE:8;
              VUINT32:24;
        } B;
    } SIVEC;
    union {
        VUINT32 R;
        struct {
            VUINT32:18;
            VUINT32 IEXT:1;
            VUINT32 IBMT:1;
              VUINT32:6;
            VUINT32 DEXT:1;
            VUINT32 DBM:1;
              VUINT32:4;
        } B;
    } TESR;
    union {
        VUINT32 R;
		struct {
			VUINT32 SGPIOD0_7:8;
			VUINT32 SGPIOD8_15:8;
			VUINT32 SGPIOD16_23:8;
			VUINT32 SGPIOD24_31:8;
        } B;
    } SGPIODT1;
    union {
        VUINT32 R;
        struct {
            VUINT32 SGPIOC:8;
            VUINT32 SGPIOA8_15:8;
			VUINT32 SGPIOA16_23:8;
			VUINT32 SGPIOA24_31:8;
        } B;
    } SGPIODT2;
    union {
        VUINT32 R;
        struct {
            VUINT32 SDDRC:8;
              VUINT32:8;
            VUINT32 GDDR0:1;
            VUINT32 GDDR1:1;
            VUINT32 GDDR2:1;
            VUINT32 GDDR3:1;
            VUINT32 GDDR4:1;
            VUINT32 GDDR5:1;
              VUINT32:2;
            VUINT32 SDDRD:8;
        } B;
    } SGPIOCR;
    union {
        VUINT32 R;
        struct {
            VUINT32:16;
            VUINT32 PRPM:1;
            VUINT32 SLVM:1;
              VUINT32:1;
            VUINT32 SIZE:2;
            VUINT32 SUPU:1;
            VUINT32 INST:1;
              VUINT32:2;
            VUINT32 RESV:1;
            VUINT32 CONT:1;
              VUINT32:1;
            VUINT32 TRAC:1;
            VUINT32 SIZEN:1;
              VUINT32:2;
        } B;
    } EMCR;
    VUINT32 res1aa;
 /*   VUINT32 res1ab; */   /* MDE 12/Spet/00 new regsieter PDMCR2 added */
 
    union {
        VUINT32 R;
        struct {
              VUINT32 :4;
            VUINT32 TCNC:2;
            VUINT32 MP17:1;
            VUINT32 MP18:1;
            VUINT32 MP19:1;
            VUINT32 :2;
            VUINT32 PPMAD:3;
            VUINT32 :2;
            VUINT32 PPMV:1;
            VUINT32 :3;
            VUINT32 MDO6:1;
            VUINT32 MP16:1;
            VUINT32 :3;
            VUINT32 PCSV:1;
            VUINT32 PCS4EN:1;
            VUINT32 PCS5EN:1;
            VUINT32 PCS6EN:1;
            VUINT32 PCS7EN:1;
            VUINT32 :2;
        } B;
    } PDMCR2;

    union {
        VUINT32 R;
        struct {
            VUINT32 SLRC:6;
           	VUINT32 PRDS:1;
            VUINT32 SPRDS:1;
            VUINT32 T2CLK_PU:1;
            VUINT32 PULL_DIS:6;
            VUINT32:17;
        } B;
    } PDMCR;
	                         /* New USIU registers added 04Oct99*/
   union {
        VUINT32 R;
        struct {
            VUINT32 IRQ0:1;
            VUINT32 LVL0:1;
            VUINT32 IMBIRQ0:1;
            VUINT32 IMBIRQ1:1;
            VUINT32 IMBIRQ2:1;
            VUINT32 IMBIRQ3:1;
            VUINT32 IRQ1:1;
            VUINT32 LVL1:1;
            VUINT32 IMBIRQ4:1;
            VUINT32 IMBIRQ5:1;
            VUINT32 IMBIRQ6:1;
            VUINT32 IMBIRQ7:1;
            VUINT32 IRQ2:1;
            VUINT32 LVL2:1;
            VUINT32 IMBIRQ8:1;
            VUINT32 IMBIRQ9:1;
			VUINT32 IMBIRQ10:1;
			VUINT32 IMBIRQ11:1;
			VUINT32 IRQ3:1;
			VUINT32 LVL3:1;
			VUINT32 IMBIRQ12:1;
			VUINT32 IMBIRQ13:1;
			VUINT32 IMBIRQ14:1;
			VUINT32 IMBIRQ15:1;
			VUINT32 IRQ4:1;
			VUINT32 LVL4:1;
			VUINT32 IMBIRQ16:1;
			VUINT32 IMBIRQ17:1;
			VUINT32 IMBIRQ18:1;
			VUINT32 IMBIRQ19:1;
			VUINT32 IRQ5:1;
            VUINT32 LVL5:1;
        } B;
    } SIPEND2;
   union {
        VUINT32 R;
        struct {
            VUINT32 IMBIRQ20:1;
            VUINT32 IMBIRQ21:1;
            VUINT32 IMBIRQ22:1;
            VUINT32 IMBIRQ23:1;
            VUINT32 IRQ6:1;
            VUINT32 LVL6:1;
            VUINT32 IMBIRQ24:1;
            VUINT32 IMBIRQ25:1;
            VUINT32 IMBIRQ26:1;
            VUINT32 IMBIRQ27:1;
            VUINT32 IRQ7:1;
            VUINT32 LVL7:1;
            VUINT32 IMBIRQ28:1;
            VUINT32 IMBIRQ29:1;
            VUINT32 IMBIRQ30:1;
            VUINT32 IMBIRQ31:1;
              VUINT32:16;
        } B;
    } SIPEND3;
	union {
        VUINT32 R;
        struct {
            VUINT32 IRQ0:1;
            VUINT32 LVL0:1;
            VUINT32 IMBIRQ0:1;
            VUINT32 IMBIRQ1:1;
            VUINT32 IMBIRQ2:1;
            VUINT32 IMBIRQ3:1;
            VUINT32 IRQ1:1;
            VUINT32 LVL1:1;
            VUINT32 IMBIRQ4:1;
            VUINT32 IMBIRQ5:1;
            VUINT32 IMBIRQ6:1;
            VUINT32 IMBIRQ7:1;
            VUINT32 IRQ2:1;
            VUINT32 LVL2:1;
            VUINT32 IMBIRQ8:1;
            VUINT32 IMBIRQ9:1;
			VUINT32 IMBIRQ10:1;
			VUINT32 IMBIRQ11:1;
			VUINT32 IRQ3:1;
			VUINT32 LVL3:1;
			VUINT32 IMBIRQ12:1;
			VUINT32 IMBIRQ13:1;
			VUINT32 IMBIRQ14:1;
			VUINT32 IMBIRQ15:1;
			VUINT32 IRQ4:1;
			VUINT32 LVL4:1;
			VUINT32 IMBIRQ16:1;
			VUINT32 IMBIRQ17:1;
			VUINT32 IMBIRQ18:1;
			VUINT32 IMBIRQ19:1;
			VUINT32 IRQ5:1;
            VUINT32 LVL5:1;
        } B;
    } SIMASK2;
   union {
        VUINT32 R;
        struct {
            VUINT32 IMBIRQ20:1;
            VUINT32 IMBIRQ21:1;
            VUINT32 IMBIRQ22:1;
            VUINT32 IMBIRQ23:1;
            VUINT32 IRQ6:1;
            VUINT32 LVL6:1;
            VUINT32 IMBIRQ24:1;
            VUINT32 IMBIRQ25:1;
            VUINT32 IMBIRQ26:1;
            VUINT32 IMBIRQ27:1;
            VUINT32 IRQ7:1;
            VUINT32 LVL7:1;
            VUINT32 IMBIRQ28:1;
            VUINT32 IMBIRQ29:1;
            VUINT32 IMBIRQ30:1;
            VUINT32 IMBIRQ31:1;
              VUINT32:16;
        } B;
    } SIMASK3;
	union {
        VUINT32 R;
        struct {
            VUINT32 IRQ0:1;
            VUINT32 LVL0:1;
            VUINT32 IMBIRQ0:1;
            VUINT32 IMBIRQ1:1;
            VUINT32 IMBIRQ2:1;
            VUINT32 IMBIRQ3:1;
            VUINT32 IRQ1:1;
            VUINT32 LVL1:1;
            VUINT32 IMBIRQ4:1;
            VUINT32 IMBIRQ5:1;
            VUINT32 IMBIRQ6:1;
            VUINT32 IMBIRQ7:1;
            VUINT32 IRQ2:1;
            VUINT32 LVL2:1;
            VUINT32 IMBIRQ8:1;
            VUINT32 IMBIRQ9:1;
			VUINT32 IMBIRQ10:1;
			VUINT32 IMBIRQ11:1;
			VUINT32 IRQ3:1;
			VUINT32 LVL3:1;
			VUINT32 IMBIRQ12:1;
			VUINT32 IMBIRQ13:1;
			VUINT32 IMBIRQ14:1;
			VUINT32 IMBIRQ15:1;
			VUINT32 IRQ4:1;
			VUINT32 LVL4:1;
			VUINT32 IMBIRQ16:1;
			VUINT32 IMBIRQ17:1;
			VUINT32 IMBIRQ18:1;
			VUINT32 IMBIRQ19:1;
			VUINT32 IRQ5:1;
            VUINT32 LVL5:1;
        } B;
    } SISR2;
   union {
        VUINT32 R;
        struct {
            VUINT32 IMBIRQ20:1;
            VUINT32 IMBIRQ21:1;
            VUINT32 IMBIRQ22:1;
            VUINT32 IMBIRQ23:1;
            VUINT32 IRQ6:1;
            VUINT32 LVL6:1;
            VUINT32 IMBIRQ24:1;
            VUINT32 IMBIRQ25:1;
            VUINT32 IMBIRQ26:1;
            VUINT32 IMBIRQ27:1;
            VUINT32 IRQ7:1;
            VUINT32 LVL7:1;
            VUINT32 IMBIRQ28:1;
            VUINT32 IMBIRQ29:1;
            VUINT32 IMBIRQ30:1;
            VUINT32 IMBIRQ31:1;
              VUINT32:16;
        } B;
    } SISR3;
    VUINT32 res2[42];
    /*Memory Controller Registers */
    union {
        VUINT32 R;
        struct {
            VUINT32 BA:17;
            VUINT32 AT:3;
            VUINT32 PS:2;
            VUINT32 SST:1;
            VUINT32 WP:1;
              VUINT32:1;
			VUINT32 BL:1;
            VUINT32 WEBS:1;
            VUINT32 TBDIP:1;
            VUINT32 LBDIP:1;
            VUINT32 SETA:1;
            VUINT32 BI:1;
            VUINT32 V:1;
        } B;
    } BR0;
    union {
        VUINT32 R;
        struct {
            VUINT32 AM:17;
            VUINT32 ATM:3;
            VUINT32 CSNT:1;
            VUINT32 ACS:2;
            VUINT32 EHTR:1;
            VUINT32 SCY:4;
            VUINT32 BSCY:3;
            VUINT32 TRLX:1;
        } B;
    } OR0;
    union {
        VUINT32 R;
        struct {
            VUINT32 BA:17;
            VUINT32 AT:3;
            VUINT32 PS:2;
            VUINT32 SST:1;
            VUINT32 WP:1;
              VUINT32:1;
			VUINT32 BL:1;
            VUINT32 WEBS:1;
            VUINT32 TBDIP:1;
            VUINT32 LBDIP:1;
            VUINT32 SETA:1;
            VUINT32 BI:1;
            VUINT32 V:1;
        } B;
    } BR1;
    union {
        VUINT32 R;
        struct {
            VUINT32 AM:17;
            VUINT32 ATM:3;
            VUINT32 CSNT:1;
            VUINT32 ACS:2;
            VUINT32 EHTR:1;
            VUINT32 SCY:4;
            VUINT32 BSCY:3;
            VUINT32 TRLX:1;
        } B;
    } OR1;
    union {
        VUINT32 R;
        struct {
            VUINT32 BA:17;
            VUINT32 AT:3;
            VUINT32 PS:2;
            VUINT32 SST:1;
            VUINT32 WP:1;
              VUINT32:1;
			VUINT32 BL:1;
            VUINT32 WEBS:1;
            VUINT32 TBDIP:1;
            VUINT32 LBDIP:1;
            VUINT32 SETA:1;
            VUINT32 BI:1;
            VUINT32 V:1;
        } B;
    } BR2;
    union {
        VUINT32 R;
        struct {
            VUINT32 AM:17;
            VUINT32 ATM:3;
            VUINT32 CSNT:1;
            VUINT32 ACS:2;
            VUINT32 EHTR:1;
            VUINT32 SCY:4;
            VUINT32 BSCY:3;
            VUINT32 TRLX:1;
        } B;
    } OR2;
    union {
        VUINT32 R;
        struct {
            VUINT32 BA:17;
            VUINT32 AT:3;
            VUINT32 PS:2;
            VUINT32 SST:1;
            VUINT32 WP:1;
              VUINT32:1;
			VUINT32 BL:1;
            VUINT32 WEBS:1;
            VUINT32 TBDIP:1;
            VUINT32 LBDIP:1;
            VUINT32 SETA:1;
            VUINT32 BI:1;
            VUINT32 V:1;
        } B;
    } BR3;
    union {
        VUINT32 R;
        struct {
            VUINT32 AM:17;
            VUINT32 ATM:3;
            VUINT32 CSNT:1;
            VUINT32 ACS:2;
            VUINT32 EHTR:1;
            VUINT32 SCY:4;
            VUINT32 BSCY:3;
            VUINT32 TRLX:1;
        } B;
    } OR3;
    VUINT32 res3[8];
    union {
        VUINT32 R;
        struct {
            VUINT32:1;
            VUINT32 BA:6;
              VUINT32:3;
            VUINT32 AT:3;
              VUINT32:15;
            VUINT32 DMCS:3;
            VUINT32 DME:1;
        } B;
    } DMBR;
    union {
        VUINT32 R;
        struct {
            VUINT32:1;
            VUINT32 AM:6;
              VUINT32:3;
            VUINT32 ATM:3;
              VUINT32:19;
        } B;
    } DMOR;
    VUINT32 res4[12];
    union {
        VUINT16 R;
        struct {
            VUINT16:8;
            VUINT16 WPER0:1;
            VUINT16 WPER1:1;
            VUINT16 WPER2:1;
            VUINT16 WPER3:1;
              VUINT16:4;
        } B;
    } MSTAT;
    VUINT16 res4a;
    VUINT32 res4b[33];
    /*System integration Timers */
    union {
        VUINT16 R;
        struct {
            VUINT16 TBIRQ:8;
            VUINT16 REFA:1;
            VUINT16 REFB:1;
              VUINT16:2;
            VUINT16 REFAE:1;
            VUINT16 REFBE:1;
            VUINT16 TBF:1;
            VUINT16 TBE:1;
        } B;
    } TBSCR;
    VUINT16 res4c;
    union {
        VUINT32 R;
        VUINT32 B;
    } TBREF0;
    union {
        VUINT32 R;
        VUINT32 B;
    } TBREF1;
    VUINT32 res5[5];
    union {
        VUINT16 R;
        struct {
            VUINT16 RTCIRQ:8;
            VUINT16 SEC:1;
            VUINT16 ALR:1;
              VUINT16:1;
            VUINT16 M:1;
            VUINT16 SIE:1;
            VUINT16 ALE:1;
            VUINT16 RTF:1;
            VUINT16 RTE:1;
        } B;
    } RTCSC;
    VUINT16 res5a;
    union {
        VUINT32 R;
        VUINT32 B;
    } RTC;
    union {
        VUINT32 R;
        VUINT32 B;
    } RTSEC;
    union {
        VUINT32 R;
        VUINT32 B;
    } RTCAL;
    VUINT32 res6[4];
    union {
        VUINT16 R;
        struct {
            VUINT16 PIRQ:8;
            VUINT16 PS:1;
              VUINT16:4;
            VUINT16 PIE:1;
            VUINT16 PITF:1;
            VUINT16 PTE:1;
        } B;
    } PISCR;
    VUINT16 res6a;
    union {
        VUINT32 R;
        struct {
            VUINT32 PITC:16;
              VUINT32:16;
        } B;
    } PITC;
    union {
        VUINT32 R;
        struct {
            VUINT32 PIT:16;
              VUINT32:16;
        } B;
    } PITR;
    VUINT32 res7[13];
    /*Clocks and Reset */
    union {
        VUINT32 R;
        struct {
            VUINT32 DBCT:1;
            VUINT32 COM:2;
            VUINT32 DCSLR:1;
            VUINT32 MFPDL:1;
            VUINT32 LPML:1;
            VUINT32 TBS:1;
            VUINT32 RTDIV:1;
            VUINT32 STBUC:1;
            VUINT32 CQDS:1;
            VUINT32 PRQEN:1;
            VUINT32 RTSEL:1;
            VUINT32 BUCS:1;
            VUINT32 EBDF:2;
            VUINT32 LME:1;
            VUINT32 EECLK:2;
            VUINT32 ENGDIV:6;
              VUINT32:1;
            VUINT32 DFNL:3;
              VUINT32:1;
            VUINT32 DFNH:3;
        } B;
    } SCCR;
    union {
        VUINT32 R;
        struct {
            VUINT32 MF:12;
               VUINT32:1;
            VUINT32 LOCS:1;
            VUINT32 LOCSS:1;
            VUINT32 SPLS:1;
            VUINT32 SPLSS:1;
            VUINT32 TEXPS:1;
			VUINT32 TEXP_INVP:1;
            VUINT32 TMIST:1;
              VUINT32:1;
            VUINT32 CSRC:1;
            VUINT32 LPM:2;
            VUINT32 CSR:1;
            VUINT32 LOLRE:1;
              VUINT32:1;
            VUINT32 DIVF:5;
        } B;
    } PLPRCR;
    union {
        VUINT16 R;
        struct {
            VUINT16 EHRS:1;
            VUINT16 ESRS:1;
            VUINT16 LLRS:1;
            VUINT16 SWRS:1;
            VUINT16 CSRS:1;
            VUINT16 DBHRS:1;
            VUINT16 DBSRS:1;
            VUINT16 JTRS:1;
            VUINT16 OCCS:1;
            VUINT16 ILBC:1;
            VUINT16 GPOR:1;
            VUINT16 GHRST:1;
            VUINT16 GSRST:1;
              VUINT16:3;
        } B;
    } RSR;
    VUINT16 res7a;
    union {
        VUINT16 R;
        struct {
            VUINT16 COLIRQ:8;
            VUINT16 COLIS:1;
			VUINT16 :1;
            VUINT16 COLIE:1;
              VUINT16:5;
        } B;
    } COLIR;
    VUINT16 res7B;
    union {
        VUINT16 R;
        struct {
            VUINT16:1;
            VUINT16 LVSRS:4;
            VUINT16 VSRDE:1;
            VUINT16 LVDECRAM:1;
              VUINT16:9;
        } B;
    } VSRMCR;
    VUINT16 res7c;
    VUINT32 res8[27];
    /*System Inegration Timer Keys */
    union {
        VUINT32 R;
        VUINT32 B;
    } TBSCRK;
    union {
        VUINT32 R;
        VUINT32 B;
    } TBREF0K;
    union {
        VUINT32 R;
        VUINT32 B;
    } TBREF1K;
    union {
        VUINT32 R;
        VUINT32 B;
    } TBK;
    VUINT32 res9[4];
    union {
        VUINT32 R;
        VUINT32 B;
    } RTCSCK;
    union {
        VUINT32 R;
        VUINT32 B;
    } RTCK;
    union {
        VUINT32 R;
        VUINT32 B;
    } RTSECK;
    union {
        VUINT32 R;
        VUINT32 B;
    } RTCALK;
    VUINT32 res10[4];
    union {
        VUINT32 R;
        VUINT32 B;
    } PISCRK;
    union {
        VUINT32 R;
        VUINT32 B;
    } PITCK;
    VUINT32 res11[14];
    /*Clocks and Reset Keys */
    union {
        VUINT32 R;
        VUINT32 B;
    } SCCRK;
    union {
        VUINT32 R;
        VUINT32 B;
    } PLPRCRK;
    union {
        VUINT32 R;
        VUINT32 B;
    } RSRK;
};
#endif

/****************************************************************************/
/*                              MODULE :UIMB                                */
/****************************************************************************/
struct UIMB_tag {
    union {
        VUINT32 R;
        struct {
            VUINT32 STOP:1;
            VUINT32 IRQMUX:2;
            VUINT32 HSPEED:1;
              VUINT32:28;
        } B;
    } UMCR;

    VUINT32 res0[3];

    union {
        VUINT32 R;
        VUINT32 B;
    } UTSTCREG;

    VUINT32 res1[3];

    union {
        VUINT32 R;
        struct {
            VUINT32 LVL0:1;
            VUINT32 LVL1:1;
            VUINT32 LVL2:1;
            VUINT32 LVL3:1;
            VUINT32 LVL4:1;
            VUINT32 LVL5:1;
            VUINT32 LVL6:1;
            VUINT32 LVL7:1;
            VUINT32 LVL8:1;
            VUINT32 LVL9:1;
            VUINT32 LVL10:1;
            VUINT32 LVL11:1;
            VUINT32 LVL12:1;
            VUINT32 LVL13:1;
            VUINT32 LVL14:1;
            VUINT32 LVL15:1;
            VUINT32 LVL16:1;
            VUINT32 LVL17:1;
            VUINT32 LVL18:1;
            VUINT32 LVL19:1;
            VUINT32 LVL20:1;
            VUINT32 LVL21:1;
            VUINT32 LVL22:1;
            VUINT32 LVL23:1;
            VUINT32 LVL24:1;
            VUINT32 LVL25:1;
            VUINT32 LVL26:1;
            VUINT32 LVL27:1;
            VUINT32 LVL28:1;
            VUINT32 LVL29:1;
            VUINT32 LVL30:1;
            VUINT32 LVL31:1;
        } B;
    } UIPEND;
};

#ifdef __MWERKS__
#pragma pack(pop)
#endif

#ifdef  __cplusplus
}
#endif

#endif

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

