/**************************************************************************/
/* FILE NAME: m_flash.h                       COPYRIGHT (c) MOTOROLA 2002 */
/* VERSION:  1.5                                  All Rights Reserved     */
/*                                                                        */
//* DESCRIPTION:                                                          */
/* This file defines all of the registers and bit fields on the FLASH     */
/* modules and declares an instance of the FLASH structure.               */
/*========================================================================*/
/* AUTHOR: Jeff Loeliger                                                  */
/* COMPILER: Diab Data        VERSION: 4.3f                               */
/*                                                                        */
/* UPDATE HISTORY                                                         */
/* REV      AUTHOR      DATE       DESCRIPTION OF CHANGE                  */
/* ---   -----------  ---------    ---------------------                  */
/* 0.1   J. Loeliger  06/Apr/98    Initial version of file.               */
/* 0.2                20/Dec/98    Broke header file into modules.        */
/* 1.0   J. Loeliger  12/Jan/99    Added three ways to create an instance */
/*                                   of the module and added PACK.        */
/* 1.1   J. Loeliger  22/Jun/99    Added ifdef to support C++             */
/*       K. Muto                   Added PAWS field to CMFTST             */
/* 1.2   J. Loeliger  07/Jul/99    Added new bits NVR and GDB to CMFTST.  */
/*                                   These were added to MPC555 rev K1.   */
/* 1.3   J. Kobler    11/Jun/01    Added support for CodeWarrior Embedded */
/*                                   PowerPc 5.0.                         */
/* 1.4   J. Loeliger  16/Apr/02    Created generic version for all MPC5xx.*/
/*                                   Merged flash and uc3f.               */
/* 1.5   J. Loeliger  30/Jan/03    Fixed pronlem with MWERKS pragma.      */
/**************************************************************************/

#ifndef _M_FLASH_H
#define _M_FLASH_H

#ifndef _M_COMMON_H
#include "m_common.h"
#endif /*  ifndef _M_COMMON_H  */

#ifdef  __cplusplus
extern "C" {
#endif

#ifdef __MWERKS__
#pragma pack(push,1)
#endif

#ifdef _CMF_FLASH
/****************************************************************************/
/*                              MODULE : CMF                                */
/****************************************************************************/
    struct CMF_tag {
        union {
            VUINT32 R;
            struct {
                VUINT32 LOCK:1;
                  VUINT32:2;
                VUINT32 FIC:1;
                VUINT32 SIE:1;
                VUINT32 ACCESS:1;
                VUINT32 CENSOR:2;
                VUINT32 SUPV:8;
                VUINT32 DATA:8;
                VUINT32 PROTECT:8;
            } B;
        } CMFMCR;

        union {
            VUINT32 R;
            struct {
                VUINT32:20;
                VUINT32 NVR:1;
                  VUINT32 PAWS:3;
                  VUINT32:2;
                VUINT32 GDB:1;
                  VUINT32:5;
            } B;
        } CMFTST;

        union {
            VUINT32 R;
            struct {
                VUINT32 HVS:1;
                  VUINT32:1;
                VUINT32 SCLKR:3;
                  VUINT32:1;
                VUINT32 CLKPE:2;
                  VUINT32:1;
                VUINT32 CLKPM:7;
                VUINT32 BLOCK:8;
                  VUINT32:1;
                VUINT32 CSC:1;
                VUINT32 EPEE:1;
                  VUINT32:2;
                VUINT32 PE:1;
                VUINT32 SES:1;
                VUINT32 EHV:1;
            } B;
        } CMFCTL;
    };

#else
#ifdef _UC3F_FLASH
/****************************************************************************/
/*                              MODULE : UC3F                               */
/****************************************************************************/
    struct UC3F_tag {           /*UC3F EEPROM Configuration Register */
        union {
            VUINT32 R;
            struct {
                VUINT32 STOP:1;
                VUINT32 LOCK:1;
                VUINT32 BPB:1;
                VUINT32 FIC:1;
                VUINT32 SIE:1;
                VUINT32 ACCESS:1;
                VUINT32 CENSOR:2;
                VUINT32 SUPV:8;
                VUINT32 DATA:8;
                VUINT32 PROTECT:8;
            } B;
        } UC3FMCR;

        union {                 /*UC3F EEPROM Extended Configuration Register */
            VUINT32 R;
            struct {
                VUINT32 SBEN:2;
                VUINT32 SBSUPV:2;
                VUINT32 SBDATA:2;
                VUINT32 SBPROTECT:2;
                VUINT32 WAIT:2;
                VUINT32 BIU:6;
                VUINT32 MEMSIZ:3;
                VUINT32 BLK:1;
                VUINT32 MAP:1;
                VUINT32 SBLKL:2;
                VUINT32 FLASHID:9;
            } B;
        } UC3FMCRE;

        union {                 /*UC3F EEPROM High Voltage Control Register */
            VUINT32 R;
            struct {
                VUINT32 HVS:1;
                VUINT32 PEGOOD:1;
                VUINT32 PEFI:1;
                VUINT32 EPEE:1;
                VUINT32 BOEM:1;
                  VUINT32:9;
                VUINT32 SBBLOCK:2;
                VUINT32 BLOCK:8;
                  VUINT32:1;
                VUINT32 CSC:1;
                  VUINT32:2;
                VUINT32 HSUS:1;
                VUINT32 PE:1;
                VUINT32 SES:1;
                VUINT32 EHV:1;
            } B;
        } UC3FCTL;
    };

#endif   /*UC3F_FLASH*/
#endif   /*CMF*/

#ifdef __MWERKS__
#pragma pack(pop)
#endif

#ifdef  __cplusplus
}
#endif

#endif
/* ifndef _M_FLASH_H  */
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

