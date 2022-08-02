/*
 * File: user_io.h
 *
 * Abstract:
 *   Example file showing how to integrate hand-code input/output driver
 *   functions with Embedded Target for Infineon C166® Microcontrollers.
 *
 * $Revision: 1.1.10.1 $
 * $Date: 2004/03/15 22:21:06 $
 *
 */

#include "tmwtypes.h"

/*==================================================*
 * Declare variables that are imported by the model
 *==================================================*/
extern uint16_T input_adc0;

/*=====================*
 * Function prototypes *
 *=====================*/

void user_io_initialize( void);
void base_rate_model_inputs( void );
void base_rate_model_outputs( void );
void sub_rate_1_model_inputs( void );
void sub_rate_1_model_outputs( void );
void sub_rate_2_model_inputs( void );
void sub_rate_2_model_outputs( void );
void sub_rate_3_model_inputs( void );
void sub_rate_3_model_outputs( void );
void sub_rate_4_model_inputs( void );
void sub_rate_4_model_outputs( void );
void sub_rate_5_model_inputs( void );
void sub_rate_5_model_outputs( void );
void sub_rate_6_model_inputs( void );
void sub_rate_6_model_outputs( void );
void sub_rate_7_model_inputs( void );
void sub_rate_7_model_outputs( void );


