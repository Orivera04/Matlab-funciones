/**************************************************************************/
/* FILE NAME: samp563.c                      COPYRIGHT (c) MOTOROLA 2001  */
/* VERSION: 1.1                                   All Rights Reserved     */
/*                                                                        */
/* DESCRIPTION: This is a demonstration programm for the MPC563 evaluation*/ 
/*				board. It uses the Queued Output Match (QOM) function of  */
/*				the Time Processing Unit (TPU). This programm configures  */
/*				the TPU channels to generate four PWM signals on the TPU  */
/*				channels[0:3].								              */
/* 	This program uses the fixed structure feature of the header files.    */
/* 																		  */
/*	The generated signals are:       									  */
/*																		  */
/*            ________                        ________                    */
/* CH0 :     \       \                       \       \                    */
/*       ¯¯¯¯        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ¯¯¯¯¯¯¯¯¯¯¯ ¯ ¯      */
/*                    ________                        ________            */
/* CH1 :             \       \                       \       \            */
/*       ¯¯¯¯¯¯¯¯¯¯¯¯        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ¯¯¯ ¯ ¯      */
/*                            ________                        ___ _ _     */
/* CH2 :                     \       \                       \            */
/*       ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯             */
/*                                    ________                            */
/* CH3 :                             \		 \                            */
/*       ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯ ¯ ¯      */
/*                                                                        */
/*																		  */
/*========================================================================*/
/* COMPILER: Diab Data        VERSION: 4.3f                               */
/* AUTHOR: Gregory Vimont                                                 */
/*                                                                        */
/* HISTORY                                                                */
/* REV      AUTHOR      DATE       DESCRIPTION OF CHANGE                  */
/* ---   -----------  ---------    ---------------------                  */
/* 1.0   G.Vimont     10/Jul/01    Initial version of function.           */
/* 1.1   J.Loeliger   13/Dec/02    Added while(1) to end the code.        */
/* 															              */
/**************************************************************************/

#include "mpc563.h"
#include "mpc500.c"

void main ()
{ 			
VUINT16 T=0xfffe;				    /*first 15 bits represent 1/4 of period*/
									/*last bit = 1 : rising edge*/
									/*last bit = 0 : falling edge*/

setup_mpc500(56);					/*Setup device and programm PLL to 56MHz*/	

TPU_A.TPUMCR.B.TCR1P = 3;			/*Input frequency divided by 8*/

TPU_A.PARM.B[0][6] = 0xffff;		/*This value will be used as a reference
									  time for the first match after 
									  initialization*/

/*Channel 0*/
TPU_A.CFSR3.B.CH0  = 0xE;			/*Assignes QOM function to the channel*/
TPU_A.PARM.B[0][0] = 0x0C0a;		/*Configure Ref_Addr & Last_Offset_Addr*/
TPU_A.PARM.B[0][1] = 0;                 
TPU_A.PARM.B[0][2] = T;
TPU_A.PARM.B[0][3] = T;
TPU_A.PARM.B[0][4] = T;
TPU_A.PARM.B[0][5] = T+1;
TPU_A.HSQR1.B.CH0  = 3;				/*Sets channel on continuous mode*/
TPU_A.HSRR1.B.CH0  = 3;				/*Start pin high*/
TPU_A.CPR1.B.CH0   = 1;				/*Enables the channel (low priority)*/

/*Channel 1*/
TPU_A.CFSR3.B.CH1  = 0xE;
TPU_A.PARM.B[1][0] = 0x0C1a;
TPU_A.PARM.B[1][1] = 0;                 
TPU_A.PARM.B[1][2] = T+1;
TPU_A.PARM.B[1][3] = T;
TPU_A.PARM.B[1][4] = T;
TPU_A.PARM.B[1][5] = T;
TPU_A.HSQR1.B.CH1  = 3;
TPU_A.HSRR1.B.CH1  = 3;
TPU_A.CPR1.B.CH1   = 1;

/*Channel 2*/
TPU_A.CFSR3.B.CH2  = 0xE;
TPU_A.PARM.B[2][0] = 0x0C2a;
TPU_A.PARM.B[2][1] = 0;                 
TPU_A.PARM.B[2][2] = T;
TPU_A.PARM.B[2][3] = T+1;
TPU_A.PARM.B[2][4] = T;
TPU_A.PARM.B[2][5] = T;
TPU_A.HSQR1.B.CH2  = 3;
TPU_A.HSRR1.B.CH2  = 3;
TPU_A.CPR1.B.CH2   = 1;

/*Channel 3*/
TPU_A.CFSR3.B.CH3  = 0xE;
TPU_A.PARM.B[3][0] = 0x0C3a;
TPU_A.PARM.B[3][1] = 0;                 
TPU_A.PARM.B[3][2] = T;
TPU_A.PARM.B[3][3] = T;
TPU_A.PARM.B[3][4] = T+1;
TPU_A.PARM.B[3][5] = T;
TPU_A.HSQR1.B.CH3  = 3;
TPU_A.HSRR1.B.CH3  = 3;
TPU_A.CPR1.B.CH3   = 1;

while (1);

}

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

