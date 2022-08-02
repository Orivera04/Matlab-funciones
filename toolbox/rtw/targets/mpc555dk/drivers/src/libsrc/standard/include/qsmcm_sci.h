/*
 * File: qsmcm_sci.h
 *
 * Abstract:
 *   Transmit data over the MPC55 Serial Communications Interface
 *
 * $Revision: 1.2.4.2 $
 * $Date: 2004/04/19 01:25:41 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 */

#ifndef QSMCM_SCI_H
#define QSMCM_SCI_H

/*==========*
 * Includes *
 *==========*/
#include "tmwtypes.h"

/*==========*
 * Defines
 *==========*/
/* Bits used for error and overrun status in flag variable */
#define MPC555_QSMCM_SCI1_PE_FE 0x0001
#define MPC555_QSMCM_SCI2_PE_FE 0x0004
#define MPC555_QSMCM_SCI2_OR    0x0008

/*==================*
 * Global variables
 *==================*/
/* Variable used to hold error status information for SCI modules */
extern uint8_T mpc555_qsmcm_sci_flags;


/*=====================*
 * Function prototypes *
 *=====================*/

/* Reset the serial port SCI1. 
 * 
 * Arguments:
 *
 * Returns - none
 */
void qsmcm_sci1_reset();

/* Initialize the serial port SCI1. 
 * 
 * Arguments:
 *
 * sc1br   - setting for bit rate register
 * scc1r1  - setting for control register 1
 * 
 * Returns - none
 */
void qsmcm_sci1_init(uint16_T sc1br, uint16_T scc1r1);

/* Initialize the serial port SCI2. 
 * 
 * Arguments:
 *
 * sc2br   - setting for bit rate register
 * scc2r1  - setting for control register 1
 * 
 * Returns - none
 */
void qsmcm_sci2_init(uint16_T sc2br, uint16_T scc2r1);


/* Disables the serial port SCI1
 * 
 * Arguments: none
 *
 * Returns - none
 */
void qsmcm_sci1_disable(void);

/* Disables the serial port SCI2
 *
 * Arguments: none
 *
 * Returns: none
 *
 */
void qsmcm_sci2_disable(void);


/* Send bytes through the serial port SCI1. 
 * 
 * Arguments:
 *
 * string  - pointer to string of bytes to transmit
 * size    - max number of bytes available to transmit
 * 
 * Returns - the number of bytes actually consumed; this may be less than
 *           the number available to transmit. 
 */
uint32_T general_send_string_sci1(uint8_T *string, uint32_T size);

/* Send bytes through the serial port SCI2. 
 * 
 * Arguments:
 *
 * string  - pointer to string of bytes to transmit
 * size    - max number of bytes available to transmit
 * 
 * Returns - the number of bytes actually consumed; this may be less than
 *           the number available to transmit. 
 */
uint32_T general_send_string_sci2(uint8_T *string, uint32_T size);

/* Get bytes from the serial port SCI1
 * Arguments:
 *
 * string  - pointer to buffer for received bytes
 * size    - requested  number of bytes to transfer into buffer
 * 
 * Returns - the number of bytes actually transferred; this may be less than
 *           the number requested.
 */
uint32_T general_get_string_sci1(uint8_T *string, uint32_T size);

/* Get bytes from the serial port SCI2
 * Arguments:
 *
 * string  - pointer to buffer for received bytes
 * size    - requested  number of bytes to transfer into buffer
 * 
 * Returns - the number of bytes actually transferred; this may be less than
 *           the number requested.
 */
uint32_T general_get_string_sci2(uint8_T *string, uint32_T size);

#endif




