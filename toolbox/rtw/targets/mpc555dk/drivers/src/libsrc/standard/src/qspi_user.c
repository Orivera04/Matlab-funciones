/*
 * File: qspi_user.c
 *
 * Abstract:
 *   Application dependent setup for the QSPI
 *
 * $Revision: 1.2.4.2 $
 * $Date: 2004/04/19 01:25:57 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 */

#include "mpc5xx.h"
#include "isr.h"
#include "qspi_manage.h"

#ifndef MPC555_VARIANT
#define QSMCM QSMCM_A
#define MIOS1 MIOS14
#endif

/*------------------------------------------------------------
 * define a function to perform QSPI setup that is common to all devices
 * using the QSPI and which can therefore be performed at
 * initialization time. Individual devices may require their own
 * settings e.g. for clock rate, phase, polarity etc. Individual 
 * devices should ensure that any such parameters are correctly
 * configured by including appropriate code in their StartFcn.
 *--------------------------------------------------------------*/


/* Chip select lines in the PORTQS register */
#define PORTQS_CHIP_SEL_MASK 0x78


void qspi_common_setup(MPC555_IRQ_LEVEL level) { 
  /* Control Register 0
   * Set Master mode, 8 bits per transfer */
  QSMCM.SPCR0.B.MSTR = 1;
  QSMCM.SPCR0.B.BITS = 8;

  /* Make sure interrupt enable on SPI finished or halted is set */
  QSMCM.SPCR2.B.SPIFIE = 1;
  QSMCM.SPCR3.B.HMIE = 1;
  
  /* Pin assignment register:
   * Set lines that are used for SPI functions */
  QSMCM.PQSPAR.R |= PORTQS_CHIP_SEL_MASK;
  QSMCM.PQSPAR.B.QPAMOSI = 1;
  QSMCM.PQSPAR.B.QPAMISO = 1;

  /* 	Port QS Data register
        Write 'Inactive state' values to decoder address lines */
  QSMCM.PORTQS.R &= ~PORTQS_CHIP_SEL_MASK; /* These are address select lines for decoder */
  /* Decoder gives active low O/Ps */	

  /* Data direction register         */
  /* Clock, Chip Sel & MOSI are O/P, MISO is I/P	*/  
  QSMCM.DDRQS.R |= PORTQS_CHIP_SEL_MASK;
  QSMCM.DDRQS.B.QDDSCK = 1;	        
  QSMCM.DDRQS.B.QDDMOSI = 1;	        
  QSMCM.DDRQS.B.QDDMISO = 0;		

  /* In this application the QSPI is used in conjunction with two
   * MPIOS pins. The MPIOS pins are configured as outputs and are used
   * to select 'SPI Highways' and to reset SPI devices 
   */
  MIOS1.MPIOSM32DR.B.D0 = 0;
  MIOS1.MPIOSM32DR.B.D1 = 0;
  MIOS1.MPIOSM32DR.B.D4 = 1;	/* Reset Active low */
  MIOS1.MPIOSM32DDR.B.DDR0 = 1;
  MIOS1.MPIOSM32DDR.B.DDR1 = 1;
  MIOS1.MPIOSM32DDR.B.DDR4 = 1;
        
  /* Interrupt level */                   
  QSMCM.QSPI_IL.B.ILQSPI = getIRLfromINT_IRQ_LEVEL(level) 
    + ( getILBSfromINT_IRQ_LEVEL(level) << 3 );
}












