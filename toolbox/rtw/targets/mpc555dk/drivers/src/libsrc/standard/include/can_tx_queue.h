/*
 * File: can_tx_queue.h
 *
 * Abstract:
 *   Implements a transmit queue for shared transmit buffers.
 *   The queue is created and when a message is required
 *   to be sent the user calls sendCanMessage. sendCanMessage
 *   checks the assigned buffer to see if it is busy. If
 *   it is then the message is queued. When the buffer
 *   sucessfully transmits the message an interrupt
 *   occurs and the next pending message is read off
 *   the queue and placed into the buffer. This process
 *   repeats until the queue is empty.     
 *
 *   Note that a copy of the frame is taken. The original
 *   is not stored in the queue.
 *
 * 
 * $Revision: 1.1.6.2 $
 * $Date: 2004/04/19 01:25:36 $
 *
 * Copyright 2002-2003 The MathWorks, Inc. */
 
#ifndef _CAN_TX_QUEUE_
#define _CAN_TX_QUEUE_

#define CAN_TX_ERROR  LQ_ERROR

/*
 *  canModuleInitTxBuffer: initialize data structures for CAN message transmission
 *                         on the selected buffer
 *
 *  Parameters:
 *
 *    module       The module to be initialised
 * 
 *    num_buffers  The number of message buffers on the TouCAN module that will be 
 *                 allocated for transmit messages
 *
 *    txQueue      A pointer to memory to hold pending transmit messages. Note that
 *                 it is the responsibility of the calling program to make sure this
 *                 memory is allocated.
 * 
 *    txQueueLinks        Array of indices into the queue used for the linked 
 *                        list implementation
 *
 *    queueLength         Length of the queue
 *
 *  Return values:
 *
 *    none
 */
void canModuleInitTxBuffer(PCAN_MODULE module,const UINT8 num_buffers, CAN_FRAME * txQueue,
                           UINT8 * txQueueLinks, const UINT32 queueLength);

/*-------------------------------------------------------- */


/*----------------------------------------------------------
 * Function
 *
 *    sendCanMessage
 *
 * Arguments
 *
 *    module      -  The CAN module to use
 *    msg         -  The message to transmit
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
unsigned int sendCanMessage(PCAN_MODULE module, const CAN_FRAME * msg);

/*-------------------------------------------------------- */
#endif
