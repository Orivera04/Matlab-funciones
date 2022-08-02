/**************************************************************************/
/*                                            COPYRIGHT (c) MOTOROLA 2002 */
/* FILE NAME: mpc5xx.c                            All Rights Reserved     */
/*                                                                        */
/* INCLUDE FILES: none                                                    */
/* VERSION: 1.5                                                           */
/*                                                                        */
/*========================================================================*/
/*                                                                        */
/* DESCRIPTION: This file sets up the internal registers of the MPC5xx to */
/*              generally useful values for the Motorola/ETAS EVB.        */
/*========================================================================*/
/*                                                                        */
/* COMPILER: Diab Data        VERSION: 4.3f                               */
/*                                                                        */
/* AUTHOR: John K Dunlop                  CREATION DATE:  22/Apr/98       */
/* LOCATION: East Kilbride, Scotland.                                     */
/*                                                                        */
/* UPDATE HISTORY                                                         */
/* REV      AUTHOR      DATE       DESCRIPTION OF CHANGE                  */
/* ---   -----------  ---------    ---------------------                  */
/* 1.0   J. Dunlop    22/Apr/98    Initial version of function.           */
/* 1.1   J. Loeliger  22/Jun/98    Changed to init. MPC555 core only.     */
/* 1.2   J. Loeliger   4/Nov/98    Changed SRAM to SRAM_A & SRAM_B        */
/* 1.3   R. Dees       9/Feb/2000  add isync after BBCMCR write           */
/* 1.4   J. Kobler    11/Jun/01    Added support for CodeWarrior Embedded */
/*                                   PowerPc 5.0.                         */
/* 1.5   J. Loeliger  16/Apr/02    Updated for new module files.          */
/*                                 *WARNING* this file MUST be included   */
/*                                 by another file that has already       */
/*                                 included mpc56x.h. This keeps this file*/
/*                                 generic for all mpc5xx parts.          */
/*                                 Added parameter for PLL freq.          */
/**************************************************************************/

void setup_mpc500 (int freq)
{
    USIU.SYPCR.R = 0xffffff03;  /* Disable watchdog timer.                 *
                                 * WARNING: this is a WRITE ONLY register. */

    USIU.SIUMCR.R = 0x00000000; /*Expanded mode, normal pin options */

    USIU.PDMCR.R = 0xf0000000;  /*Normal slew rate with no pull ups on Pads */

/* Initialise external memory interface */
/* Write to chip select option register first, becuase setting the V bit in  */
/* the base reigister enables the chip select.                               */

/* The Chip selects are not used because it is assumed they are setup by the */
/* debugger.                                                                 */

/* External TI Burst FLASH on Motorola/ETAS EVB */
/* USIU.OR0.R = 0xfff00054; /* 1MB/32 bit/5 wait states  */
/*  USIU.BR0.R = 0x00800101; /* Base address = 0x800000   */

/*  USIU.OR1.R = 0xffe00000; /* 2MB/32 bit/0 wait states  */
/*  USIU.BR1.R = 0x00000001; /* Base address = 0x00000000 */


/***** Initialise clocks with external 4MHz osc. *****/
/*  USIU.SCCRK.R = 0x55ccaa33; /*Unlock SCCR with special key */
/*  USIU.SCCR.R = 0x01300100; */
    USIU.PLPRCRK.R = 0x55ccaa33;  /*Unlock PLPRC with special key */
if (freq == 56){
    USIU.PLPRCR.R = 0x00d3d000; /* 14x PLL operation on normal power mode */
}else
{
    USIU.PLPRCR.R = 0x0093d000; /* 10x PLL operation on normal power mode */
}

    USIU.TBSCRK.R = 0x55ccaa33; /* Unlock timebase status reg */
    USIU.TBSCR.R = 0x0001;      /* Enable TB and decrementer */

    UIMB.UMCR.B.HSPEED = 0;     /* run IMB at full clock speed */

#ifndef __MWERKS__
    asm (" mfspr r3,158");      /* Put PowerPC core in non-serialized */
    asm (" ori r3,r3,0x0007 "); /* (normal) mode with no show cycles  */
    asm (" mtspr 158,r3");

    asm (" mfspr r3,560");      /* Enable burst buffer */
    asm (" ori r3,r3,0x2000 ");
    asm (" mtspr 560,r3");
    asm (" isync");             /* writes to the BBCMCR should be followed */
                                /* with an ISYNC to hold off any instructions */
                                /* until the register command completes. */

    asm (" mfmsr r3");          /* Enable floating point and make      */
    asm (" ori r3,r3,0x3000 "); /* machine check exception recoverable */
    asm (" mtmsr r3");
#endif

#ifdef __MWERKS__

asm{
     mfspr r3,158;      /* Put PowerPC core in non-serialized */
     ori r3,r3,0x0007 ; /* (normal) mode with no show cycles  */
     mtspr 158,r3;

     mfspr r3,560;      /* Enable burst buffer */
     ori r3,r3,0x2000 ;
     mtspr 560,r3;
     isync;             /* writes to the BBCMCR should be followed */
                                /* with an ISYNC to hold off any instructions */
                                /* until the register command completes. */

     mfmsr r3;          /* Enable floating point and make      */
     ori r3,r3,0x3000 ; /* machine check exception recoverable */
     mtmsr r3;
}
#endif

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

