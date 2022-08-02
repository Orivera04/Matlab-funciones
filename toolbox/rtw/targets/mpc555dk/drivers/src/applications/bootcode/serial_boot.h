/*
 * File: serial_boot.h
 *
 * Abstract:
 *    Serial support for the bootcode
 *
 * $Revision: 1.1.6.3 $
 * $Date: 2003/12/11 03:48:52 $
 *
 * Copyright 2003 The MathWorks, Inc.
 */

#ifndef _SERIAL_BOOT_H
#define _SERIAL_BOOT_H

#include "qsmcm_sci.h"
#include "mpc5xx.h"

#define TARGET_ALIVE_CODE     'A'
/* same code for TARGET_READY_FOR_CCP and ACK */
#define TARGET_READY_FOR_CCP  'B'
#define ACK_CODE              'B'
#define CCP_MESSAGE_CODE      'C'
#define PARITY_CODE           'D'
#define OVERRUN_CODE          'E'
#define SEQUENCE_ERROR        'F'
#define EARLY_FRAMING_ERROR   'G'


#define SINGLE_SERIAL_BYTE    1
#define CCP_MESSAGE_BYTES     8
/* the CCP response only 
 * ever contains 5 bytes of 
 * data, we can turn it into a
 * full 8 byte CCP Message on
 * the host.
 *
 * This makes the network protocol more effecient */
#define TX_CCP_MESSAGE_BYTES 5 

#define DEFAULT_sc1br 0xbU 

// 19200 0x21U

// 57600 0xbU

// 9600 0x41U

/* SCI1 control register 1 
 * Using 8-bit data
 * Parity = N/A
 */
#define DEFAULT_scc1r1 0x60cU

// 8-bit, no parity 0xcU

// 8-bit, + even parity 0x60cU

void initSerialModuleBoot(void);

uint8_T receiveTargetAliveByte(void);

void syncWithHost(void);

uint8_T receiveSerialCCPMessage(uint8_T *msg);
void waitForSerialCCPMessage(uint8_T *msg);

void sendSerialCCPMessage(uint8_T *msg);

static void waitForXBytes(uint8_T x, uint8_T *msg);
static void sendAck(void);
static void parityCheck(void);

/* terminate the download process by
 * looping until a watchdog timeout occurs. */
static void terminateDownload(void);

#endif
