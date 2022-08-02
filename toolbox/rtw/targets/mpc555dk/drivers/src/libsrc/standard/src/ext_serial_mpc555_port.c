/*
 * File: ext_serial_mpc555_port.c
 *
 * Abstract: This implements the required interface for running Simulink external
 *    mode over a serial connection.
 *
 * $Revision: 1.1.6.1 $
 * $Date: 2003/07/31 18:08:28 $
 *
 * Copyright 2003 The MathWorks, Inc.
 */

#include <string.h>

#include "tmwtypes.h"

#include "ext_types.h"
#include "ext_share.h"
#include "ext_serial_port.h"
#include "ext_serial_pkt.h"
#include "mpc5xx.h"

#ifndef MPC555_VARIANT
#define QSMCM QSMCM_A
#endif

/*==========*
 * Defines
 *==========*/
#define CLEAR_QTHE_AND_QBHE (QSMCM.QSCI1SR.R &= (0xfcffU))
#define SCRQ_SIZE 16
#define SCI_PE_FE_FLAGS_MASK 0x0003U
#define MPC555_QSMCM_SCI1_PE_FE 0x0001


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
static uint8_T mpc555_qsmcm_sci_flags;

/***************** VISIBLE FUNCTIONS ******************************************/

/* Function: ExtSerialPortCreate ===============================================
 * Abstract:
 *  Creates an External Mode Serial Port object.  The External Mode Serial Port
 *  is an abstraction of the physical serial port providing a standard
 *  interface for external mode code.  A pointer to the created object is
 *  returned.
 *
 */
PUBLIC ExtSerialPort *ExtSerialPortCreate(void)
{
    static ExtSerialPort serialPort;
    ExtSerialPort *portDev = &serialPort;

    /* DELETE the following line */
    while(1);

    /* UNCOMMENT the following lines */
//    portDev->isLittleEndian = false;
//    portDev->fConnected = true;
//    portDev->errorNo    = 0;

    return portDev;

} /* end ExtSerialPortCreate */


/* Function: ExtSerialPortConnect ==============================================
 * Abstract:
 *  Performs a logical connection between the external mode code and the
 *  External Mode Serial Port object and a real connection between the External
 *  Mode Serial Port object and the physical serial port.
 *
 *  EXT_NO_ERROR is returned on success, EXT_ERROR on failure.
 */
PUBLIC boolean_T ExtSerialPortConnect(ExtSerialPort *portDev,
                                      uint16_T port,
                                      uint32_T baudRate)
{
    return EXT_NO_ERROR;

} /* end ExtSerialPortConnect */


/* Function: ExtSerialPortDisconnect ===========================================
 * Abstract:
 *  Performs a logical disconnection between the external mode code and the
 *  External Mode Serial Port object and a real disconnection between the
 *  External Mode Serial Port object and the physical serial port.
 *
 *  EXT_NO_ERROR is returned on success, EXT_ERROR on failure.
 */
PUBLIC boolean_T ExtSerialPortDisconnect(ExtSerialPort *portDev)
{
    return EXT_NO_ERROR;

} /* end ExtSerialPortDisconnect */


/* Function: ExtSerialPortSetData ==============================================
 * Abstract:
 *  Sets (sends) the specified number of bytes on the comm line.  The number of
 *  bytes sent is returned via the 'bytesWritten' parameter.
 *
 *  EXT_NO_ERROR is returned on success, EXT_ERROR on failure.
 */
PUBLIC boolean_T ExtSerialPortSetData(ExtSerialPort *portDev,
                                      char *data,
                                      uint32_T size,
                                      uint32_T *bytesWritten)
{
    if (!portDev->fConnected) return EXT_ERROR;

    *bytesWritten = 0;

    //temporary mod to make this function blocking
    while ( QSMCM.SC1SR.B.TC == 0 );
    
    if ( ( size > 0 ) && ( QSMCM.SC1SR.B.TC == 1 ) ) {
        uint32_T idx;
        *bytesWritten = (size <= SCRQ_SIZE) ? size : SCRQ_SIZE;
        QSMCM.QSCI1CR.B.QTSZ = *bytesWritten - 1;
        for (idx=0; idx<*bytesWritten; idx++) {
            QSMCM.SCTQ[idx].R = data[idx];
        }
        {
            CLEAR_QTHE_AND_QBHE;
        }
        QSMCM.QSCI1CR.B.QTE = 1;
    }

    return EXT_NO_ERROR;

} /* end ExtSerialPortSetData */


/* Function: ExtSerialPortDataPending ==========================================
 * Abstract:
 *  Returns, via the 'bytesPending' arg, the number of bytes pending on the
 *  comm line.
 *
 *  EXT_NO_ERROR is returned on success, EXT_ERROR on failure.
 */
PUBLIC boolean_T ExtSerialPortDataPending(ExtSerialPort *portDev,
                                          uint32_T *bytesPending)
{
    QSCI1SR_tag qsci1sr;

    if (!portDev->fConnected) return EXT_ERROR;

    *bytesPending = 0;

    /* Read status register */
    qsci1sr.R = QSMCM.QSCI1SR.R;

    { 
        uint32_T qrpnt = qsci1sr.B.QRPNT;
        if ( qrpnt > sci1_rx_next ) {
            *bytesPending = qrpnt - sci1_rx_next;
        } else if ( qrpnt < sci1_rx_next ) {
            *bytesPending = ( qrpnt + SCRQ_SIZE ) -  sci1_rx_next;
        } else if ( qsci1sr.B.QBHF == 1 ) {
            *bytesPending = SCRQ_SIZE;
        }
    }

    return EXT_NO_ERROR;

} /* end ExtSerialPortDataPending */


/* Function: ExtSerialPortGetRawChar ===========================================
 * Abstract:
 *  Attempts to get one byte from the comm line.  The number of bytes read is
 *  returned via the 'bytesRead' parameter.
 *
 *  EXT_NO_ERROR is returned on success, EXT_ERROR on failure.
 */
PUBLIC boolean_T ExtSerialPortGetRawChar(ExtSerialPort *portDev,
                                         char *c,
                                         uint32_T *bytesRead)

{
    const uint32_T size = 1;
    uint_T idx;
    uint_T bytes_available = 0;
    QSCI1SR_tag qsci1sr;

    if (!portDev->fConnected) return EXT_ERROR;

    /* Read status register */
    qsci1sr.R = QSMCM.QSCI1SR.R;

    /* Calculate number of bytes available */
    { 
        uint32_T qrpnt = qsci1sr.B.QRPNT;
        if ( qrpnt > sci1_rx_next ) {
            bytes_available = qrpnt - sci1_rx_next;
        } else if ( qrpnt < sci1_rx_next ) {
            bytes_available = ( qrpnt + SCRQ_SIZE ) -  sci1_rx_next;
        } else if ( qsci1sr.B.QBHF == 1 ) {
            bytes_available = SCRQ_SIZE;
        }
    }

    /* Handle special case where complete buffer of 16 bytes received. If 16 bytes
     * were received then both QTHF and QBHF must be set. */
    if (bytes_available == 0) {
        if (qsci1sr.B.QTHF==1) {
            bytes_available = SCRQ_SIZE;
        }
    }
    
    *bytesRead = (size < bytes_available ) ? size : bytes_available;
  
    for (idx = 0; idx < *bytesRead; idx++) {
        uint8_T tmp = (sci1_rx_next+idx ) % SCRQ_SIZE;
        c[idx] = QSMCM.SCRQ[tmp].R;
    }
    
    if ( (QSMCM.SC1SR.R & SCI_PE_FE_FLAGS_MASK) != 0 ) {
        mpc555_qsmcm_sci_flags |= MPC555_QSMCM_SCI1_PE_FE;
    } else {
        mpc555_qsmcm_sci_flags &= ~MPC555_QSMCM_SCI1_PE_FE;
    }
  
    {
        uint8_T new = sci1_rx_next + *bytesRead;

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

    return EXT_NO_ERROR;

} /* end ExtSerialPortGetRawChar */


/* [EOF] ext_serial_win32_port.c */
