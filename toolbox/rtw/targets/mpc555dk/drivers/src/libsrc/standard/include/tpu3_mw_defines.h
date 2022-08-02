/* File : tpu3_mw_defines.h
 *
 * Abstract :
 *    TPU3 API
 *
 * Copyright 2002 The MathWorks, Inc.
 * $Revision: 1.7 $ 
 * $Date: 2002/11/14 16:30:31 $
 *
 */

/* TPU ROM Function Codes */
#define TPU_FN_DIO 2U /* Digital Input / Output */
#define TPU_FN_PWM 3U /* Pulse Width Modulation */
#define TPU_FN_FQD 6U /* Fast Quadrature Decode */
#define TPU_FN_NITC 0xAU /* New Input Capture / Input Transition Counter */
#define TPU_FN_PTA 0xFU /* Programmable Time Accumulator */

/******************************************************************
 *
 * TPU ROM PWM 
 *
 ******************************************************************/
#define TPU_PWM_HS_INITIALIZE 0x2U
/* 
 * 0100 1xx 11 -->  010010011 == 0x93 
 *
 * Output Channel (TCR1 Capture & Compare), Do Not Change PAC, Do Not Force Any State
 *                                                                 */
#define TPU_PWM_CHANNEL_CONTROL 0x93U /* See Motorola TPUPN17/D p3 */

/* enumeration of PWM Parameters */
enum {   TPU_PWM_CHANNEL_CONTROL_PARAM = 0, 
         TPU_PWM_OLDRIS_PARAM,
         TPU_PWM_PWMHI_PARAM,
         TPU_PWM_PWMPER_PARAM,
         TPU_PWM_PWMRIS_PARAM,
         TPU_PWM_HI_PER_32_PARAM = 1};


/******************************************************************
 *
 * TPU ROM DIO - Configured for Output 
 *
 ******************************************************************/
#define TPU_DIO_HS_PIN_HIGH   0x1U
#define TPU_DIO_HS_PIN_LOW    0x2U
/*
 * 1xxx 1xx 11 --> 100010011 == 0x113U
 * 
 * Do Not Change TBS, Do Not Change PAC, Do Not Force
 *                                                    */
#define TPU_DIO_OUTPUT_CHANNEL_CONTROL 0x113U


/******************************************************************
 * 
 * TPU ROM DIO - Configured for Input (update on all transitions) 
 *
 ******************************************************************/
#define TPU_DIO_HSQR_TRANSITION_MODE 0x0U
#define TPU_DIO_HSRR_INIT_AS_PER_HSQR 0x3U
/* 
 * 0000 011 11 -->  000001111 == 0xF
 * 
 * Input Channel (TCR1 Capture & Match), Detect Either Edge, Do Not Force Any State 
 *                                                                */
#define TPU_DIO_INPUT_CHANNEL_CONTROL 0xFU /* See Motorola TPUPN18/D p3 */

/* enumeration of DIO Parameters */
enum {   TPU_DIO_CHANNEL_CONTROL_PARAM = 0,
         TPU_DIO_PIN_LEVEL_PARAM,
         TPU_DIO_MATCH_RATE_PARAM };


/******************************************************************
 *
 * TPU Fast Quadrature Decode (FQD) 
 *
 ******************************************************************/
#define TPU_FQD_HSQR_PRI_NORM 0x0U
#define TPU_FQD_HSQR_SEC_NORM 0x1U
#define TPU_FQD_HSQR_PRI_FAST 0x2U
#define TPU_FQD_HSRR_INIT 0x3U

/* enumeration of FQD Parameters */
enum {   TPU_FQD_EDGE_TIME_PARAM = 0,
         TPU_FQD_POSITION_COUNT_PARAM,
         TPU_FQD_TCR1_VALUE_PARAM,
         TPU_FQD_CHAN_PINSTATE_PARAM,
         TPU_FQD_CORR_PINSTATE_ADDR_PARAM,
         TPU_FQD_EDGE_TIME_LSB_ADDR_PARAM };
         

/*******************************************************************
 *
 * TPU New Input Capture / Input Transition Counter (NITC)                
 *
 *******************************************************************/
#define TPU_NITC_HSQR_CONT_NO_LINKS 0x1U
#define TPU_NITC_HSRR_TCR_MODE 0x1U
#define TPU_NITC_HSRR_PARM_MODE 0x2U
/*
 * 000x 001 11 --> 000000111 == 0x7
 *
 * Input Channel (Capture TCR1), Detect Rising Edge, "don't care"
 *                                                                   */
#define TPU_NITC_TCR1_RISING_EDGE 0x7U

/*
 * 000x 010 11 --> 000001011 == 0xB
 *
 * Input Channel (Capture TCR1), Detect Falling Edge, "don't care" 
 *                                                                   */
#define TPU_NITC_TCR1_FALLING_EDGE 0xBU

/*
 * 000x 011 11 --> 000001111 == 0xF
 *
 * Input Channel (Capture TCR1), Detect Either Edge, "don't care"
 *                                                                   */
#define TPU_NITC_TCR1_EITHER_EDGE  0xFU

/* enumeration of NITC Parameters */
enum {   TPU_NITC_CHANNEL_CONTROL_PARAM = 0,
         TPU_NITC_PARAM_ADDR_PARAM,
         TPU_NITC_MAX_COUNT_PARAM,
         TPU_NITC_TRANS_COUNT_PARAM,
         TPU_NITC_FINAL_TRANS_TIME_PARAM,
         TPU_NITC_LAST_TRANS_TIME_PARAM };

/**********************************************************************
 *
 * TPU Programmable Time Accumulator (PTA)
 *
 **********************************************************************/
#define TPU_PTA_HSQR_HIGH_TIME         0x0U
#define TPU_PTA_HSQR_LOW_TIME          0x1U
#define TPU_PTA_HSQR_PERIOD_RISING     0x2U
#define TPU_PTA_HSQR_PERIOD_FALLING    0x3U

#define TPU_PTA_HSRR_INIT 0x3U

/*
 * 0000 011 11 == 0xF
 *
 * Measure HIGH or LOW pulse width with TCR1 timebase
 *                                                 */
#define TPU_PTA_TCR1_HIGH_OR_LOW_TIME 0xFU

/*
 * 0000 001 11 == 0x7
 *                                                 
 * Measure PERIOD on RISING edge with TCR1 timebase
 *                                                 */
#define TPU_PTA_TCR1_PERIOD_RISING 0x7U

/*
 * 0000 010 11 == 0xB
 *
 * Measure PERIOD on FALLING edge with TCR1 timebase 
 *                                                  */
#define TPU_PTA_TCR1_PERIOD_FALLING 0xBU

/* enumeration of PTA Parameters */
enum {   TPU_PTA_CHANNEL_CONTROL_PARAM = 0,
         TPU_PTA_Max_Period_COUNT_PARAM,
         TPU_PTA_LAST_TIME_PARAM,
         TPU_PTA_ACCUM_PARAM,
         TPU_PTA_HW_PARAM,
         TPU_PTA_LW_PARAM,
         TPU_PTA_HW_LW_32_PARAM = 2};

