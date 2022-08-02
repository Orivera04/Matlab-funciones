/**************************************************************************/
/* FILE NAME: mpc563.h                        COPYRIGHT (c) MOTOROLA 2002 */
/* VERSION:  3.01                                All Rights Reserved      */
/*                                                                        */
/* DESCRIPTION:                                                           */
/* This file includes the header files that contain all of the register   */
/* and bit field definitions for the MPC563.                              */
/*                                                                        */
/*========================================================================*/
/* AUTHOR: Steven McQuade                                                 */
/* COMPILER: Diab Data        VERSION: 4.3f                               */
/*                                                                        */
/* UPDATE HISTORY                                                         */
/* REV      AUTHOR      DATE       DESCRIPTION OF CHANGE                  */
/* ---   -----------  ---------    ---------------------                  */
/* 0.1   S.McQuade     08/02/01    Initial version of file.               */
/* 3.0   J. Loeliger  16/Apr/02    Updated for new generic module files.  */
/* 3.01  J. Loeliger  11/Jun/02    Changed to _MPC561_H_ define.          */
/**************************************************************************/
#ifndef _MPC563_H_
#define _MPC563_H_

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
#include "m_tpu3.h"			/*also includes DPTRAM module*/
#include "m_qadc64.h"
#include "m_qsmcm.h"
#include "m_mios.h"
#include "m_toucan.h"
#include "m_sram.h"
#include "m_ppm.h"
#include "m_flash.h"

#define USIU     (*( struct USIU_tag *)    (INTERNAL_MEMORY_BASE + 0x2FC000))
#define TPU_A    (*( struct TPU3_tag *)    (INTERNAL_MEMORY_BASE + 0x304000))
#define TPU_B    (*( struct TPU3_tag *)    (INTERNAL_MEMORY_BASE + 0x304400))
#define QADC_A   (*( struct QADC64_tag *) (INTERNAL_MEMORY_BASE + 0x304800))
#define QADC_B   (*( struct QADC64_tag *) (INTERNAL_MEMORY_BASE + 0x304C00))
#define QSMCM_A  (*( struct QSMCM_tag *)   (INTERNAL_MEMORY_BASE + 0x305000))
#define MIOS14   (*( struct MIOS_tag *)  (INTERNAL_MEMORY_BASE + 0x306000))
#define CAN_A    (*( struct TOUCAN_tag *)  (INTERNAL_MEMORY_BASE + 0x307080))
#define CAN_B    (*( struct TOUCAN_tag *)  (INTERNAL_MEMORY_BASE + 0x307480))
#define CAN_C    (*( struct TOUCAN_tag *)  (INTERNAL_MEMORY_BASE + 0x307880))
#define UIMB     (*( struct UIMB_tag *)    (INTERNAL_MEMORY_BASE + 0x307F80))
#define CALRAM_A (*( struct CALRAM_tag *)  (INTERNAL_MEMORY_BASE + 0x380000))
#define DPTRAM8K (*( struct DPTRAM_tag *)  (INTERNAL_MEMORY_BASE + 0x300000))
#define PPM      (*( struct PPM_tag *)     (INTERNAL_MEMORY_BASE + 0x305C00))
#define UC3F_A   (*( struct UC3F_tag *)    (INTERNAL_MEMORY_BASE + 0x2FC800))


#endif /* ifndef _MPC563_H */

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

