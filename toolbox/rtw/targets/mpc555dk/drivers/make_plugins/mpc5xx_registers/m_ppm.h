/**************************************************************************/
/* FILE NAME: M_ppm.h                      COPYRIGHT (c) MOTOROLA 2002    */
/* VERSION:  0.4                                  All Rights Reserved     */
/*                                                                        */
//* DESCRIPTION:                                                          */
/* This file defines all of the registers and bit fields on the PPM       */
/* modules and declares an instance of the PPM structure.                 */
/*========================================================================*/
/* AUTHOR: Steven McQuade                                                 */
/* COMPILER: Diab Data        VERSION: 4.3f                               */
/*                                                                        */
/* HISTORY                                                                */
/* REV      AUTHOR        DATE       DESCRIPTION OF CHANGE                */
/* ---   -----------    ---------    ---------------------                */
/* 0.1   S.McQuade    08/02/01    Initial version of file for MPC563.     */
/* 0.2   J. Loeliger  16/Apr/02    Created generic version for all MPC5xx.*/
/*                                 Added support for CodeWarrior Embedded */
/*                                   PowerPc 5.0.                         */
/* 0.3   G. Jackson   08/01/02    Fixed spacing for SCALE_TCLK_REG and    */
/*                                 added _REG to SHORT_CH_REG.            */
/* 0.4   J. Loeliger  30/Jan/03   Fixed MWERKS pragma problem.            */
/**************************************************************************/
#ifndef _M_PPM_H
#define _M_PPM_H

#ifndef _M_COMMON_H
#include "m_common.h"
#endif /*  ifndef _M_COMMON_H  */

#ifdef  __cplusplus
extern "C" {
#endif

#ifdef __MWERKS__
#pragma pack(push,1)
#endif

/****************************************************************************/
/*                              MODULE :PPM                                 */
/****************************************************************************/

 struct PPM_tag {
	union {
		   VUINT16 R;
		   struct {
		   		VUINT16	STOP:1;
		   		  VUINT16:7;
		   		VUINT16	SUPV:1;
		   		  VUINT16:7; 		   		  
		   } B;
	}MCR;

	union {
		VUINT16 R;
		VUINT16 B;
	} TCR;	
	
	
	union { 
	    VUINT16 R;
		struct {
			VUINT16 SAMP:3;
			VUINT16 OP_16_8:1;
			VUINT16 ENRX:1;
			VUINT16 ENTX:1;
			VUINT16 SPI:1;
			VUINT16 STR:1;
			VUINT16 CI:1;
			VUINT16 CP:1;
			VUINT16 CM:1;
			  VUINT16:5;
		   } B;
	 }PCR;

	union {
		VUINT16 R;
		struct {
			VUINT16 CH0:2;
			VUINT16 CH1:2;
			VUINT16 CH2:2;
			VUINT16 CH3:2;
			VUINT16 CH4:2;
			VUINT16 CH5:2;
			VUINT16 CH6:2;
			VUINT16 CH7:2;
		 } B;
	 }TX_CONFIG_1;

     union {
		VUINT16 R;
		struct {
			VUINT16 CH8:2;
			VUINT16 CH9:2;
			VUINT16 CH10:2;
			VUINT16 CH11:2;
			VUINT16 CH12:2;
			VUINT16 CH13:2;
			VUINT16 CH14:2;
			VUINT16 CH15:2;
		 } B;
	 }TX_CONFIG_2;

   VUINT16 res0;     /* packing between registers*/
   VUINT16 res1;	/* To ensure memory locations map properly*/


	 union {
		VUINT16 R;
		struct {
			VUINT16 CH0:2;
			VUINT16 CH1:2;
			VUINT16 CH2:2;
			VUINT16 CH3:2;
			VUINT16 CH4:2;
			VUINT16 CH5:2;
			VUINT16 CH6:2;
			VUINT16 CH7:2;
		 } B;
	 }RX_CONFIG_1;

     union {
		VUINT16 R;
		struct {
			VUINT16 CH8:2;
			VUINT16 CH9:2;
			VUINT16 CH10:2;
			VUINT16 CH11:2;
			VUINT16 CH12:2;
			VUINT16 CH13:2;
			VUINT16 CH14:2;
			VUINT16 CH15:2;
		 } B;
	 }RX_CONFIG_2;


	VUINT16 res2;     /* packing between registers*/
   	VUINT16 res3;  	 /* To ensure memory locations map properly*/


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
	 }RX_DATA;

   VUINT16 res4;

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
	 }RX_SHIFTER;

	VUINT16 res5;

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
	 }TX_DATA;

	VUINT16 res6;

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
	 }GPDO;

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
	 }GPDI;

     union {
		VUINT16 R;
		struct {
			VUINT16 SH_TCAN:3;
			VUINT16 SH_TPU:2;
			    VUINT16:1;
			VUINT16 SH_ET1:1;
			VUINT16 SH_ET2:1;
			VUINT16 SH_T2CLK:1;
				VUINT16:7;
		 } B;
	  } SHORT_REG;

	 union {
		VUINT16 R;
		struct {
				VUINT16:8;
			VUINT16 SHORT_CH7:1;
			VUINT16 SHORT_CH6:1;
			VUINT16 SHORT_CH5:1;
			VUINT16 SHORT_CH4:1;
			VUINT16 SHORT_CH3:1;
			VUINT16 SHORT_CH2:1;
			VUINT16 SHORT_CH1:1;
			VUINT16 SHORT_CH0:1;
		}B;
	 } SHORT_CH_REG;

/*	VUINT32 res7;      Removed 08/01/02 */

	union {
		VUINT16 R;
		struct {
			VUINT16:9;
			VUINT16 SCT6:1;
			VUINT16 SCT5:1;
			VUINT16 SCT4:1;
			VUINT16 SCT3:1;
			VUINT16 SCT2:1;
			VUINT16 SCT1:1;
			VUINT16 SCT0:1;
		}B;
	}SCALE_TCLK_REG;

};

#ifdef __MWERKS__
#pragma pack(pop)
#endif

#ifdef  __cplusplus
}
#endif

#endif
/* ifndef _M_PPM_H  */
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

