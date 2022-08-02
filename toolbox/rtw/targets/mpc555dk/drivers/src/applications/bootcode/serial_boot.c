/*
 * File: serial_boot.c
 *
 * Abstract:
 *    Serial support for the bootcode
 *
 * $Revision: 1.1.6.3 $
 * $Date: 2003/12/11 03:48:51 $
 *
 * Copyright 2003 The MathWorks, Inc.
 */


#include "serial_boot.h"

#ifndef MPC555_VARIANT
#define QSMCM QSMCM_A
#endif

void initSerialModuleBoot() {
   /* init SCI1 */ 
   qsmcm_sci1_init(DEFAULT_sc1br, DEFAULT_scc1r1);
}

uint8_T receiveTargetAliveByte() {
   uint8_T byteReceived;
   uint32_T bytesTransferred;
   bytesTransferred = general_get_string_sci1(&byteReceived, 
                                              SINGLE_SERIAL_BYTE);
   if ((bytesTransferred == SINGLE_SERIAL_BYTE) && 
       (byteReceived == (uint8_T) TARGET_ALIVE_CODE)) {
      return 1; 
   }
   else {
      return 0;
   }
}

void syncWithHost() {
   uint8_T data;
   volatile uint16_T clearStatus;
  
   /* check for early framing error (break) */
   if (QSMCM.SC1SR.B.FE) {
      data = (uint8_T) EARLY_FRAMING_ERROR;
      while(!general_send_string_sci1(&data, SINGLE_SERIAL_BYTE)) {
      }
      terminateDownload();
   }
   
   /* respond to the TARGET_ALIVE byte */
   data = (uint8_T) TARGET_ALIVE_CODE;
   while(!general_send_string_sci1(&data,SINGLE_SERIAL_BYTE)) {
   }
  
   /* note: until the host receives the TARGET_ALIVE_CODE
    * it will be sending TARGET_ALIVE bytes as quickly as 
    * possible, which may overflow the receive queue.
    *
    * So, we will abandon the byte protocol, and use 
    * BREAK and IDLE to complete the sync */
   
   while (!QSMCM.SC1SR.B.FE) {
      /* wait for the break to 
       * start being received */
   }

   /* we are in the middle of a break at this point,
    * clear the status register (including IDLE flag),
    * so we are ready to detect the end of the break */
   clearStatus = QSMCM.SC1DR.R;
   
   while (!QSMCM.SC1SR.B.IDLE) {
      /* wait for host to stop transmitting
       * the break before we continue */
   }
 
   /* clear the status register to clear the IDLE again */
   clearStatus = QSMCM.SC1DR.R;
   
   /* now reset the serial driver to clear the queue,
    * ready for CCP Messages */
   qsmcm_sci1_reset();

   /* respond to the TARGET_READY_FOR_CCP byte */
   data = (uint8_T) TARGET_READY_FOR_CCP;
   while (!general_send_string_sci1(&data, SINGLE_SERIAL_BYTE)) {
   }

   /* target side protocol complete - ready for 1st CCP message */
}

/* Only blocks once we have started to receive a message */
uint8_T receiveSerialCCPMessage(uint8_T *msg) {
   /* attempt to receive a complete CCP message */
   uint8_T remainingBytes = CCP_MESSAGE_BYTES;
   uint8_T bytesTransferred;

   bytesTransferred = general_get_string_sci1(msg, CCP_MESSAGE_BYTES);
   if (!bytesTransferred) {
      /* no bytes available - return immediately */
      return 0;
   }
   else {
      /* started reading message, so 
       * read the rest of it */
      waitForXBytes(CCP_MESSAGE_BYTES - bytesTransferred, &msg[bytesTransferred]);
      parityCheck();
      sendAck(); 
      return 1;
   }
}

static void terminateDownload() {
   while (1) {
      /* enforce any error codes transmitted to the 
       * target by looping until the watchdog timeout 
       * occurs and resets the processor */
   }
}

static void parityCheck() {
   uint8_T errorCode;
   if (QSMCM.SC1SR.B.PF) {
      /* parity error occurred 
       * notify the host */ 
      errorCode = (uint8_T) PARITY_CODE;
      while (!general_send_string_sci1(&errorCode, SINGLE_SERIAL_BYTE)) {
      }
      terminateDownload();
   }
   if (QSMCM.QSCI1SR.B.QOR) {
      /* queue overrun,
       * notify the host */
      errorCode = (uint8_T) OVERRUN_CODE;
      while (!general_send_string_sci1(&errorCode, SINGLE_SERIAL_BYTE)) {
      }
      terminateDownload();
   }
}

/* block waiting for a CCP message */
void waitForSerialCCPMessage(uint8_T *msg) {
   waitForXBytes(CCP_MESSAGE_BYTES, msg);
   parityCheck();
   sendAck();
}

/* internal function to block waiting for x bytes of data */
static void waitForXBytes(uint8_T x, uint8_T *msg) {
   uint8_T bytesTransferred;
   uint8_T remainingBytes = x;
   while(remainingBytes) {
      bytesTransferred = general_get_string_sci1(&msg[x - remainingBytes],
                                                  remainingBytes);
      remainingBytes -= bytesTransferred;
   }
}

/* send acknowledgement */
static void sendAck() {
   uint8_T ackData;
   ackData = (uint8_T) ACK_CODE;
   while (!general_send_string_sci1(&ackData, SINGLE_SERIAL_BYTE)) {
   }
}

void sendSerialCCPMessage(uint8_T *msg) {
   uint8_T CCPCode = (uint8_T) CCP_MESSAGE_CODE;
   while (!general_send_string_sci1(&CCPCode, SINGLE_SERIAL_BYTE)) {
   }
   while (!general_send_string_sci1(msg, TX_CCP_MESSAGE_BYTES)) {
   }
}
