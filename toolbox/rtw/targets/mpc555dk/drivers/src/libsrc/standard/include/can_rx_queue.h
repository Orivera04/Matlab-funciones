/*
 * File: can_rx_queue.h
 *
 * Abstract:
 *    Code to handle receipt of CAN Messages in conjuction with a circular buffer
 *
 * $Revision: 1.1.6.1 $
 * $Date: 2003/04/23 06:27:25 $
 *
 * Copyright 2003 The MathWorks, Inc.
 */

#ifndef _CAN_RX_QUEUE_H
#define _CAN_RX_QUEUE_H

#include "can_rx.h"



/*------------------------------------------------------------
 * Function
 *
 *    initCanRxBuffer
 * 
 * Purpose
 *
 *    To initialize circular buffer to be used in conjuction with 
 *    with a TouCAN receive buffer.
 *
 * Arguments
 * 
 *    module      - The base address of the CAN module. 
 *
 *    buffer      -  There are 15 buffers on each module
 *                   and the valid inputs for this argument
 *                   is  ( 0 <= module <= 14 )
 *
 *    type        -  CAN_MESSAGE_STANDARD | CAN_MESSAGE_EXTENDED
 *
 *    ident       -  The message identifier that is wished to be
 *                   received.
 *
 * p_msg_buf   - pointer to a circular buffer structure
 *
 * p_can_frames - storage for buffer contents
 *
 * queue_len   - the size of the circular buffer
 */
void initCanRxBuffered(PCAN_MODULE module,int buffer,CanFrameType type,int ident,
                       MESSAGE_CIRCULAR_BUFFER * p_msg_buf, 
                       CAN_FRAME * p_can_frames, 
                       int queue_len);


/*------------------------------------------------------------
 * Function
 *
 *    receiveBufferedCanMessage
 *
 * Purpose
 *
 *    To retrieve a message from a queue associated with a buffer on one
 *    of the TouCAN modules.
 *
 * Arguments
 *
 *    msg         -  A pointer to a CAN_FRAME where we
 *                   can copy in the message information.
 *
 *    pbuf        -  A pointer to the circular buffer used to store received
 *                   messages for this hardware buffer.
 */

int receiveBufferedCanMessage(CAN_FRAME * msg, MESSAGE_CIRCULAR_BUFFER * pbuf);

#endif

