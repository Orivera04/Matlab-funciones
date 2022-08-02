/* $Revision: 1.2 $ */
/* board.h - header for phyCORE-MPC555 board. */

/* 
 * 
 * Copyright (c) 2001 by 3SOFT GmbH
 * - all rights reserved -
 *
 * 3SOFT GmbH
 * Phone: +49 (0)9131 7701 0
 * Frauenweiherstr. 14, 91058 Erlangen
 * GERMANY
 *
*/

/* 
modification history
--------------------
15aug02, pmott porting from EVB555 to phyCORE-MPC555

02a,29june01,drothler changed address
01a,27jul99,vb  written
*/

#ifndef __BOARD_H
#define __BOARD_H

/*
 * The TMBCLK depends on: 
 * 	The input clock, wihch is SYSCLK, OSCM or EXTCLK.
 * 	The divider, 4 or 16.
 *
 *	DIV = 16 (when SCCR<TBS>==1, or PLPCRC<MF>=={0,1}
 *	DIV = 4 (when SCCR<TBS>==0 and PLPCRC<MF> >= 2  
 *
 *	The input clock is SYSCLK or OSCCLK, depending on SCCR<TBS>
 *
 *	OSCCLK=OSCM or EXTCLK, depending on MODCK<1:3>
 *
 *	In other, very similar, words
 * 	 TMBCLK=SYSCLK/16 for SCCR<TBS>==1
 * 	 TMBCLK=OSCCLK/16 for SCCR<TBS>==0, PLPRCR<MF> == 0 or 1
 * 	 TMBCLK=OSCCLK/4  for SCCR<TBS>==0, PLPRCR<MF> >= 2
 *	
 * This file presume:
 *	SCCR<TBS>==0
 *      PLPRCR<MF>==0
 *	OSCCLK=OSCM=20Mhz
 *
 * TMBCLK=OSCCLK/DIV=OSCM/16=20Mhz/16
 */
#define BOARD_TMBCLK_NHZ 0.00125
#define BOARD_TMBCLK_MHZ 1.25
#define BOARD_TMBCLK_HZ  1250000

/* 
 * The PIT timer depends on:
 * 	The input clock, OSCM or EXTCLK.
 * 	The divider, 4 or 256.
 *
 * A 20mhz OSCM crystal results in MF=0 on power on.
 * A  4mhz OSCM crystal results in MF=4 on power on.
 *
 * SCCR<RTDIV> poweron value = (!(MODCK<1:3>==0))
 * SCCR<RTSEL> poweron value = MODCK<1>
 * 
 * This file presumes:
 *	MODCLK<1:3>==001, producing
 *		SCCR<RTDIV>==1 => DIV=256
 *		SCCR<RTSEL>==0 => OSCCLK=OSCM
 * 	OSCM = 20mhz
 * PITRTCLK=OSCCLK/DIV=OSCM/256=20mhz/256
 */
#define BOARD_PITRTCLK_NHZ 0.000078125
#define BOARD_PITRTCLK_MHZ 0.078125
#define BOARD_PITRTCLK_HZ  78125

/* To provide LED macros, as described in ProOSEK documentation,
 * Change the following '#if 0' to '#if 1'
 */
#if 0
/* The phyCORE-MPC555 has 2 leds attached to MPIOSMDDR/MPIOSMDR<0:1>
 * Setup constants, to the extent possible, to create the LEDS_INIT 
 * and LEDS_SET macros. 
 */
#define MPIOSMDDR (* (volatile unsigned short *) 0x00306102)
#define MPIOSMDR  (* (volatile unsigned short *) 0x00306100)

#define SBC_LED_OFFSET                 0
#define SBC_MASK_IN                    0x0003
#define SBC_MASK_OUT                   0xFFFF ^ SBC_MASK_IN
#define SBC_MPIOSMDDR_LED_INIT         SBC_MASK_IN

#define LEDS_INIT() MPIOSMDDR |= SBC_MPIOSMDDR_LED_INIT

/* The following doesn't generate the proper code using gcc shipped with ProOSEK */
#define LEDS_SETx(x) MPIOSMDR = ((MPIOSMDR & SBC_MASK_OUT) | (SBC_MASK_IN & (x << SBC_LED_OFFSET)))
/* This fixes the misbehavior of the previous */
#define LEDS_SET(x) { \
 int sbc_mask_out = SBC_MASK_OUT; \
 MPIOSMDR = ((MPIOSMDR & sbc_mask_out) | (SBC_MASK_IN & (x << SBC_LED_OFFSET))); \
}
#endif /* #if 0 */
#endif
