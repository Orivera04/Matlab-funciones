/*
 * File: can_common.h
 *
 * Abstract: Required header file for TouCAN drivers
 *
 * $Revision: 1.15.8.3 $
 * $Date: 2004/04/19 01:25:32 $
 *
 * Copyright 2001-2003 The MathWorks, Inc.
 */

#ifndef _CAN_COMMON_H_
#define _CAN_COMMON_H_

#include "mpc5xx.h"
#include "isr_types.h"
#include "can_msg.h"
#include "bitops.h"

#define NTOUCANCALLBACKS 19

/* Codes to query the status of the TOUCAN RX and TX buffers */
#define MPC555_TOUCAN_RX_CODE_NOT_ACTIVE 0x0
#define MPC555_TOUCAN_RX_CODE_BUSY 0x1
#define MPC555_TOUCAN_RX_CODE_ACTIVE_EMPTY 0x4
#define MPC555_TOUCAN_RX_CODE_FULL      0x2
#define MPC555_TOUCAN_RX_CODE_OVERRUN   0x6

#define MPC555_TOUCAN_TX_CODE_NOT_ACTIVE 0x8
#define MPC555_TOUCAN_TX_CODE_ONCE 0xC
#define MPC555_TOUCAN_TX_CODE_IN_REMOTE_RESPONSE 0xA
#define MPC555_TOUCAN_TX_CODE_ONCE_THEN_IN_REMOTE_RESPONSE 0xE


/*---------------------------------------------------------
 * Mappings
 *
 *    These macros map an integer to the seperate ID_HIGH
 *    and ID_LOW components required by the TOUCAN buffer.
 *
 * Example
 *
 *    If the ID was 57 and it was a standard ID then
 *    
 *    idh = STD_ID_2_ID_HIGH(57)
 *    idl = STD_ID_2_ID_LOW(57)
 *
 * --------------------------------------------------------*/
#define STD_ID_2_ID_HIGH(ID) ((unsigned short)((ID)<<5))
#define STD_ID_2_ID_LOW(ID) ((unsigned short)0)

#define XTD_ID_2_ID_HIGH(ID) ((unsigned short)((( ID >> 13 ) & 0xFFE0) |((ID>>15)&7) | 0x18))
#define XTD_ID_2_ID_LOW(ID)  ((unsigned short)(( ID & 0x7FFF ) << 1))

#define IS_XTD(ID_HIGH) ( ( ID_HIGH & 0x0008 ) == 0x0008 )
#define ID_HIGH_LOW_2_XTD_ID(ID_HIGH, ID_LOW) ( \
       (  ( (UINT32) ( ID_HIGH >> 5  ) ) << 18 ) \
       |( ( (UINT32) ( ID_HIGH & 0x7 ) ) << 15 ) \
       |( ( (UINT32) ( ID_LOW        ) ) >> 1  ) \
       )
#define ID_HIGH_2_STD_ID(ID_HIGH) ( \
    ( ( (UINT32) ( ID_HIGH ) ) >> 5 ) \
    )

    
/*------------------------------------------------------------------------*/


/* -----------------------------------------------
 * Enumeration
 *
 *    TOUCAN_IRQ_SOURCE
 *
 * Purpose
 *
 *    indicates the type of interrupt detected by 
 *    the TOUCAN module.
 *
 * -----------------------------------------------*/
typedef enum {
	CAN_IRQ_BUFFER0,
	CAN_IRQ_BUFFER1,
	CAN_IRQ_BUFFER2,
	CAN_IRQ_BUFFER3,
	CAN_IRQ_BUFFER4,
	CAN_IRQ_BUFFER5,
	CAN_IRQ_BUFFER6,
	CAN_IRQ_BUFFER7,
	CAN_IRQ_BUFFER8,
	CAN_IRQ_BUFFER9,
	CAN_IRQ_BUFFER10,
	CAN_IRQ_BUFFER11,
	CAN_IRQ_BUFFER12,
	CAN_IRQ_BUFFER13,
	CAN_IRQ_BUFFER14,
	CAN_IRQ_BUFFER15,
	CAN_IRQ_BUS_OFF,
	CAN_IRQ_ERROR,
	CAN_IRQ_WAKE } TOUCAN_IRQ_SOURCE ;

   // Convert a buffer to it's IRQ enumeration
   // and vice versa. Use these macros always just in case the
   // mapping between IRQ and buffer changes.
#define BUFFER_TO_IRQ_SOURCE(buffer) ( (TOUCAN_IRQ_SOURCE) (buffer) )
#define IRQSOURCE_TO_BUFFER(source ) ( (UINT8) (source) )


/* A circular buffer for holding received messages or messages to transmit */
typedef struct MESSAGE_CIRCULAR_BUFFER {
    CAN_FRAME * buffer;
    int readIdx;
    int writeIdx;
    int size;
    int full;
    int overflowCount;
} MESSAGE_CIRCULAR_BUFFER;

/* A structure for accessing a TouCAN message buffer */
typedef struct TOUCAN_MBUFF {
    union {
        VUINT16 R;
        struct {
            VUINT16 TIMESTAMP:8;
            VUINT16 CODE:4;
            VUINT16 LENGTH:4;
        } B;
    } SCR;
    union {
        VUINT16 R;
        VUINT16 B;
    } ID_HIGH;
    union {
        VUINT16 R;
        VUINT16 B;
    } ID_LOW;
    union {
        VUINT8 R;
        VUINT8 B;
    } DATA[8];
    VUINT16 res45a;
} TOUCAN_MBUFF;

typedef TOUCAN_MBUFF * P_TOUCAN_MBUFF;

/*------------------------------------------------------------
 * Define a TOUCAN MODULE
 *
 *------------------------------------------------------------*/
#define MAX_SHARED_TX_BUFFERS (0x3U) /* Maximum number of shared transmit buffers */

typedef struct CAN_MODULE * PCAN_MODULE;

typedef void ( * CAN_IRQ_CALLBACK ) ( PCAN_MODULE module, TOUCAN_IRQ_SOURCE source );

/* Combined CAN message identifier and extended/standard bit in a compact format
 * that can be used for greater than or less than comparisons */
typedef union AUGMENTED_ID {
    UINT32 R;
    struct { 
        UINT32 xtd         :1;
        UINT32 id          :29;
        UINT32 reserved    :2;
    } B;
} AUGMENTED_ID;

typedef struct CAN_MODULE {
    struct TOUCAN_tag * reg;     // Memory mapped location of TOUCAN module registers
    CAN_IRQ_CALLBACK callbacks[NTOUCANCALLBACKS];  // Callbacks for each interrupt source
    void * irqObjects[NTOUCANCALLBACKS]; // Objects for each interrupt source
    void * callback_user_data[NTOUCANCALLBACKS]; // User callback data for each interrupt source
    FLOATING_POINT_FOR_ISR floatFlags[NTOUCANCALLBACKS]; /* Callbacks with floating point */
    CAN_FRAME * tx_queue;
    UINT8 queue_empty_head; /* First empty slot */
    UINT8 * queue_links;
    UINT8 queue_length;
    UINT8 queue_head;
    UINT8 num_tx_buffers;
    AUGMENTED_ID tx_buffer_id_mirror[MAX_SHARED_TX_BUFFERS]; // mirror identifiers in tx buffers
    MPC555_IRQ_LEVEL irqlevel;
    UINT16 desiredNumQuanta;
    FLOAT32 desiredSamplePoint;
    FLOAT32 desiredBitRate;
} CAN_MODULE;

/*------------------------------------------------------------
 * Starting and stoping the TOUCAN
 * 
 * After setting all the receive buffers up and you wish
 * to get the TOUCAN to participate in bus activity call the
 * macro
 *
 * START_CAN_MODULE
 * STOP_CAN_MODULE
 * 
 * Arguments
 *    
 *    PCAN_MODULE module - the module you wish to start
 *
 * Notes
 *
 * After machine reset the TOUCAN modules are halted by default
 *------------------------------------------------------------*/
#define START_CAN_MODULE(module) (module)->reg->TCNMCR.B.HALT=0
#define STOP_CAN_MODULE(module) (module)->reg->TCNMCR.B.HALT=1

/*-----------------------------------------------------------
 * TOUCAN interrupts
 *
 * Setting the mask for a particular buffer enables the
 * particular buffer to generate interrupts on successfull
 * transmit or recieve. 
 *
 * Arguments
 *    pModule  -  pointer to the base of the CAN module
 *    buffer   -  the buffer number 0-15
 *
 * ---------------------------------------------------------*/
#define CLR_TOUCAN_BUFFER_IMASK(pModule,buffer) BITCLR(pModule->IMASK.R,buffer)
#define GET_TOUCAN_BUFFER_IMASK(pModule,buffer) BITGET(pModule->IMASK.R,buffer)

#define CLR_TOUCAN_BUFFER_IFLAG(pModule,buffer) BITCLR(pModule->IFLAG.R,buffer)
#define GET_TOUCAN_BUFFER_IFLAG(pModule,buffer) BITGET(pModule->IFLAG.R,buffer)

#endif















