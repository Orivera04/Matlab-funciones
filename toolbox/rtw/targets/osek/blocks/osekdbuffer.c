/* 
 * $Revision: 1.2 $
 * $RCSfile: osekdbuffer.c,v $
 *
 * Abstract:
 *      OSEK Asynchronous Double Block for RTW.
 *
 * Copyright 2002 The MathWorks, Inc.
 */

#define S_FUNCTION_NAME osekdbuffer
#define S_FUNCTION_LEVEL 2

#define BUFFER_SIDE     (ssGetSFcnParam(S,0))
#define SAMPLE_TIME     (ssGetSFcnParam(S,1))

#include "tmwtypes.h"
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
    const char *msg = NULL;
    ssSetErrorStatus(S,msg);
}

static void mdlInitializeSizes(SimStruct *S)
{
    ssSetNumSFcnParams(S, 2);
    if (ssGetNumSFcnParams(S) == ssGetSFcnParamsCount(S)) {
        mdlCheckParameters(S);
        if (ssGetErrorStatus(S) != NULL) {
            return;
        }
    } else {
        return; /* Simulink will report a parameter mismatch error */
    }
    ssSetSFcnParamNotTunable(        S, 0);
    ssSetSFcnParamNotTunable(        S, 1);
    ssSetNumInputPorts(              S, 1);
    ssSetInputPortWidth(             S, 0, DYNAMICALLY_SIZED);
    ssSetInputPortDirectFeedThrough( S, 0, 1);
    ssSetInputPortDataType(          S, 0, DYNAMICALLY_TYPED);
    ssSetInputPortComplexSignal(     S, 0, COMPLEX_NO);
    ssSetInputPortFrameData(         S, 0, FRAME_NO);
    ssSetNumOutputPorts(             S, 1);
    ssSetOutputPortWidth(            S, 0, DYNAMICALLY_SIZED);
    ssSetOutputPortDataType(         S, 0, DYNAMICALLY_TYPED);
    ssSetOutputPortComplexSignal(    S, 0, COMPLEX_NO);
    ssSetOutputPortFrameData(        S, 0, FRAME_NO);
    ssSetNumDWork(                   S, DYNAMICALLY_SIZED);
    ssSetNumSampleTimes(             S, 1);
    ssSetNumContStates(              S, 0);
    ssSetNumDiscStates(              S, 0);
    ssSetNumModes(                   S, 0);
    ssSetNumNonsampledZCs(           S, 0);
    ssSetOptions(                    S, (SS_OPTION_EXCEPTION_FREE_CODE |
                                         SS_OPTION_ASYNC_RATE_TRANSITION));
}

static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, (mxGetPr(SAMPLE_TIME)[0]));
    ssSetOffsetTime(S, 0, 0.0);
}

static void mdlOutputs(SimStruct *S, int_T tid)
{
    int_T         j;
    int_T         dTypeId   = ssGetInputPortDataType(S, 0);
    int_T         dTypeSize = ssGetDataTypeSize(S, dTypeId);
    char_T        *y        = (char_T *)ssGetOutputPortSignal(S, 0);
    InputPtrsType u         = ssGetInputPortSignalPtrs(S,0);
    int_T         width     = ssGetInputPortWidth(S,0);

    /* For simulation, copy data through to output */
    for (j = 0; j < width; j++) {
        memcpy(y, u[j], dTypeSize);
           y += dTypeSize;
    }
}  

static void mdlTerminate(SimStruct *S){}

#define MDL_SET_INPUT_PORT_DATA_TYPE   /* Change to #undef to remove function */
#if defined(MDL_SET_INPUT_PORT_DATA_TYPE) && defined(MATLAB_MEX_FILE)
/* Function: mdlSetInputPortDataType ========================================= */
static void mdlSetInputPortDataType(SimStruct *S, int portIndex,DTypeId dType)
{
    ssSetInputPortDataType(S, 0, dType);
    ssSetOutputPortDataType(S, 0, dType);
}
#endif /* MDL_SET_INPUT_PORT_DATA_TYPE */


#define MDL_SET_OUTPUT_PORT_DATA_TYPE  /* Change to #undef to remove function */
#if defined(MDL_SET_OUTPUT_PORT_DATA_TYPE) && defined(MATLAB_MEX_FILE)
/* Function: mdlSetOutputPortDataType ========================================
 */
static void mdlSetOutputPortDataType(SimStruct *S,int portIndex,DTypeId dType)
{
    ssSetInputPortDataType(S, 0, dType);
    ssSetOutputPortDataType(S, 0, dType);
 }
#endif /* MDL_SET_OUTPUT_PORT_DATA_TYPE */

#define MDL_SET_WORK_WIDTHS
static void mdlSetWorkWidths(SimStruct *S)
{
    char_T str[20];
    mxGetString(BUFFER_SIDE, str, 20);
    if (!strcmp("WRITE",str)) {
        ssSetNumDWork(S,0);
    }
    else if (!strcmp("READ",str)) {
        if (!ssSetNumDWork(S, 5)) return;
        ssSetDWorkWidth(        S, 0, ssGetInputPortWidth(S,0));
        ssSetDWorkDataType(     S, 0, ssGetInputPortDataType(S,0));
        ssSetDWorkComplexSignal(S, 0, ssGetInputPortComplexSignal(S,0));
        ssSetDWorkName(         S, 0, "Buffer0"); 
        
        ssSetDWorkWidth(        S, 1, 1);
        ssSetDWorkDataType(     S, 1, SS_INT8);
        ssSetDWorkComplexSignal(S, 1, ssGetInputPortComplexSignal(S,0));
        ssSetDWorkName(         S, 1, "Reading"); 
        
        ssSetDWorkWidth(        S, 2, 1);
        ssSetDWorkDataType(     S, 2, SS_INT8);
        ssSetDWorkComplexSignal(S, 2, ssGetInputPortComplexSignal(S,0));
        ssSetDWorkName(         S, 2, "Writing"); 
        
        ssSetDWorkWidth(        S, 3, 1);
        ssSetDWorkDataType(     S, 3, SS_INT8);
        ssSetDWorkComplexSignal(S, 3, ssGetInputPortComplexSignal(S,0));
        ssSetDWorkName(         S, 3, "Last"); 
        
        ssSetDWorkWidth(        S, 4, 2);
        ssSetDWorkDataType(     S, 4, SS_POINTER);
        ssSetDWorkComplexSignal(S, 4, ssGetInputPortComplexSignal(S,0));
        ssSetDWorkName(         S, 4, "BufPtrs"); 
    }
    else {
        ssSetErrorStatus(S,"invalid BUFFER_SIDE");
    }
}

#undef MDL_RTW
static void mdlRTW(SimStruct *S){}

/*=============================*
 * Required S-function trailer *
 *=============================*/

#include "simulink.c"      /* MEX-file interface mechanism */

/* EOF: osekdbuffer.c*/
