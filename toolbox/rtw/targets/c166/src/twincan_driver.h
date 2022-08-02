/*
 * File: twincan_driver.c
 *
 * Abstract:
 *    Code for transmission and receipt of CAN messages via TwinCAN module
 *
 *
 * $Revision: 1.1.6.3 $
 * $Date: 2004/04/19 01:18:53 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 */

#ifndef _TWINCAN_DRIVER_H
#define _TWINCAN_DRIVER_H

#include "can_msg.h"

/* Defines */
#define NO_MSG_RECEIVED (0)
#define MSG_RECEIVED    (1)
#define MSG_LOST        (2)

#define SR_BOFF_MASK   (0x0080)
#define SR_EWRN_MASK   (0x0040)

/* Typedefs */

/* A circular buffer for holding received messages or messages to transmit */
typedef struct MESSAGE_CIRCULAR_BUFFER {
    CAN_FRAME * buffer;
    int_T readIdx;
    int_T writeIdx;
    int_T size;
    int_T full;
    int_T overflowCount;
    int_T canBufferInUse;
} MESSAGE_CIRCULAR_BUFFER;

/* Function prototypes*/
uint_T can_receive_msg(CAN_FRAME *msg, uint_T buffer);
void can_init_receive(uint_T bufferNo, CanFrameType type, uint32_T id, uint_T node);
void can_load_msg(const CAN_FRAME * msg, uint_T bufferNo, uint_T node);
void twincan_init(void);
void can_A_start(void);
void can_B_start(void);

/*------------------------------------------------------------
 * Function
 *
 *    init_transmit_fifo
 * 
 * Purpose
 *
 *    To initialize a CAN buffer on the TwinCAN module
 *    module for message transmission in conjuction with a FIFO queue
 *
 * Arguments
 *
 *    buffer       -  There are 32 buffers on each TwinCAN module
 *                   and a valid input for this argument
 *                   is  ( 0 <= module <= 31 )
 *
 *    p_msg_buf    - pointer to a circular buffer structure
 *
 *    p_can_frames - storage for buffer contents
 *
 *    queue_len    - the size of the circular buffer
 * 
 *    node         - the TwinCAN node
 */
void init_transmit_fifo(uint_T buffer, 
                      MESSAGE_CIRCULAR_BUFFER * p_msg_buf, 
                      CAN_FRAME * p_can_frames, uint_T queue_len,
                      uint_T node);

/*----------------------------------------------------------
 * Function
 *
 *   send_can_message_fifo
 *
 * Purpose
 *   
 *    Send CAN messages via an interrupt driven FIFO queue. Interrupts
 *    from the corresponding CAN node must be disabled while this function
 *    is called. It is the responsibility of the caller to ensure this is 
 *    done.
 *
 * Arguments
 *
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
unsigned int send_can_message_fifo(const CAN_FRAME * msg, 
                                MESSAGE_CIRCULAR_BUFFER * pbuf, 
                                uint_T bufferNo, uint_T node);



#endif
