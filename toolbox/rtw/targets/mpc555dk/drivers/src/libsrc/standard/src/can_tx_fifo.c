/*
 * File: can_tx_fifo.c
 *
 * Abstract:
 *    Code to send CAN messages using a FIFO queue and dedicated buffer
 *
 *
 * $Revision: 1.1.6.2 $
 * $Date: 2003/09/01 09:17:39 $
 *
 * Copyright 2003 The MathWorks, Inc.
 */

#include <string.h>
#include "can_tx_fifo.h"

/*------------------------------------------------------------
 * Function
 *
 *    transmitFifoCallback
 * 
 * Purpose
 *
 *    Interrupt service routine callback function move messages from the 
 *    FIFO queue into the dedicated hardware buffer from where they can
 *    be transmitted.
 *
 * Arguments
 * 
 *    module      - The base address of the CAN module. 
 *
 *    source      - The interrupt source.
 */
static void transmitFifoCallback( PCAN_MODULE module, TOUCAN_IRQ_SOURCE source);


static void transmitFifoCallback( PCAN_MODULE module, TOUCAN_IRQ_SOURCE source) {

    MESSAGE_CIRCULAR_BUFFER * pbuf = 
        (MESSAGE_CIRCULAR_BUFFER *) module->callback_user_data[source];
    unsigned int readIdx = pbuf->readIdx;
    
    int bufIdx = IRQSOURCE_TO_BUFFER( source );

    P_TOUCAN_MBUFF p_mbuff = (void *) &(module->reg->MBUFF[bufIdx]);
    
    if( ( readIdx != pbuf->writeIdx ) || (  pbuf->full == 1 ) ) {
        loadCanMessage( &(pbuf->buffer[readIdx]), p_mbuff );
        readIdx++;
        pbuf->readIdx = readIdx % pbuf->size;
        pbuf->full = 0;
    }

}

unsigned int sendCanMessageFifo(PCAN_MODULE module, const CAN_FRAME * msg, 
                                MESSAGE_CIRCULAR_BUFFER * pbuf, 
                                unsigned int buffer) {
    struct TOUCAN_tag * reg = module->reg;
    unsigned int result = 0;
    P_TOUCAN_MBUFF p_mbuff = (void *) &(module->reg->MBUFF[buffer]);


    EID();

    if ( (p_mbuff->SCR.B.CODE == MPC555_TOUCAN_TX_CODE_NOT_ACTIVE) 
         && 
         ( BITGET(reg->IFLAG.R,buffer) != 0x1U) ) {
        /* Buffer is empty and has no interrupt pending. Since no 
         * interrupt is pending, it is safe to use this buffer and there
         * is not risk that it will be overwritten during and interrupt
         * service routine. We can also infer that the queue is currently
         * empty.
         */
        loadCanMessage(msg, p_mbuff);
        result = 1;
    } else {
        /* Place message in the FIFO queue */
        if ( ! (pbuf->full) ) {
            int writeIdxNext = pbuf->writeIdx + 1;
            writeIdxNext %= pbuf->size;
            pbuf->buffer[pbuf->writeIdx] = *msg;
            pbuf->writeIdx = writeIdxNext;
            if( writeIdxNext == pbuf->readIdx ) {
                /* Write has got back around to where read is up to. */
                pbuf->full = 1;
            }
            result = 1;
        } else { 
            pbuf->overflowCount++;
        }
    }

    EIE();
}

void initTransmitFifo(PCAN_MODULE module , int buffer,
                      MESSAGE_CIRCULAR_BUFFER * p_msg_buf, 
                      CAN_FRAME * p_can_frames, int queue_len) {
    
    p_msg_buf->readIdx = 0;
    p_msg_buf->writeIdx = 0;
    p_msg_buf->size = queue_len;
    p_msg_buf->overflowCount = 0;
    p_msg_buf->full = 0;
    p_msg_buf->buffer = p_can_frames;

    /* Set up buffer ready to transmit but not active */
    module->reg->MBUFF[buffer].SCR.B.CODE = MPC555_TOUCAN_TX_CODE_NOT_ACTIVE;

    /* Initialize the the callback to be executed when a message has been transmitted */
    setCanModuleCallback( module, buffer, transmitFifoCallback);

    /* Initialize the callback userdata */    
    module->callback_user_data[buffer]= (void *) p_msg_buf;
    
    /* Configure this buffer to generate interrupts */
    {
        const UINT16 iflag_mask = BITAT(buffer);
        (module->reg)->IMASK.R = (module->reg)->IMASK.R | iflag_mask;
    }
}
    
