/**************************************************************************/
/* FILE NAME: mpc555.h                        COPYRIGHT (c) MOTOROLA 2002 */
/* VERSION:  3.01                                 All Rights Reserved     */
/*                                                                        */
/* DESCRIPTION:                                                           */
/* This file includes the files that contain all of the register and bit  */
/* field definitions for the MPC555.                                      */
/*                                                                        */
/*========================================================================*/
/* AUTHOR: Jeff Loeliger                                                  */
/* COMPILER: Diab Data        VERSION: 4.2b                               */
/*                                                                        */
/* UPDATE HISTORY                                                         */
/* REV      AUTHOR      DATE       DESCRIPTION OF CHANGE                  */
/* ---   -----------  ---------    ---------------------                  */
/* 0.1   J. Loeliger  06/Apr/98    Initial version of file.               */
/* 0.2a  J. Dunlop    22/Apr/98    Changed TBSCR/RTCSR/PISCR to 16-bit    */
/* 0.2b  G. Placido   25/May/98    Added bit level description            */
/* 0.3   J. Loeliger  22/Jun/98    Changed to standard typedefs           */
/*                                 Changed bit identifer to B             */
/*                                 Added ifdefs around typedefs and       */
/*                                      register information.             */
/*                                 Added #pragma section for Diab CC      */
/*                                      currently it does not work with   */
/*                                      the SDS debugger so a #ifdef      */
/*                                      does not compile it.              */
/*                                 Removed unneeded 'dummy' label from    */
/*                                      bit field defines.                */
/*                                 Made all register definitions unions.  */
/* 0.4   K. Muto      26/Jun/98    Change QSMCM buffer to 32              */
/*                                 Correct register names as Appendix A   */
/*                                      of MPC555 User's Manual           */
/* 0.5   J. Loeliger   6/Jul/98    Made TPU PARM use unions.              */
/*                                 Put #ifdef DIAB_SECTIONS around diab   */
/*                                      section directives.               */
/*                                 Tested all register names.             */
/* 1.0   J. Loeliger   7/Jul/98    Initial Release                        */
/* 1.01  J. Loeliger  26/Aug/98    Added missing bit 5 in MIOS1 PIO       */
/*                                      registers.                        */
/* 1.02  J. Loeliger   9/Sep/98    Fixed incorrect definition of TPUMCR3  */
/*                                      register from old User's Manual.  */
/* 1.03  J. Loeliger  24/Sep/98    Added second SRAM module. Changed      */
/*                                      DDRQST to DDRQS in QSMCM to match */
/*                                      new user's manual.                */
/* 1.04  J. Loeliger   4/Nov/98    Changed TBSCR, RTCSC & PISCR to 16 bit */
/*                                      registers. This was an error in   */
/*                                      early versions on the 555 manual. */
/* 1.05  J. Loeliger  10/Nov/98    Changed ENDQP & NEWQP in SPCR2 and     */
/*                                      CPTQP in SPSR to be 5 bits.       */
/* 1.06  J. Loeliger   5/Jan/99    Changed PDMCR to 32 bits and added     */
/*                                      bit fields.                       */
/* 1.10                7/Jan/99    Broke  header file into modules.       */
/* 2.00  J. Loeliger  19/Jan/99    Updated all files and added three ways */
/*                                      to create and instance of the     */
/*                                      registers and added PACK.         */
/* 3.00  J. Loeliger  16/Apr/02    Updated to new generic module files.   */
/* 3.01  J. Loeliger  11/Jun/02    Changed to _MPC555_H_ define.          */
/**************************************************************************/
#ifndef _MPC555_H_
#define _MPC555_H_

/*Device specific defines*/
#define _CMF_FLASH
#define _MIOS1

#include "m_usiu.h"			/*also includes UIMB module*/
#include "m_flash.h"
#include "m_tpu3.h"			/*also includes DPTRAM module*/
#include "m_qadc64.h"
#include "m_qsmcm.h"
#include "m_mios.h"
#include "m_toucan.h"
#include "m_sram.h"

#define USIU   (*( struct USIU_tag *)   (INTERNAL_MEMORY_BASE + 0x2FC000))
#define CMF_A  (*( struct CMF_tag *)    (INTERNAL_MEMORY_BASE + 0x2FC800))
#define CMF_B  (*( struct CMF_tag *)    (INTERNAL_MEMORY_BASE + 0x2FC840))
#define TPU_A  (*( struct TPU3_tag *)   (INTERNAL_MEMORY_BASE + 0x304000))
#define TPU_B  (*( struct TPU3_tag *)   (INTERNAL_MEMORY_BASE + 0x304400))
#define QADC_A (*( struct QADC64_tag *) (INTERNAL_MEMORY_BASE + 0x304800))
#define QADC_B (*( struct QADC64_tag *) (INTERNAL_MEMORY_BASE + 0x304C00))
#define QSMCM  (*( struct QSMCM_tag *)  (INTERNAL_MEMORY_BASE + 0x305000))
#define MIOS1  (*( struct MIOS_tag *)   (INTERNAL_MEMORY_BASE + 0x306000))
#define CAN_A  (*( struct TOUCAN_tag *) (INTERNAL_MEMORY_BASE + 0x307080))
#define CAN_B  (*( struct TOUCAN_tag *) (INTERNAL_MEMORY_BASE + 0x307480))
#define UIMB   (*( struct UIMB_tag *)   (INTERNAL_MEMORY_BASE + 0x307F80))
#define SRAM_A (*( struct SRAM_tag *)   (INTERNAL_MEMORY_BASE + 0x380000))
#define SRAM_B (*( struct SRAM_tag *)   (INTERNAL_MEMORY_BASE + 0x380008))
#define DPTRAM (*( struct DPTRAM_tag *) (INTERNAL_MEMORY_BASE + 0x300000))

#endif /* ifndef _MPC555_H */

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

