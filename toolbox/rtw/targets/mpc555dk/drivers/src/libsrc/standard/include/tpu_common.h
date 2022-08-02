/*
 * File: tpu_common.h
 *
 * Abstract: Required header file for TPU drivers
 *
 * $Revision: 1.1.4.2 $
 * $Date: 2004/04/19 01:25:44 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 */

#ifndef _TPU_COMMON_H_
#define _TPU_COMMON_H_

/* include for TPU3_tag */
#include "mpc5xx.h"
#include "bitops.h"
#include "isr.h"
/* include stdlib.h for NULL and EXIT_FAILURE */
#include <stdlib.h>

#define NTPUCALLBACKS 16


/* 
 * Enumeration
 *
 * TPU_IRQ_SOURCE
 *
 * Purpose
 *
 * indicates the channel that generated the interrupt
 * detected by the TPU module.
 *
 */
typedef enum {
   TPU_IRQ_CHANNEL0 = 0,
   TPU_IRQ_CHANNEL1,
   TPU_IRQ_CHANNEL2,
   TPU_IRQ_CHANNEL3,
   TPU_IRQ_CHANNEL4,
   TPU_IRQ_CHANNEL5,
   TPU_IRQ_CHANNEL6,
   TPU_IRQ_CHANNEL7,
   TPU_IRQ_CHANNEL8,
   TPU_IRQ_CHANNEL9,
   TPU_IRQ_CHANNEL10,
   TPU_IRQ_CHANNEL11,
   TPU_IRQ_CHANNEL12,
   TPU_IRQ_CHANNEL13,
   TPU_IRQ_CHANNEL14,
   TPU_IRQ_CHANNEL15 } TPU_IRQ_SOURCE;

/*
 * Define a TPU Module 
 */
typedef struct TPU_ISR_MODULE * TPU_ISR_MODULE_PTR;

/* Pointer to void handler function, with arguments module and source */
typedef void (* TPU_IRQ_HANDLER) (TPU_ISR_MODULE_PTR module, TPU_IRQ_SOURCE source);

typedef struct TPU_ISR_MODULE {
   struct TPU3_tag * reg;   /* Memory mapped location of TPU module registers */
   TPU_IRQ_HANDLER handlers[NTPUCALLBACKS]; /* Handlers for each interrupt source */
   FLOATING_POINT_FOR_ISR floatFlags[NTPUCALLBACKS]; /* do the callbacks require floating point */
} TPU_ISR_MODULE;

/* Initialises the fields in TPU Interrupt Modules to default values */
void initTPUModule(const TPU_ISR_MODULE_PTR module,struct TPU3_tag * pReg);

#endif
