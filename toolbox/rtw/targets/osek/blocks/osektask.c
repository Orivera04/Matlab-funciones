/*
 * $Revision: 1.1.4.1 $
 * $RCSfile: osektask.c,v $
 *
 * Abstract:
 *      OSEK Task Block.
 *
 * Copyright 2002-2004 The MathWorks, Inc.
 */

#define S_FUNCTION_NAME osektask
#define S_FUNCTION_LEVEL 2

#define TASK_NAME       (ssGetSFcnParam(S,0))
#define PRIORITY        (ssGetSFcnParam(S,1))
#define STACK_SIZE      (ssGetSFcnParam(S,2))
#define TASK_SCHED      (ssGetSFcnParam(S,3))

#include "simstruc.h"

#ifndef MATLAB_MEX_FILE
/* Since we have a target file for this S-function, declare an error here
 * so that, if for some reason this file is being used (instead of the
 * target file) for code generation, we can trap this problem at compile
 * time. */
#  error This_file_can_be_used_only_during_simulation_inside_Simulink
#endif

/*====================*
 * S-function methods *
 *====================*/

#define MDL_CHECK_PARAMETERS
static void mdlCheckParameters(SimStruct *S)
{
    int_T priority  = (int_T) (*(mxGetPr(PRIORITY)));
    int_T stackSize = (int_T) (*(mxGetPr(STACK_SIZE)));
    
    /* Check priority */
    if( priority < 0 || priority > 255 ) {
        ssSetErrorStatus(S, "Priority must be 0-255.");
	return;
    }
    /* Check stack size */
    if( stackSize <= 0 ) {
        ssSetErrorStatus(S, "Stack size must be >= 0");
	return;
    }
}

static void mdlInitializeSizes(SimStruct *S)
{
    int_T priority;

    ssSetNumSFcnParams(S, 4);
    if (ssGetNumSFcnParams(S) == ssGetSFcnParamsCount(S)) {
        mdlCheckParameters(S);
        if (ssGetErrorStatus(S) != NULL) {
            return;
        }
    } else {
        return; /* Simulink will report a parameter mismatch error */
    }
    ssSetSFcnParamNotTunable( S, 0);
    ssSetSFcnParamNotTunable( S, 1);
    ssSetSFcnParamNotTunable( S, 2);
    ssSetSFcnParamNotTunable( S, 3);
    ssSetNumInputPorts(       S, 0);
    ssSetNumOutputPorts(      S, 1);
    ssSetOutputPortWidth(     S, 0, 1);
    ssSetNumIWork(            S, 0);
    ssSetNumRWork(            S, 0);
    ssSetNumPWork(            S, 0);
    ssSetNumSampleTimes(      S, 1);
    ssSetNumContStates(       S, 0);
    ssSetNumDiscStates(       S, 0);
    ssSetNumModes(            S, 0);
    ssSetNumNonsampledZCs(    S, 0);

    priority  = (int_T) (*(mxGetPr(PRIORITY)));
    ssSetAsyncTaskPriorities(S,1,&priority);

    ssSetOptions(             S, (SS_OPTION_EXCEPTION_FREE_CODE |
                                  SS_OPTION_ASYNCHRONOUS |
                                  SS_OPTION_DISALLOW_CONSTANT_SAMPLE_TIME |
                                  SS_OPTION_FORCE_NONINLINED_FCNCALL));
}

static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, INHERITED_SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0.0);
    ssSetCallSystemOutput(S, 0);
}

static void mdlOutputs(SimStruct *S, int_T tid)
{
    ssCallSystemWithTid(S, 0, tid);
}

static void mdlTerminate(SimStruct *S) {}

#define MDL_RTW
static void mdlRTW(SimStruct *S)
{
    int_T numElements = mxGetNumberOfElements(TASK_NAME);
    int_T numElements1 = mxGetNumberOfElements(TASK_SCHED);
    char *buf,*buf1 = NULL;
    
    if ((buf = malloc(numElements +1)) == NULL) {
        ssSetErrorStatus(S,"memory allocation error in mdlRTW");
        return;
    }
    if ((buf1 = malloc(numElements1 +1)) == NULL) {
        ssSetErrorStatus(S,"memory allocation error in mdlRTW");
        return;
    }
    if (mxGetString(TASK_NAME,buf,numElements+1) != 0) {
        ssSetErrorStatus(S,"mxGetString error in mdlRTW");
        free(buf);
        return;
    }
    if (mxGetString(TASK_SCHED,buf1,numElements1+1) != 0) {
        ssSetErrorStatus(S,"mxGetString error in mdlRTW");
        free(buf1);
        return;
    }

    /* Write out the parameters for this block.*/
    if (!ssWriteRTWParamSettings(S, 4, 
                                 SSWRITE_VALUE_QSTR,"TaskName", buf,
                                 SSWRITE_VALUE_NUM,"Priority",
                                 (real_T) (*(mxGetPr(PRIORITY))),
                                 SSWRITE_VALUE_NUM,"StackSize",
                                 (real_T) (*(mxGetPr(STACK_SIZE))),
                                 SSWRITE_VALUE_QSTR,"TaskSchedule", buf1
                                 )) {
        return; /* An error occurred which will be reported by SL */
    }
    free(buf);
    free(buf1);
}

#include "simulink.c"      /* MEX-file interface mechanism */

/* EOF: osektask.c*/
