/*
 * File: can_rx.c
 *
 * Abstract:
 *    Code for receipt of CAN messages
 *
 *
 * $Revision: 1.9.6.2 $
 * $Date: 2004/04/19 01:25:48 $
 *
 * Copyright 2001-2003 The MathWorks, Inc.
 */

#include <string.h>
#include "can_rx.h"
#include "isr.h"


/* There is no requirement for interrupts to be disabled whilst reading calling
   this function */
void readCanMessage(CAN_FRAME * msg, PCAN_MODULE module, int buffer) {
    struct TOUCAN_tag * reg;
    int idx;
    
    volatile unsigned char * p1;
    volatile unsigned char * p2;

    reg = module->reg;
    
   /* If the TouCAN buffer is busy then wait */
    while(reg->MBUFF[buffer].SCR.B.CODE & MPC555_TOUCAN_RX_CODE_BUSY);
    msg->LENGTH = reg->MBUFF[buffer].SCR.B.LENGTH;
    
    /* Protect against illegal CAN messages with length > 8 */
    if ( (msg->LENGTH) > 8) {
        msg->LENGTH = 8;
    }
    
    /* Extract the bits from the TouCAN buffer */
    if ( IS_XTD(reg->MBUFF[buffer].ID_HIGH.B) ) {
        /* Extended message */
        msg->ID = ID_HIGH_LOW_2_XTD_ID( reg->MBUFF[buffer].ID_HIGH.B, 
                          reg->MBUFF[buffer].ID_LOW.B );
    } else { 
        /* Standard message */
        msg->ID = ID_HIGH_2_STD_ID( reg->MBUFF[buffer].ID_HIGH.B );
    }
    
    /* Block copy the data buffer */
    p1 = msg->DATA;
    p2 = &(reg->MBUFF[buffer].DATA[0].R);
    for (idx=0; idx < msg->LENGTH; idx++){
        *(p1++)=*(p2++);
    }
    
      // Unlock the buffer
    reg->MBUFF[buffer].SCR.B.CODE = MPC555_TOUCAN_RX_CODE_ACTIVE_EMPTY;
    (volatile VUINT16) (reg->TIMER.R);
}

int receiveCanMessage(CAN_FRAME * msg, PCAN_MODULE module, int buffer){

   struct TOUCAN_tag * reg = module->reg;
   int msg_received = NO_MSG_RECEIVED;

   if(GET_TOUCAN_BUFFER_IFLAG(reg,buffer)){
       // Clear the IFLAG bit
       CLR_TOUCAN_BUFFER_IFLAG(reg,buffer);
       
       readCanMessage(msg, module, buffer);
       msg_received = MSG_RECEIVED; 
   }

   return msg_received;
}

void initCanRx(PCAN_MODULE module , int buffer, CanFrameType type,int ident){

    P_TOUCAN_MBUFF p_mbuff = (void *) &(module->reg->MBUFF[buffer]);
    struct TOUCAN_tag * reg;
    reg = module->reg;

    p_mbuff->SCR.B.CODE = MPC555_TOUCAN_RX_CODE_NOT_ACTIVE;
    switch (type) {
       case CAN_MESSAGE_STANDARD :
          p_mbuff->ID_HIGH.R = STD_ID_2_ID_HIGH(ident);    // IDE bit not set 
          p_mbuff->ID_LOW.R = 0;
          break;
       case CAN_MESSAGE_EXTENDED :
          p_mbuff->ID_HIGH.R = XTD_ID_2_ID_HIGH(ident);    // IDE bit set 
          p_mbuff->ID_LOW.R = XTD_ID_2_ID_LOW(ident);
          break;
    }
    p_mbuff->SCR.B.CODE = MPC555_TOUCAN_RX_CODE_ACTIVE_EMPTY;
    (volatile VUINT16) (reg->TIMER.R);
}
