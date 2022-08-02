/*
 * File: ccp_network.h
 *
 * Abstract:
 *    Generic CCP Transmit and Receive function definitions
 *
 * $Revision: 1.1.6.2 $
 * $Date: 2003/12/11 03:48:44 $
 *
 * Copyright 2003 The MathWorks, Inc.
 */


#ifndef _CCP_NETWORK_H
#define _CCP_NETWORK_H

/* Function pointer type for receiving CCP messages */
typedef uint8_T (* RECEIVE_CCP_MESSAGE) (uint8_T * msg);

/* Function pointer type for transmitting CCP messages */
typedef void (* TRANSMIT_CCP_MESSAGE) (uint8_T * msg);

/* these global variables are defined in 
 * main.c */
extern RECEIVE_CCP_MESSAGE RxCCP;
extern TRANSMIT_CCP_MESSAGE TxCCP;

#endif
