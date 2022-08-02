/**************************************************************************/
/* FILE NAME: mpc533.h                        COPYRIGHT (c) MOTOROLA 2003 */
/* VERSION:  1.00                                All Rights Reserved      */
/*                                                                        */
/* DESCRIPTION:                                                           */
/* This file includes the header files that contain all of the register   */
/* and bit field definitions for the MPC533.                              */
/*                                                                        */
/*========================================================================*/
/* UPDATE HISTORY                                                         */
/* REV      AUTHOR      DATE       DESCRIPTION OF CHANGE                  */
/* ---   -----------  ---------    ---------------------                  */
/* 1.0   J. Loeliger  13/Feb/03    Initial version of file.               */
/**************************************************************************/
#ifndef _MPC533_H_
#define _MPC533_H_

/*Device specific defines*/
#define _UC3F_FLASH
#define _MIOS14
#define _USIU561_3
#define _CALRAM
#define _QADC64E
/* Out of RESET the QADC64E runs in legacy mode. If enhanced mode is needed*/
/* comment out the following line.*/
#define QADC64E_LEGACY

#include "m_usiu.h"			/*also includes UIMB module*/
#include "m_qadc64.h"
#include "m_qsmcm.h"
#include "m_mios.h"
#include "m_toucan.h"
#include "m_sram.h"
#include "m_ppm.h"
#include "m_flash.h"

#define USIU     (*( struct USIU_tag *)    (INTERNAL_MEMORY_BASE + 0x2FC000))
#define QADC_A   (*( struct QADC64_tag *) (INTERNAL_MEMORY_BASE + 0x304800))
#define QSMCM_A  (*( struct QSMCM_tag *)   (INTERNAL_MEMORY_BASE + 0x305000))
#define MIOS14   (*( struct MIOS_tag *)  (INTERNAL_MEMORY_BASE + 0x306000))
#define CAN_B    (*( struct TOUCAN_tag *)  (INTERNAL_MEMORY_BASE + 0x307480))
#define UIMB     (*( struct UIMB_tag *)    (INTERNAL_MEMORY_BASE + 0x307F80))
#define CALRAM_A (*( struct CALRAM_tag *)  (INTERNAL_MEMORY_BASE + 0x380000))
#define PPM      (*( struct PPM_tag *)     (INTERNAL_MEMORY_BASE + 0x305C00))
#define UC3F_A   (*( struct UC3F_tag *)    (INTERNAL_MEMORY_BASE + 0x2FC800))


#endif /* ifndef _MPC533_H */

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

