/*
 * File: can_tx_fifo.h
 *
 * Abstract:
 *    Code to transmission of CAN messages using FIFO queue and dedicated buffer
 *
 * $Revision: 1.1.6.3 $
 * $Date: 2004/04/19 01:25:35 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 */

#ifndef _CAN_TX_FIFO_H
#define _CAN_TX_FIFO_H

#include "can_common.h"
#include "can_msg.h"
#include "can_callback.h"
#include "mpc5xx.h"
#include "can_msg.h"
#include "can_driver.h"
#include "isr.h"

/*------------------------------------------------------------
 * Function
 *
 *    initTransmitFifo
 * 
 * Purpose
 *
 *    To initialize a CAN buffer on the MPC555 TouCAN
 *    module for message transmission in conjuction with a FIFO queue
 *
 * Arguments
 *
 *    module       - The base address of the CAN module. 
 *
 *    buffer       -  There are 15 buffers on each module
 *                   and the valid inputs for this argument
 *                   is  ( 0 <= module <= 14 )
 *
 *    p_msg_buf    - pointer to a circular buffer structure
 *
 *    p_can_frames - storage for buffer contents
 *
 *    queue_len    - the size of the circular buffer
 */
void initTransmitFifo(PCAN_MODULE module , int buffer, 
                      MESSAGE_CIRCULAR_BUFFER * p_msg_buf, 
                      CAN_FRAME * p_can_frames, int queue_len);



/*----------------------------------------------------------
 * Function
 *
 *    sendCanMessage
 *
 * Arguments
 *
 *    module      -  The CAN module to use
 *    msg         -  The message to transmit
 *    pbuf        -  Pointer to a circular buffer structure
 *    buffer      -  The CAN buffer number
 *                    
 * Returns
 *
 *    1                    -  The message has been queued
 *                            for transmission.
 *
 *    0                    -  The message queue has failed
 *                            to accept the message most 
 *                            likely because of a full queue.
 */
unsigned int sendCanMessageFifo(PCAN_MODULE module, const CAN_FRAME * msg, 
                                MESSAGE_CIRCULAR_BUFFER * pbuf, 
                                unsigned int buffer);


#endif
