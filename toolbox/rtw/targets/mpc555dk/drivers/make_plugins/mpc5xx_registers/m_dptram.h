/* $Revision: 1.1.6.1 $ */
/**************************************************************************/
/* FILE NAME: m_dptram.h                      COPYRIGHT (c) MOTOROLA 1999 */
/* VERSION:  1.3                                  All Rights Reserved     */
/*                                                                        */
//* DESCRIPTION:                                                          */
/* This file defines all of the registers and bit fields on the DPTRAM    */
/* module and declares an instance of the DPTRAM structure.               */
/*========================================================================*/
/* AUTHOR: Jeff Loeliger                                                  */
/* COMPILER: Diab Data        VERSION: 4.2b                               */
/*                                                                        */
/* UPDATE HISTORY                                                         */
/* REV      AUTHOR      DATE       DESCRIPTION OF CHANGE                  */
/* ---   -----------  ---------    ---------------------                  */
/* 0.1   J. Loeliger  06/Apr/98    Initial version of file.               */
/* 0.2                20/Dec/98    Broke header file into modules.        */
/* 1.0   J. Loeliger  12/Jan/99    Added three ways to create an instance */
/*                                   of the module and added PACK.        */
/* 1.1   J. Loeliger  21/Jan/99    Changed RMBAR bits to A[8:18].         */
/* 1.2   J. Loeliger  22/Jun/99    Added ifdef to support C++             */
/* 1.3   J. Kobler    11/Jun/01    Added support for CodeWarrior Embedded */
/*                                   PowerPc 5.0.                         */
/**************************************************************************/

#ifndef _MPC555_DPTRAM_H
#define _MPC555_DPTRAM_H

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

#ifdef __MWERKS__
#pragma pack(pop)
#endif

/*******************************************************************/
/* There are three way to create an instance of the DPTRAM module: */
/* -Use a fixed structure (Default)                                */
/* -Use the Diab compiler sections (if DIAB_SCETIONS is defined)   */
/* -Use a pointer (if HEADER_POINTERS is defined)                  */
/*******************************************************************/
#ifdef DIAB_SECTIONS            /* Diab Compiler Only */

#pragma section DPTRAM  address=0x300000  /* Map modules to fixed addresses. */
#pragma use_section DPTRAM DPTRAM
    EXT struct DPTRAM_tag DPTRAM;

#else
#ifdef HEADER_POINTERS

/* Create a global pointer. */
#ifdef Main_Program
    struct DPTRAM_tag *DPTRAM = (struct DPTRAM_tag *) (INTERNAL_MEMORY_BASE + 0x300000);
#else
    EXT struct DPTRAM_tag *DPTRAM;
#endif

#else

/* Use a fixed structure, this is the default */
#define DPTRAM (*( struct DPTRAM_tag *) (INTERNAL_MEMORY_BASE + 0x300000))

#endif                          /* HEADER_POINTERS */

#endif                          /* DIAB_SECTIONS */

#ifdef  __cplusplus
}

#endif
#endif
/* ifndef _MPC555_DPTRAM_H  */
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
