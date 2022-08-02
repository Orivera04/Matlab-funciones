/*
 * File: can_rx.h
 *
 * Abstract:
 *    Code to handle receipt of CAN Messages
 *
 * $Revision: 1.9.6.3 $
 * $Date: 2004/04/19 01:25:34 $
 *
 * Copyright 2001-2003 The MathWorks, Inc.
 */

#ifndef _CAN_RX_H
#define _CAN_RX_H

#include "can_common.h"
#include "can_msg.h"
#include "mpc5xx.h"



/*------------------------------------------------------------
 * Function
 *
 *    receiveCanMessage
 *
 * Purpose
 *
 *    To retrieve a message from a buffer on the 
 *    one of the TouCAN modules on the 555
 *
 * Arguments
 *
 *    msg         -  A pointer to a CAN_FRAME where we
 *                   can copy in the message information.
 *
 *    module     -  Pointer to a TOUCAN module
 *
 *    buffer      -  There are 15 buffers on each module
 *                   and the valid inputs for this argument
 *                   is  ( 0 <= module <= 14 )
 */

// DEFINES                                            

#define NO_MSG_RECEIVED 0
#define MSG_RECEIVED    1

//  PROTOTYPE                                          

int receiveCanMessage(CAN_FRAME * msg,PCAN_MODULE module, int buffer);

/*-------------------------------------------------- */


/*------------------------------------------------------------
 * Function
 *
 *    initCanRx
 * 
 * Purpose
 *
 *    To initialize a CAN buffer on the MPC555 TouCAN
 *    module to behave as a receive buffer
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
 */
void initCanRx(PCAN_MODULE module,int buffer,CanFrameType type,int ident);

/*-------------------------------------------------- */

/*-------------------------------------------------- */

/*------------------------------------------------------------
 * Function
 *
 *    readCanMessage
 * 
 * Purpose
 *
 *    Used by e.g. receiveCanMessage to retrieve a message from the hardware 
 *    buffer.
 *
 * Arguments
 * 
 *    msg         -  A pointer to a CAN_FRAME where we
 *                   can copy in the message information.
 *
 *    module     -  Pointer to a TOUCAN module
 *
 *    buffer      -  There are 15 buffers on each module
 *                   and the valid inputs for this argument
 *                   is  ( 0 <= module <= 14 )
 * 
 */
void readCanMessage(CAN_FRAME * msg, PCAN_MODULE module, int buffer);



#endif

