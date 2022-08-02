/*
 * File: can_driver.h
 *
 * Abstract:
 *    CAN driver for use by boot code
 *
 * $Revision: 1.1.6.2 $
 * $Date: 2004/04/19 01:25:10 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 */

#ifndef _CAN_DRIVER_H
#define _CAN_DRIVER_H

#include "mpc5xx.h"
#include "can_common.h"
#include "math.h"

#define DEFAULT_BIT_RATE 500000
#define DEFAULT_NUM_QUANTA 20
#define DEFAULT_SAMPLE_POINT 0.81

#define BOOTCODE_SYSTEM_FREQUENCY 20e6

#define TX_BUFFER 0
#define RX_BUFFER 1

#define CAN_MODULE CAN_A

#define CAN_MESSAGE_STANDARD 0
#define CAN_MESSAGE_EXTENDED 1
#define MESSAGE_TYPE CAN_MESSAGE_EXTENDED

#define MESSAGE_LENGTH

//------------------------------------------
//

int receiveCanFrameBoot(unsigned char * data);
void initCanModuleRxTxBoot(UINT32 rx_id, UINT32 tx_id);
void sendCanFrameBoot(unsigned char * data);
void setupCanModuleBoot(UINT16 desiredNumQuanta,
                        FLOAT32 desiredSamplePoint,
                        FLOAT32 desiredBitRate);

static void setBitTiming(UINT16 desiredNumQuanta,
                  FLOAT32 desiredSamplePoint,
                  FLOAT32 desiredBitRate);

#define SHUTDOWN_CAN CAN_MODULE.TCNMCR.B.HALT=1

#endif
