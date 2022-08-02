/*
 * File: asc_serial_pec.h
 *
 * Abstract:
 *   Implements driver for Asynchronous/Synchronous Serial Interface using 
 *   the Peripheral Event Controller. Required by Simulink external mode
 *   when running over a serial connection.
 *
 * $Revision: 1.4 $
 * $Date: 2002/10/29 08:30:29 $
 *
 * Copyright 1994-2002 The MathWorks, Inc.
 *
 */

/*==========*
 * Includes *
 *==========*/
#include "tmwtypes.h"

/*=====================*
 * Function prototypes *
 *=====================*/
void asc_serial_pec_init(void);
int16_T general_send_string(uint8_T *string, int16_T size);
int16_T general_get_string(uint8_T *string, int16_T size);
