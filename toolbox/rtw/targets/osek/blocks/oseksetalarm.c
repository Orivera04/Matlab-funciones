/*
 * $Revision: 1.1 $
 * $RCSfile: oseksetalarm.c,v $
 *
 * Abstract:
 *      OSEK Set Alarm Block.
 *
 * Copyright 2002 The MathWorks, Inc.
 */

#define S_FUNCTION_NAME oseksetalarm
#define S_FUNCTION_LEVEL 2

#define ALARMNAME       (ssGetSFcnParam(S,0))
#define INCREMENT       (ssGetSFcnParam(S,1))
#define CYCLIC          (ssGetSFcnParam(S,2))
#define ALARMTYPE       (ssGetSFcnParam(S,3))
#define CALLATSTARTUP   (ssGetSFcnParam(S,4))

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
    real_T increment = (real_T) (*(mxGetPr(INCREMENT)));
    real_T cyclic = (real_T) (*(mxGetPr(CYCLIC)));
    
    if( increment < 0 || increment > MAX_uint32_T) {
        ssSetErrorStatus(S, "Increment must be 0-MAX_uint32_T");
	return;
    }
    
    if( cyclic < 0 || cyclic > MAX_uint32_T) {
        ssSetErrorStatus(S, "Cyclic must be 0-MAX_uint32_T.");
	return;
    }
}

static void mdlInitializeSizes(SimStruct *S)
{
    ssSetNumSFcnParams(S, 5);
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
    ssSetSFcnParamNotTunable( S, 4);
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
    ssCallSystemWithTid(S, 0, tid);
}

static void mdlTerminate(SimStruct *S) {}

#define MDL_RTW
static void mdlRTW(SimStruct *S)
{
    int_T numElements = mxGetNumberOfElements(ALARMNAME);
    int_T numElements1 = mxGetNumberOfElements(ALARMTYPE);
    int_T numElements2 = mxGetNumberOfElements(CALLATSTARTUP);
    char *buf,*buf1,*buf2 = NULL;
    
    if ((buf = malloc(numElements +1)) == NULL) {
        ssSetErrorStatus(S,"memory allocation error in mdlRTW");
        return;
    }
    if ((buf1 = malloc(numElements1 +1)) == NULL) {
        ssSetErrorStatus(S,"memory allocation error in mdlRTW");
        return;
    }
    if ((buf2 = malloc(numElements2 +1)) == NULL) {
        ssSetErrorStatus(S,"memory allocation error in mdlRTW");
        return;
    }
    if (mxGetString(ALARMNAME,buf,numElements+1) != 0) {
        ssSetErrorStatus(S,"mxGetString error in mdlRTW");
        free(buf);
        return;
    }
    if (mxGetString(ALARMTYPE,buf1,numElements1+1) != 0) {
        ssSetErrorStatus(S,"mxGetString error in mdlRTW");
        free(buf1);
        return;
    }
    if (mxGetString(CALLATSTARTUP,buf2,numElements2+1) != 0) {
        ssSetErrorStatus(S,"mxGetString error in mdlRTW");
        free(buf2);
        return;
    }

    /* Write out the parameters for this block.*/
    if (!ssWriteRTWParamSettings(S, 5, 
                                 SSWRITE_VALUE_QSTR,"AlarmName", buf,
                                 SSWRITE_VALUE_NUM,"Increment",
                                 (real_T) (*(mxGetPr(INCREMENT))),
                                 SSWRITE_VALUE_NUM,"Cyclic",
                                 (real_T) (*(mxGetPr(CYCLIC))),
                                 SSWRITE_VALUE_QSTR,"AlarmType", buf1,
                                 SSWRITE_VALUE_QSTR,"CallAtStartup", buf2
                                 )) {
        return; /* An error occurred which will be reported by SL */
    }
    free(buf);
    free(buf1);
    free(buf2);
}

#include "simulink.c"      /* MEX-file interface mechanism */

/* EOF: oseksetalarm.c*/
