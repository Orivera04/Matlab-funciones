/*
 * File: can_rx_queue.c
 *
 * Abstract:
 *    Code for receipt of CAN messages using an interrupt driven queue
 *
 *
 * $Revision: 1.1.6.1 $
 * $Date: 2003/04/23 06:27:34 $
 *
 * Copyright 2003 The MathWorks, Inc.
 */

#include <string.h>
#include "can_rx.h"
#include "isr.h"

/* Local function prototypes */
static void receiveToBufferCallback( PCAN_MODULE module, TOUCAN_IRQ_SOURCE source );

/*------------------------------------------------------------
 * Function
 *
 *    receiveToBufferCallback
 * 
 * Purpose
 *
 *    Interrupt service routine callback function move messages from the 
 *    hardware buffer into a FIFO queue.
 *
 * Arguments
 * 
 *    module      - The base address of the CAN module. 
 *
 *    source      - The interrupt source.
 */

static void receiveToBufferCallback( PCAN_MODULE module, TOUCAN_IRQ_SOURCE source ) {

    int bufIdx = IRQSOURCE_TO_BUFFER( source );
    MESSAGE_CIRCULAR_BUFFER * pbuf = 
        (MESSAGE_CIRCULAR_BUFFER *) module->callback_user_data[source];
    
    if ( ! (pbuf->full) ) {
        int writeIdxNext = pbuf->writeIdx + 1;
        writeIdxNext %= pbuf->size;

        readCanMessage( &(pbuf->buffer[pbuf->writeIdx]), module, bufIdx);
        
        if( writeIdxNext == pbuf->readIdx ) {
            /* Write has got back around to where read is up to. */
            pbuf->full = 1;
        } else {
            pbuf->writeIdx = writeIdxNext;
        }
    } else { 
        pbuf->overflowCount++;
    }
}

int receiveBufferedCanMessage(CAN_FRAME * msg, MESSAGE_CIRCULAR_BUFFER * pbuf) {
    if( pbuf->readIdx != pbuf->writeIdx ) {
        *msg = pbuf->buffer[pbuf->readIdx];
        pbuf->readIdx++;
        pbuf->readIdx %= pbuf->size;
        pbuf->full = 0;
        return MSG_RECEIVED;
    } else {
        return NO_MSG_RECEIVED;
    }
}

void initCanRxBuffered(PCAN_MODULE module , int buffer, 
                       CanFrameType type,int ident,
                       MESSAGE_CIRCULAR_BUFFER * p_msg_buf, 
                       CAN_FRAME * p_can_frames, int queue_len) {
    
    p_msg_buf->readIdx = 0;
    p_msg_buf->writeIdx = 0;
    p_msg_buf->size = queue_len;
    p_msg_buf->overflowCount = 0;
    p_msg_buf->full = 0;
    p_msg_buf->buffer = p_can_frames;

    /* Initialize the the callback to be executed when a message arrives */
    setCanModuleCallback( module, buffer, receiveToBufferCallback);

    /* Initialize the callback userdata */    
    module->callback_user_data[buffer]= (void *) p_msg_buf;

    /* Configure this buffer to generate interrupts */
    {
        const UINT16 iflag_mask = BITAT(buffer);
        (module->reg)->IMASK.R = (module->reg)->IMASK.R | iflag_mask;
    }
    
    /* Do standard initialization for the receive buffer */
    initCanRx(module, buffer, type, ident);
}
    
