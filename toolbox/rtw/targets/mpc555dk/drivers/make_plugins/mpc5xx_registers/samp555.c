/**************************************************************************/
/* FILE NAME: samp555.c                       COPYRIGHT (c) MOTOROLA 2002 */
/* VERSION: 1.3                                   All Rights Reserved     */
/*                                                                        */
/* DESCRIPTION: This file shows how to use the standard set-up and header */
/* files for the MPC555. This program sets up the MPC555 EVB, generates a */
/* 10kHz PWM on the MIOS1 PWM19 channel and generates a software PWM on   */
/* QADC A port A7.                                                        */
/* This program uses the fixed structure feature of the header files.     */
/*========================================================================*/
/* COMPILER: Diab Data        VERSION: 4.3f                               */
/* AUTHOR: Jeff Loeliger                                                  */
/*                                                                        */
/* HISTORY                                                                */
/* REV      AUTHOR      DATE       DESCRIPTION OF CHANGE                  */
/* ---   -----------  ---------    ---------------------                  */
/* 1.0   J. Loeliger  19/Jan/99    Initial version of function.           */
/* 1.1   J. Loeliger  25/Jun/99    Updated register names.                */
/* 1.2   J. Kobler    11/Jun/01    Added support for CodeWarrior.         */
/* 1.3   J. Loeliger  19/Apr/02    Updated for new generic header files.  */
/**************************************************************************/

#include "mpc555.h"
#include "mpc500.c"


void main ()
{
setup_mpc500(40);					/*Setup device and programm PLL to 40MHz*/	

#ifdef __MWERKS__
    
    printf( NL);
    printf( "Welcome to CodeWarrior EPPC 5.0! %d " NL);

#ifdef ROM_VERSION
	printf("ROM Version %s %s" NL, __DATE__, __TIME__);
#else
	printf("RAM Version %s %s" NL, __DATE__, __TIME__);
#endif

	printf( NL);
#endif

/*************************************************************
 * Set up PWM19 on the MIOS1 module to output a 10KHz signal *
 *************************************************************/

#ifdef __MWERKS__
	printf( "PWM19 on the MIOS1 module is set up to output a 10KHz signal" NL);
#endif

    MIOS1.MCPSMSCR.B.PREN = 1;  /* enable MIOS counters */

	/* setup PWM19 */
    MIOS1.MPWMSM19PERR.R = 0xfa;   /* set period to 0xfa */

    MIOS1.MPWMSM19PULR.R = 0x3e;   /* set high time to 0x3e */

    MIOS1.MPWMSM19SCR.B.CP = 0xff; /* set prescaler to 1 */

    MIOS1.MPWMSM19SCR.B.EN = 1;    /* enable output on PWM19 */

/**************************************************
 * Generate a software PWM on QADC A port A7 pin. *
 **************************************************/

#ifdef __MWERKS__
	printf( "Generate a software PWM on QADC A port A7 pin" NL);
	printf( "entering endless loop ..." NL);
#endif

    QADC_A.DDRQA.B.DDQA7 = 1;   /* setup QADC A port A7 as output */

    while (1) {                 /* Toggle QADC A port A7 pin */
        QADC_A.PORTQA.B.PQA7 = 1;
        QADC_A.PORTQA.B.PQA7 = 0;
    }
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

