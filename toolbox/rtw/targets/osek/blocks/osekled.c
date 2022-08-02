/*
 * $RCSfile: osekled.c,v $
 *
 * Abstract:
 *   This file provides needed s-function that defines I/O, sampletime for
 *   a simple LED driver block.
 *
 * $Revision: 1.2 $
 *
 * Copyright 2002 The MathWorks, Inc.
 */

#define S_FUNCTION_NAME  osekled
#define S_FUNCTION_LEVEL 2

#define LED_CHOICE       (ssGetSFcnParam(S,0))

#include "simstruc.h" 

/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *   Initialize the sizes array
 */
static void mdlInitializeSizes(SimStruct *S)
{
    /* Set and Check parameter count  */
    ssSetNumSFcnParams(S, 1);
    ssSetSFcnParamNotTunable( S, 0);

    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) return;

    /* Inputs */
    if ( !ssSetNumInputPorts(  S, 1 ) ) return;
            
    ssSetInputPortWidth(             S, 0, 1 );
    ssSetInputPortDataType(          S, 0, SS_BOOLEAN );
    ssSetInputPortDirectFeedThrough( S, 0, true );

    /* outputs */
    if ( !ssSetNumOutputPorts( S, 0 ) ) return;
    
    /* sample times */
    ssSetNumSampleTimes(   S, 1 );
    
    /* options */
    ssSetOptions(S,
                 SS_OPTION_EXCEPTION_FREE_CODE);
} /* end mdlInitializeSizes */


/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    Initialize the sample times array.
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime( S, 0, INHERITED_SAMPLE_TIME );
    ssSetOffsetTime( S, 0, FIXED_IN_MINOR_STEP_OFFSET );
    
} /* end mdlInitializeSampleTimes */

/* Function: mdlOutputs =======================================================
 * Abstract:
 *   Compute the outputs of the S-function.
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
} /* end mdlOutputs */


/* Function: mdlTerminate =====================================================
 * Abstract:
 *    Called when the simulation is terminated.
 */
static void mdlTerminate(SimStruct *S)
{
} /* end mdlTerminate */

#define MDL_RTW
static void mdlRTW(SimStruct *S)
{
    int_T numElements = mxGetNumberOfElements(LED_CHOICE);
    char *buf = NULL;
    
    if ((buf = malloc(numElements +1)) == NULL) {
        ssSetErrorStatus(S,"memory allocation error in mdlRTW");
        return;
    }
    if (mxGetString(LED_CHOICE,buf,numElements+1) != 0) {
        ssSetErrorStatus(S,"mxGetString error in mdlRTW");
        free(buf);
        return;
    }

    /* Write out the parameters for this block.*/
    if (!ssWriteRTWParamSettings(S, 1, 
                                 SSWRITE_VALUE_QSTR,"LedChoice", buf
                                 )) {
        return; /* An error occurred which will be reported by SL */
    }
    free(buf);
}
/*=======================================*
* Required closing for C MEX S-Function *
*=======================================*/

#ifdef    MATLAB_MEX_FILE  /* Is this file being compiled as a MEX-file? */
# include "simulink.c"     /* MEX-file interface mechanism               */
#else
# error This_file_can_be_used_only_during_simulation_inside_Simulink
#endif
