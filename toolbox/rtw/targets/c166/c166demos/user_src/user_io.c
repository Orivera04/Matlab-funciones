/*
 * File: user_io.c
 *
 * Abstract:
 *   Example file showing how to integrate hand-code input/output driver
 *   functions with Embedded Target for Infineon C166® Microcontrollers.
 *
 * $Revision: 1.1.10.1 $
 * $Date: 2004/03/15 22:21:05 $
 *
 */

#include <reg167cr.h>
#include "user_io.h"

/* Include the automatically generated header file. The filename must match the
 * name of the target subsystem in the Simulink model. */
#include "controller.h"

/*==================================================*
 * Define variables that are imported by the model
 *==================================================*/
uint16_T input_adc0;

/*==================================================*
 * Local function prototypes
 *==================================================*/
static void digital_io_initialise( void );
static void adc_initialise( void );
static void pwm_initialise( void );

/* Initialize input/output drivers */
void user_io_initialize() {

    digital_io_initialise();
    adc_initialise();
    pwm_initialise();

}

/* Read model base rate inputs */
void base_rate_model_inputs() {

    input_adc0 = ADDAT;

}

/* Write model base rate outputs */
void base_rate_model_outputs() {

    /* PWM channel 0 pulse width register */
    PW0 = output_PWM0;

}

/* Read model sub-task 1 inputs */
void sub_rate_1_model_inputs() {
}

/* Read model sub-task 1 outputs */
void sub_rate_1_model_outputs( void ) {


    if (dig_outputs.output_led_D3) {
        P2 |= 0x0001;
    } else {
        P2 &= 0xFFFE;
    }

    if (dig_outputs.output_dig1) {
        P2 |= 0x0002;
    } else {
        P2 &= 0xFFFD;
    }


}

/* Initialization for ADC */
static void adc_initialise( void ) {
    
    /* Set ADCON = 0x0090 for fixed channel continuous conversion on
     * channel 0
     */
    ADCON = 0x0090;
}


/* Initialization for digital I/O */
static void digital_io_initialise( void ) {

/* Set TTL input levels on all ports */
    PICON = 0x0000;

/* Set P2.0 data register */
    P2 = 0x0003;

/* Set P2.0 as output */
    DP2 = 0x0003;

}


/* Initialization for PWM */
static void pwm_initialise( void ) {

    /* PWM channel 0 counter register */
    PT0 = 0x0000;

    /* PWM channel 0 period register */
    PP0 = 0x3FF;

    /* PWM channel 0 pulse width register */
    PW0 = 0x200;
    
    /* PWM control register 1: enable channel 0 */
    PWMCON1 = 0x0001;

    /* Initialize P7.0 for output of PWM channel 0 */
    DP7  |= 0x0001;

    /* PWM control register 0: start channel 0 */
    PWMCON0 = 0x0001;

}
