/*
 * File: tpu_common.c
 *
 * Abstract: Code for initialising TPU module objects
 *
 * $Revision: 1.1 $
 * $Date: 2002/10/25 13:40:04 $
 *
 * Copyright 2002 The MathWorks, Inc.
 */
#include "tpu_common.h"

void initTPUModule(const TPU_ISR_MODULE_PTR module,struct TPU3_tag * pReg){
   int idx;
   for (idx=0;idx<NTPUCALLBACKS;idx++){
      module->handlers[idx]=NULL;
      module->floatFlags[idx]=FLOAT_NOT_USED_IN_ISR;
   }
   module->reg=pReg;
}
