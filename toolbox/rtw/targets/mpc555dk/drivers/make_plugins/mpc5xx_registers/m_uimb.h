/* $Revision: 1.1.6.1 $ */
/**************************************************************************/
/* FILE NAME: m_uimb.h                        COPYRIGHT (c) MOTOROLA 1999 */
/* VERSION:  1.2                                  All Rights Reserved     */
/*                                                                        */
//* DESCRIPTION:                                                          */
/* This file defines all of the registers and bit fields on the UIMB      */
/* module and declares an instance of the UIMB structure.                 */
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
/* 1.1   J. Loeliger  22/Jun/99    Added ifdef to support C++             */
/*       K. Muto                   Updated as MPC555UM(1/Mar/99). Changes */
/*                                   are IRQ->LVL                         */
/* 1.2   J. Kobler    11/Jun/01    Added support for CodeWarrior Embedded */
/*                                   PowerPc 5.0.                         */
/**************************************************************************/

#ifndef _MPC555_UIMB_H
#define _MPC555_UIMB_H

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

/******************************************************************/
/* There are three way to create an instance of the UIMB module:  */
/* -Use a fixed structure (Default)                          */
/* -Use the Diab compiler sections (if DIAB_SCETIONS is defined)  */
/* -Use a pointer (if HEADER_POINTERS is defined)                 */
/******************************************************************/
#ifdef DIAB_SECTIONS            /* Diab Compiler Only */

#pragma section UIMB   address=0x307F80  /* Map modules to fixed addresses. */
#pragma use_section UIMB UIMB
EXT struct UIMB_tag UIMB;

#else
#ifdef HEADER_POINTERS

/* Create a global pointer. */
#ifdef Main_Program
struct UIMB_tag *UIMB = (struct UIMB_tag *) (INTERNAL_MEMORY_BASE + 0x307F80);
#else
EXT struct UIMB_tag *UIMB;
#endif

#else

/* Use a fixed structure, this is the default */
#define UIMB (*( struct UIMB_tag *) (INTERNAL_MEMORY_BASE + 0x307F80))

#endif /* HEADER_POINTERS */

#endif /* DIAB_SECTIONS */

#ifdef  __cplusplus
}
#endif

#endif /* ifndef _MPC555_UIMB_H  */

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
