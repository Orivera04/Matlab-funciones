/*
 * File: qsmcm_sci.c
 *
 * Abstract:
 *    Code for initialization and use of QSMCM SCI modules 1 and 2
 *
 *
 * $Revision: 1.2.6.3 $
 * $Date: 2004/04/19 01:25:55 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 */

/*==========*
 * Includes *
 *==========*/

#include "tmwtypes.h"
#include "qsmcm_sci.h"
#include "mpc5xx.h"    

#ifndef MPC555_VARIANT
#define QSMCM QSMCM_A
#endif

/*==========*
 * Defines
 *==========*/
#define CLEAR_QTHF_QBHF_QOR (QSMCM.QSCI1SR.R &= (0xe3ffU))
#define CLEAR_QTHE_AND_QBHE (QSMCM.QSCI1SR.R &= (0xfcffU))
#define SCRQ_SIZE 16

#define SCI_PE_FE_FLAGS_MASK 0x0003U

/*===============*
 * Global variables
 *===============*/    
uint8_T mpc555_qsmcm_sci_flags;

/*===============*
 * Typedefs 
 *===============*/
typedef union QSCI1SR {
    VUINT16 R;
    struct {
        VUINT16:3;
        VUINT16 QOR:1;
        VUINT16 QTHF:1;
        VUINT16 QBHF:1;
        VUINT16 QTHE:1;
        VUINT16 QBHE:1;
        VUINT16 QRPNT:4;
        VUINT16 QPEND:4;
    } B;
} QSCI1SR_tag;

/*===============*
 * Local variables
 *===============*/    
static uint8_T sci1_rx_next;

void qsmcm_sci1_reset(void) {
    
    /* First ensure module is disabled */
    QSMCM.QSCI1CR.R = 0x0000;
    
    /* Initialize pointer to next byte available */
    sci1_rx_next = 0;
    
    /* Initialize error flags */
    mpc555_qsmcm_sci_flags &= ~( MPC555_QSMCM_SCI1_PE_FE );
    
    /* Make sure the received data register is flushed */
    if (QSMCM.SC1SR.B.RDRF == 1) {
	volatile uint16_T temp = QSMCM.SC1DR.R;
    }
    
    /* Use SCI 1 Queued mode of operation */
    QSMCM.QSCI1CR.B.QRE = 1;
    {
	CLEAR_QTHF_QBHF_QOR;
    }
}	

void qsmcm_sci1_disable(void) {
   /* Queued SCI1 Control register to reset value */
   QSMCM.QSCI1CR.R = 0x0;
   /* SCI1 Control register 0 to reset value + 
    * disable baud rate generator */
   QSMCM.SCC1R0.R = 0x0;
   /* SCI1 Control register 0 to reset value */
   QSMCM.SCC1R1.R = 0x0;
}

void qsmcm_sci2_disable(void) {
   /* SCI2 Control register 0 to reset value + 
    * disable baud rate generator */
   QSMCM.SCC2R0.R = 0x0;
   /* SCI2 Control register 0 to reset value */
   QSMCM.SCC2R1.R = 0x0;
}

void qsmcm_sci1_init(uint16_T sc1br, uint16_T scc1r1) {
    
    /* SCI1 control register 0 */
    QSMCM.SCC1R0.R = sc1br;

    /* SCI1 control register 1 */
    QSMCM.SCC1R1.R = scc1r1;
 
    qsmcm_sci1_reset();
}	

void qsmcm_sci2_init(uint16_T sc2br, uint16_T scc2r1) {
    
    /* SCI1 control register 0 */
    QSMCM.SCC2R0.R = sc2br;
    
    /* SCI1 control register 1 */
    QSMCM.SCC2R1.R = scc2r1;
}	

uint32_T general_send_string_sci1(uint8_T *string, uint32_T size) {
    
    uint32_T consumed = 0;
    
    if ( ( size > 0 ) && ( QSMCM.SC1SR.B.TC == 1 ) ) {
        uint32_T idx;
        consumed = (size <= SCRQ_SIZE) ? size : SCRQ_SIZE;
        QSMCM.QSCI1CR.B.QTSZ = consumed - 1;
        for (idx=0; idx<consumed; idx++) {
            QSMCM.SCTQ[idx].R = string[idx];
        }
        {
            CLEAR_QTHE_AND_QBHE;
        }
        QSMCM.QSCI1CR.B.QTE = 1;
    }
    return consumed;
}

uint32_T general_get_string_sci1(uint8_T *string, uint32_T size) {
    unsigned int idx;
    unsigned int bytes_transferred;
    unsigned int bytes_available;
    QSCI1SR_tag qsci1sr;

    /* Read status register */
    qsci1sr.R = QSMCM.QSCI1SR.R;

    /* Calculate number of bytes available */
    {
        unsigned int qrpnt = qsci1sr.B.QRPNT;
        if ( qrpnt > sci1_rx_next ) {
            bytes_available = qrpnt - sci1_rx_next;
        } else if ( qrpnt < sci1_rx_next ) {
            bytes_available = ( qrpnt + SCRQ_SIZE ) -  sci1_rx_next;
        } else if ( qsci1sr.B.QBHF == 1 ) {
            bytes_available = SCRQ_SIZE;
        } else {
            bytes_available = 0;
        }
    }

    /* Handle special case where complete buffer of 16 bytes received. If 16 bytes
     * were received then both QTHF and QBHF must be set. */
    if (bytes_available == 0) {
        if (qsci1sr.B.QTHF==1) {
            bytes_available = SCRQ_SIZE;
        }
    }
    
    bytes_transferred = (size < bytes_available ) ? size : bytes_available;
  
    for (idx = 0; idx < bytes_transferred; idx++) {
        uint8_T tmp = (sci1_rx_next+idx ) % SCRQ_SIZE;
        string[idx] = QSMCM.SCRQ[tmp].R;
    }
    
    if ( (QSMCM.SC1SR.R & SCI_PE_FE_FLAGS_MASK) != 0 ) {
        mpc555_qsmcm_sci_flags |= MPC555_QSMCM_SCI1_PE_FE;
    } else {
        mpc555_qsmcm_sci_flags &= ~MPC555_QSMCM_SCI1_PE_FE;
    }
  
    {
        uint8_T new = sci1_rx_next + bytes_transferred;

        /* If SCRQ[7] was transferred, clear QTHF */
        if ( ( new/(SCRQ_SIZE/2) ) != (sci1_rx_next/(SCRQ_SIZE/2) ) ) {
            qsci1sr.B.QTHF = 0;
        }
        
        /* If SCRQ[15] was transferred, clear QBHF */
        if (new >= SCRQ_SIZE) {
            qsci1sr.B.QBHF = 0;
        }

        /* Update pointer to next location in receive queue */
        sci1_rx_next = new % SCRQ_SIZE;
    }
    /* Write back value of status register to clear QTHF and/or QBHF 
     * as necessary. Note that these bits are only cleared if they were
     * already set when QSCI1SR was last read.
     */
    QSMCM.QSCI1SR.R = qsci1sr.R;

    return bytes_transferred;
}

uint32_T general_send_string_sci2(uint8_T *string, uint32_T size) {
    
    uint32_T consumed = 0;
  
    if (QSMCM.SC2SR.B.TDRE == 1) {
        if ( size >= 1 ) {
            consumed = 1;
            QSMCM.SC2DR.R = string[0];
        } else {
            consumed = 0;
        }
    }
    return consumed;
}

uint32_T general_get_string_sci2(uint8_T *string, uint32_T size) {
    uint8_T idx;
    uint32_T bytes_available = ( QSMCM.SC2SR.B.RDRF );
    uint32_T bytes_transferred = (size < bytes_available ) ? size : bytes_available;

    if ( QSMCM.SC2SR.R & SCI_PE_FE_FLAGS_MASK ) {
        mpc555_qsmcm_sci_flags |= ( MPC555_QSMCM_SCI2_PE_FE );
    } else {
        mpc555_qsmcm_sci_flags &= ( ~MPC555_QSMCM_SCI2_PE_FE );
    }
  
    if ( QSMCM.SC2SR.B.OR ) {
        mpc555_qsmcm_sci_flags |= ( MPC555_QSMCM_SCI2_OR );
    } else {
        mpc555_qsmcm_sci_flags &= ( ~MPC555_QSMCM_SCI2_OR );
    }

    if (bytes_transferred == 1) {
        string[0] = (uint8_T) QSMCM.SC2DR.R;
    } 
  
    return bytes_transferred;
}
