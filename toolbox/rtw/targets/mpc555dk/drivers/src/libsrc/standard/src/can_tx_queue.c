/*
 * File: can_tx_queue.c
 *
 * Abstract: This file manages a queue that holds messages that are ready to be
 *    transmitted via one of the buffers allocated for use with the shared transmit queue.
 *
 * $Revision: 1.1.6.4 $
 * $Date: 2004/04/19 01:25:49 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 */

#include <stdlib.h>
#include "mpc5xx.h"
#include "can_callback.h"
#include "can_common.h"
#include "can_msg.h"
#include "can_driver.h"
#include "can_tx_queue.h"
#include "isr.h"

/* Define a values for queue control */
#define TAIL_SLOT         0xFF
#define FIFO_MODE         0x01
#define LIFO_MODE         0x00
#define INSERT_NORMAL     0x00
#define INSERT_AT_HEAD    0x01

/* Macros for handling mirrored copy of TouCAN buffer identifiers */
#define UNDEFINED_ID      0xFFFFFFFF
#define GET_AUGMENTED_ID(NORMAL_ID, XTD) ( (NORMAL_ID << 1) + XTD )
#define GET_NORMAL_ID(AUGMENTED_ID) ( AUGMENTED_ID >> 1 )
#define GET_XTD_FROM_AUGMENTED_ID(AUGMENTED_ID) ( AUGMENTED_ID & 0x1U )

/* Local function prototypes */
static void SBTQ_sendAckISR(PCAN_MODULE module, TOUCAN_IRQ_SOURCE source);
static CAN_FRAME * pqremove(PCAN_MODULE module);
static CAN_FRAME * pqinsert(PCAN_MODULE module, const UINT32 id_new, const CanFrameType type);
static void unloadCanMsg(P_TOUCAN_MBUFF p_mbuff_to_bump, 
                                     struct TOUCAN_tag * reg, 
                                     AUGMENTED_ID msg_to_bump_id_aug,
                                     unsigned int buffer_to_bump, 
                                     PCAN_MODULE module);


void canModuleInitTxBuffer(PCAN_MODULE module,const UINT8 num_buffers, CAN_FRAME * tx_queue,
                           UINT8 * queue_links, const UINT32 queue_length) {

    // Set the buffer for the transmit queue
    module->num_tx_buffers = num_buffers;
    
    // Initialize the queue
    module->tx_queue = tx_queue;
    module->queue_links = queue_links;
    module->queue_length = queue_length;
    module->queue_head = TAIL_SLOT; /* Queue empty to start with */
    module->queue_empty_head = 0; /* Initially all queue slots are empty */

    { 
        /* Initialize the linked list of empty buffers */
        unsigned int i;
        for (i=0; i < (queue_length - 1); i++) {
            queue_links[i] = i+1;
        }
        queue_links[queue_length-1] = TAIL_SLOT;
    }
    
    /* Set up each of the buffers used with the shared transmit queue */
    { 
        unsigned int i;
        for (i=0; i< num_buffers; i++) {
            /* Set the buffers up ready to transmit but not active */ 
            module->reg->MBUFF[i].SCR.B.CODE = MPC555_TOUCAN_TX_CODE_NOT_ACTIVE;

            /* Assign the callback that will handle all transmit acknowledges */
            setCanModuleCallback(module,BUFFER_TO_IRQ_SOURCE(i),SBTQ_sendAckISR);
    
            /* Set the buffer able to create interrupts after a transmit */
            {
                const UINT16 iflag_mask = BITAT(i);
                (module->reg)->IMASK.R = (module->reg)->IMASK.R | iflag_mask;
            }

            /* Initialize the array of mirrored buffer identifiers */
            module->tx_buffer_id_mirror[i].R = UNDEFINED_ID;
        }
    }
}

/* Send a CAN Message */
unsigned int sendCanMessage( PCAN_MODULE module, const CAN_FRAME * msg ) {
    struct TOUCAN_tag * reg = module->reg;
    unsigned int num_buffers = module->num_tx_buffers;
    unsigned int msg_handled = 0;
#define UNDEFINED_BUFFER 0xFFFFFFFF
    unsigned int empty_buffer_no = UNDEFINED_BUFFER;
    unsigned int buffer_to_bump = UNDEFINED_BUFFER;
    AUGMENTED_ID * id_mirror = module->tx_buffer_id_mirror;
    UINT32 new_id = msg->ID;
    unsigned int new_xtd = ( msg->type == CAN_MESSAGE_EXTENDED ) ? 1 : 0;
    AUGMENTED_ID new_aug_id; 

    new_aug_id.B.id = new_id;
    new_aug_id.B.xtd = new_xtd;

    EID();

    /* Search the available buffers on the CAN module */
    {
        unsigned int i;
        for (i = 0; i<num_buffers; i++) {
            AUGMENTED_ID mirrored_aug_id;
            mirrored_aug_id.R = id_mirror[i].R;
            
            /* Check whether buffer has same identifier as new message */
            if ( new_aug_id.R == mirrored_aug_id.R ) {
                /* Overwrite buffer with the new message */
                P_TOUCAN_MBUFF p_mbuff = (void *) &(module->reg->MBUFF[i]);
                loadCanMessage( msg, p_mbuff );
                msg_handled = 1;
                break;
            } 
            
            /* Check whether buffer is empty or if it should be bumped by the
               new message */
            if ( UNDEFINED_ID == mirrored_aug_id.R ) {
                empty_buffer_no = i;
            } else if ( new_aug_id.R < mirrored_aug_id.R ) {
                if (buffer_to_bump == UNDEFINED_BUFFER) {
                    buffer_to_bump = i;
                } else if ( id_mirror[buffer_to_bump].R < mirrored_aug_id.R ) {
                    buffer_to_bump = i;
                }
            }
        }
    }
    
    if (msg_handled==0) {
        if (empty_buffer_no == UNDEFINED_BUFFER) {
            /* Decide whether to (a) bump the lowest priority message
               already loaded into a TouCAN buffer or (b) place the new
               message into the queue */
            if ( (buffer_to_bump == UNDEFINED_BUFFER) || (num_buffers < 3) ) {
                /* Place the new message in the queue */
                CAN_FRAME * slot = pqinsert ( module, msg->ID, msg->type);
                if (slot != NULL) {
                    *slot = *msg;
                    msg_handled = 1;
                }
            } else {
                P_TOUCAN_MBUFF p_mbuff_to_bump = (void *) &(module->reg->MBUFF[buffer_to_bump]);
                
                /* Unload message already in the buffer */
                unloadCanMsg(p_mbuff_to_bump, reg, id_mirror[buffer_to_bump],
                                           buffer_to_bump, module);
                
                /* Load the new message */
                loadCanMessage(msg, p_mbuff_to_bump);
                id_mirror[buffer_to_bump].R = new_aug_id.R;
                msg_handled = 1;
            }
        } else {
            /* Load message into the empty buffer */
            P_TOUCAN_MBUFF p_mbuff_empty = (void *) &(module->reg->MBUFF[empty_buffer_no]);
            loadCanMessage( msg, p_mbuff_empty);
            id_mirror[empty_buffer_no].R = new_aug_id.R;
            msg_handled = 1;
        }
    }
    
    EIE();
    return msg_handled;
}
        
/* Unload a message from the TouCAN buffer */
static void unloadCanMsg(P_TOUCAN_MBUFF p_mbuff_to_bump, 
                                     struct TOUCAN_tag * reg, 
                                     AUGMENTED_ID msg_to_bump_id_aug, 
                                     unsigned int buffer_to_bump, 
                                 PCAN_MODULE module) {
    
    unsigned int msg_handled = 0;
    CanFrameType type;
    UINT32 id = msg_to_bump_id_aug.B.id;
    CAN_FRAME * slot;
    
    /* Mark the buffer inactive */
    p_mbuff_to_bump->SCR.B.CODE = MPC555_TOUCAN_TX_CODE_NOT_ACTIVE;
 
    /* It is possible that the message to bump has already, or is currently
     * being, transmitted. This occurrence will be rare as the message to bump
     * is only third in line to be transmitted. In such circumstances, the
     * bumped message may be transmitted twice. */
        
    if ( msg_to_bump_id_aug.B.xtd == 1 ) {
        type = CAN_MESSAGE_EXTENDED;
    } else {
        type = CAN_MESSAGE_STANDARD;
    }
    
    /* Get slot in queue for the bumped message */
    slot = pqinsert ( module, id, type);
    
    if (slot != NULL) {
        unsigned int length = p_mbuff_to_bump->SCR.B.LENGTH;
        
        slot->LENGTH = length;
        slot->ID = id;
        slot->type = type;
        memcpy( (void *) slot->DATA, 
                (void *) &(p_mbuff_to_bump->DATA[0].R), length);

    }
    return;
}

void SBTQ_sendAckISR(PCAN_MODULE module, TOUCAN_IRQ_SOURCE source){
    const UINT8 main_queue_head = module->queue_head;

    /* Augmented identifer of the message that will occupy the TouCAN buffer */
    AUGMENTED_ID msg_aug_id;
    msg_aug_id.R = UNDEFINED_ID;

    /* Note: we must check that the buffer is not active as it is possible that
     * an interrupt is generated from a message that was bumped by a higher
     * priority message. */
    if ( ( main_queue_head != TAIL_SLOT )
        && ( module->reg->MBUFF[source].SCR.B.CODE == MPC555_TOUCAN_TX_CODE_NOT_ACTIVE ) ) {
        P_TOUCAN_MBUFF p_mbuff = (void *) &(module->reg->MBUFF[source]);
        UINT8 * links = module->queue_links;
        CAN_FRAME * msg = &(module->tx_queue[main_queue_head]);
        UINT32 msg_id = msg->ID;
        unsigned int msg_xtd = ( msg->type == CAN_MESSAGE_EXTENDED ) ? 1 : 0;
        
        msg_aug_id.B.xtd = msg_xtd;
        msg_aug_id.B.id = msg_id;

        loadCanMessage(msg, p_mbuff);
        
        /* Main queue control */
        module->queue_head = links[main_queue_head];

        /* Empty slots list control */
        links[main_queue_head] = module->queue_empty_head;
        module->queue_empty_head = main_queue_head;
    }

    /* Update the list of augmented identifers for each shared transmit TouCAN buffer */
    module->tx_buffer_id_mirror[source].R = msg_aug_id.R;
}


/*                  
 *  pqinsert: insert an item into the queue.
 *
 *  Description: 
 *  
 *     The queue uses a linked list to hold CAN messages in order of 
 *     priority. If the queue contains messages of equal priority,
 *     the old message is overwritten by the new one. Note that it is
 *     the responsibility of the calling function to check that the returned
 *     CAN_FRAME pointer is not NULL and to copy the message to be inserted
 *     into this location.
 *     
 *     If the queue becomes full then message insertion will fail. Messages
 *     of lower priority are never overwritten
 *
 *  Parameters:
 *
 *    module      CAN module data including queue data and control variables
 *
 *    new_id      Identifier of message to be inserted.
 *
 *    xtd_new     Flag to indicate Extended or Standard Message
 *
 *  Return values:
 *
 *    Pointer to the CAN_FRAME where new message must be inserted. This pointer is
 *    NULL if no slot was available.
 */
static CAN_FRAME * pqinsert(PCAN_MODULE module, const UINT32 id_new, 
                            const CanFrameType type_new) {
    CAN_FRAME * q_ptr = module->tx_queue;    
    UINT8 * links = module->queue_links;
    const queue_head = module->queue_head;
    const UINT8 queue_length = module->queue_length;
    unsigned int next_empty =  module->queue_empty_head;
    UINT8 i;
    CAN_FRAME * rtn_val = NULL;

    UINT8 item = queue_head;
    UINT8 item_id = (q_ptr + queue_head)->ID;

    /* Manage the main queue */
    if ( ( queue_head == TAIL_SLOT ) 
         || ( item_id > id_new ) ) {
        /* Special case where we need to insert at the queue head */
        if ( next_empty != TAIL_SLOT ) {
            /* Manage the list of empty slots */
            module->queue_empty_head = links[next_empty];

            /* Insert new message into the queue */
            links[next_empty] = queue_head;
            module->queue_head = next_empty;
            rtn_val = (q_ptr+next_empty);
        }
    } else {
        /* Search for the message insertion point */
        for (i=0; i<(queue_length-1); i++) {
            UINT8 next_item = links[item];
            UINT32 next_item_id = (q_ptr+next_item)->ID;
            
            if ( ( item_id == id_new ) && (type_new == (q_ptr+item)->type ) ) {
                /* Current item has same id and must be overwritten */
                rtn_val = q_ptr + item;
                break;
            } else if ( ( next_item == TAIL_SLOT ) || ( next_item_id > id_new ) ) {
                /* Found the insertion point */
                if ( next_empty != TAIL_SLOT ) {
                    /* Manage the list of empty slots */
                    module->queue_empty_head = links[next_empty];
                    
                    /* Insert new message into queue */
                    links[next_empty] = next_item;
                    links[item] = next_empty;
                    rtn_val = q_ptr+next_empty;
                    break;
                } 
            }
            item = next_item;
            item_id = next_item_id;
        }
    } 
    return rtn_val;
}
