/**************************************************************************/
/* FILE NAME: mpc5xx_util.h                   COPYRIGHT (c) MOTOROLA 2002 */
/* VERSION: 1.1                                   All Rights Reserved     */
/*                                                                        */
/* DESCRIPTION: This file contains useful #defines and prototypes when    */
/* using MPC5xx based devices.                                            */
/*                                                                        */
/*========================================================================*/
/* HISTORY           ORIGINAL AUTHOR: Jeff Loeliger                       */
/* REV      AUTHOR      DATE       DESCRIPTION OF CHANGE                  */
/* ---   -----------  ---------    ---------------------                  */
/* 1.0   J. Loeliger  03/Aug/02    Initial version of function.           */
/* 1.1   J. Loeliger  30/Aug/02    Added clear and check interupt.        */
/**************************************************************************/
#ifndef _MPC5xx_UTIL_H
#define _MPC5xx_UTIL_H

#include "m_common.h"
#include "m_tpu3.h" 

void  tpu_func(struct TPU3_tag *tpu, UINT8 channel, UINT8 function_number);
UINT8 tpu_get_func(struct TPU3_tag *tpu, UINT8 channel);
void  tpu_hsr(struct TPU3_tag *tpu, UINT8 channel, UINT8 hsr);
UINT8 tpu_get_hsr(struct TPU3_tag *tpu, UINT8 channel);
void  tpu_hsq(struct TPU3_tag *tpu, UINT8 channel, UINT8 hsq);
UINT8 tpu_get_hsq(struct TPU3_tag *tpu, UINT8 channel);
void  tpu_enable(struct TPU3_tag *tpu, UINT8 channel, UINT8 priority);
void  tpu_disable(struct TPU3_tag *tpu, UINT8 channel);
void  tpu_interrupt_enable(struct TPU3_tag *tpu, UINT8 channel);
void  tpu_interrupt_disable(struct TPU3_tag *tpu, UINT8 channel);
void  tpu_clear_interrupt(struct TPU3_tag *tpu, UINT8 channel);
UINT8 tpu_check_interrupt(struct TPU3_tag *tpu, UINT8 channel);

#define tpu_ready(tpu, channel) while(tpu_get_hsr(tpu, channel)!=0)


/**********************************
 *     TPU3                       *
 *                                *
 **********************************/
/* Define data structure for one TPU channel. This is useful */
/* to allow indexing along the channels. */
struct TPU_param_tag {
    VUINT16 param0;
    VUINT16 param1;
    VUINT16 param2;
    VUINT16 param3;
    VUINT16 param4;
    VUINT16 param5;
    VUINT16 param6;
    VUINT16 param7;
};

struct TPU_param32_tag {
    VUINT32 param0;
    VUINT32 param2;
    VUINT32 param4;
    VUINT32 param6;
};

/* Define TPU Function numbers for standard TPU mask */
/* TPU BANK 0 */
#define TPU_FUNCTION_PTA 0xF
#define TPU_FUNCTION_QOM 0xE
#define TPU_FUNCTION_TSM 0xD
#define TPU_FUNCTION_FQM 0xC
#define TPU_FUNCTION_UART 0xB
#define TPU_FUNCTION_NITC 0xA
#define TPU_FUNCTION_COMM 0x9
#define TPU_FUNCTION_HALLD 0x8
#define TPU_FUNCTION_MCPWM 0x7
#define TPU_FUNCTION_FQD 0x6
#define TPU_FUNCTION_PPWA 0x5
#define TPU_FUNCTION_OC 0x4
#define TPU_FUNCTION_PWM 0x3
#define TPU_FUNCTION_DIO 0x2
#define TPU_FUNCTION_SPWM 0x1
#define TPU_FUNCTION_SIOP 0x0

/* TPU BANK 1 */
/* Only 2 functions are different in bank 1 */
#define TPU_FUNCTION_ID 0x5
#define TPU_FUNCTION_RWTPIN 0x1

/* TPU Scheduler Priorities */
#define TPU_PRIORITY_HIGH   3
#define TPU_PRIORITY_MIDDLE   2
#define TPU_PRIORITY_LOW   1
#define TPU_PRIORITY_DISABLE   0

/* TPU General */
#define TPU_CHANNEL_MASK 0xF
#define TPU_PRIORITY_MASK 0x3
#define TPU_HSR_MASK 0x3
#define TPU_HSQ_MASK 0x3

/**********************************
 *     MIOS                       *
 *                                *
 **********************************/

struct MIOS_pwm {
    VUINT16 perr;
    VUINT16 pulr;
    VUINT16 cntr;
    VUINT16 scr;
};

struct MIOS_pwm_coher {
    VUINT32 perr_pulr;
    VUINT16 cntr;
    VUINT16 scr;
};

struct MIOS_dasm {
    VUINT16 ar;
    VUINT16 br;
    VUINT16 scrd;
    VUINT16 scr;
};

/********************
 * Interrupt Levels *
 ********************/
#define INT_LEVEL_0 0x0000
#define INT_LEVEL_1 0x0100
#define INT_LEVEL_2 0x0200
#define INT_LEVEL_3 0x0300
#define INT_LEVEL_4 0x0400
#define INT_LEVEL_5 0x0500
#define INT_LEVEL_6 0x0600
#define INT_LEVEL_7 0x0700
#define INT_LEVEL_8 0x0040
#define INT_LEVEL_9 0x0140
#define INT_LEVEL_10 0x0240
#define INT_LEVEL_11 0x0340
#define INT_LEVEL_12 0x0440
#define INT_LEVEL_13 0x0540
#define INT_LEVEL_14 0x0640
#define INT_LEVEL_15 0x0740
#define INT_LEVEL_16 0x0080
#define INT_LEVEL_17 0x0180
#define INT_LEVEL_18 0x0280
#define INT_LEVEL_19 0x0380
#define INT_LEVEL_20 0x0480
#define INT_LEVEL_21 0x0580
#define INT_LEVEL_22 0x0680
#define INT_LEVEL_23 0x0780
#define INT_LEVEL_24 0x00c0
#define INT_LEVEL_25 0x01c0
#define INT_LEVEL_26 0x02c0
#define INT_LEVEL_27 0x03c0
#define INT_LEVEL_28 0x04c0
#define INT_LEVEL_29 0x05c0
#define INT_LEVEL_30 0x06c0
#define INT_LEVEL_31 0x07c0

#define SIU_INT_LEVEL0 0x40000000
#define SIU_INT_LEVEL1 0x10000000
#define SIU_INT_LEVEL2 0x04000000
#define SIU_INT_LEVEL3 0x01000000
#define SIU_INT_LEVEL4 0x00400000
#define SIU_INT_LEVEL5 0x00100000
#define SIU_INT_LEVEL6 0x00040000
#define SIU_INT_LEVEL7 0x00010000


#endif /*ifdef _MPC5xx_UTIL_H */

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

