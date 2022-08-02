/* $Revision: 1.1.6.1 $ */
/**************************************************************************/
/* FILE NAME: m_qadc.h                        COPYRIGHT (c) MOTOROLA 1999 */
/* VERSION:  1.3                                  All Rights Reserved     */
/*                                                                        */
//* DESCRIPTION:                                                          */
/* This file defines all of the registers and bit fields on the QADC      */
/* module and declares an instance of the QADC structure.                 */
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
/* 1.1   J. Loeliger  22/Jan/99    Changed result and command buffers to  */
/*                                   arrays.                              */
/* 1.2   J. Loeliger  22/Jun/99    Added ifdef to support C++             */
/* 1.3   J. Kobler    11/Jun/01    Added support for CodeWarrior Embedded */
/*                                   PowerPc 5.0.                         */
/**************************************************************************/

#ifndef _MPC555_QADC_H
#define _MPC555_QADC_H

#ifndef _MPC555_COMMON_H
#include "M_COMMON.h"
#endif /*  ifndef _MPC555_COMMON_H  */

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

/******************************************************************/
/* There are three way to create an instance of the QADC module:  */
/* -Use a fixed structure (Default)                               */
/* -Use the Diab compiler sections (if DIAB_SCETIONS is defined)  */
/* -Use a pointer (if HEADER_POINTERS is defined)                 */
/******************************************************************/
#ifdef DIAB_SECTIONS            /* Diab Compiler Only */

#pragma section QADC_A address=0x304800  /* Map modules to fixed addresses. */
#pragma use_section QADC_A QADC_A
EXT struct QADC64_tag QADC_A;

#pragma section QADC_B address=0x304C00
#pragma use_section QADC_B QADC_B
EXT struct QADC64_tag QADC_B;

#else
#ifdef HEADER_POINTERS

/* Create a global pointer. */

#ifdef Main_Program
struct QADC64_tag *QADC_A = (struct QADC64_tag *) (INTERNAL_MEMORY_BASE + 0x304800);
struct QADC64_tag *QADC_B = (struct QADC64_tag *) (INTERNAL_MEMORY_BASE + 0x304C00);
#else
EXT struct QADC64_tag *QADC_A;
EXT struct QADC64_tag *QADC_B;
#endif

#else

/* Use a fixed structure, this is the default */
#define QADC_A (*( struct QADC64_tag *) (INTERNAL_MEMORY_BASE + 0x304800))
#define QADC_B (*( struct QADC64_tag *) (INTERNAL_MEMORY_BASE + 0x304C00))

#endif /* HEADER_POINTERS */

#endif /* DIAB_SECTIONS */

#ifdef  __cplusplus
}
#endif

#endif /* ifndef _MPC555_QADC_H  */

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
