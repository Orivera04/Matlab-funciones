/*
 * $Revision: 1.1 $
 * $RCSfile: osekcounter.c,v $
 *
 * Abstract:
 *      OSEK Counter Block.
 *
 * Copyright 2002 The MathWorks, Inc.
 */

#define S_FUNCTION_NAME osekcounter
#define S_FUNCTION_LEVEL 2

#define MAXALLOWED      (ssGetSFcnParam(S,0))
#define MINCYCLE        (ssGetSFcnParam(S,1))
#define TICKSPERBASE    (ssGetSFcnParam(S,2))
#define TIME_IN_NS      (ssGetSFcnParam(S,3))

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
    real_T maxallowed  = (real_T)(*(mxGetPr(MAXALLOWED)));
    real_T mincycle = (real_T) (*(mxGetPr(MINCYCLE)));
    real_T ticksperbase = (real_T) (*(mxGetPr(TICKSPERBASE)));
    real_T timeinns = (real_T) (*(mxGetPr(TIME_IN_NS)));
    
    if( maxallowed < 0 || maxallowed > MAX_uint32_T) {
        ssSetErrorStatus(S, "MAXALLOWEDVALUE must be 0-MAX_uint32_T");
	return;
    }
    
    if( mincycle < 0 || mincycle > MAX_uint32_T) {
        ssSetErrorStatus(S, "MINCYCLE must be 0-MAX_uint32_T.");
	return;
    }
    
    if( ticksperbase < 0 || ticksperbase > MAX_uint32_T) {
        ssSetErrorStatus(S, "TICKSPERBASE must be 0-MAX_uint32_T.");
	return;
    }
    
    if( timeinns < 0 || timeinns > MAX_uint32_T) {
        ssSetErrorStatus(S, "TIME_IN_NS must be 0-MAX_uint32_T.");
	return;
    }
}

static void mdlInitializeSizes(SimStruct *S)
{
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
    ssSetOptions(             S, (SS_OPTION_EXCEPTION_FREE_CODE));
}

static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, INHERITED_SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0.0);
    ssSetCallSystemOutput(S, 0);
}

static void mdlOutputs(SimStruct *S, int_T tid)
{
}

static void mdlTerminate(SimStruct *S) {}

#define MDL_RTW
static void mdlRTW(SimStruct *S)
{
    /* Write out the parameters for this block.*/
    if (!ssWriteRTWParamSettings(S, 4, 
                                 SSWRITE_VALUE_NUM,"MaxAllowed",
                                 (real_T) (*(mxGetPr(MAXALLOWED))),
                                 SSWRITE_VALUE_NUM,"MinCycle",
                                 (real_T) (*(mxGetPr(MINCYCLE))),
                                 SSWRITE_VALUE_NUM,"TicksPerBase",
                                 (real_T) (*(mxGetPr(TICKSPERBASE))),
                                 SSWRITE_VALUE_NUM,"Time_in_ns",
                                 (real_T) (*(mxGetPr(TIME_IN_NS)))
                                 )) {
        return; /* An error occurred which will be reported by SL */
    }
}

#include "simulink.c"      /* MEX-file interface mechanism */

/* EOF: osekcounter.c*/
