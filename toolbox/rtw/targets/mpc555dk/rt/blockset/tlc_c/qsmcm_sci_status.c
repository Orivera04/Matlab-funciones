/*
 * File: qsmcm_sci_status.c
 *
 * Abstract:
 *   Read data within the QSMCM SCI status register
 *
 * $Revision: 1.1.6.1 $
 * $Date: 2004/01/22 18:22:14 $
 *
 * Copyright 2004 The MathWorks, Inc.
 */

#define S_FUNCTION_NAME qsmcm_sci_status
#define S_FUNCTION_LEVEL 2

/*
 * Need to include simstruc.h for the definition of the SimStruct and
 * its associated macro definitions.
 */
#include "simstruc.h"

/*=============================
 * Externally defined functions
 *=============================*/

/*====================*
 * Parameters
 *===================*/

enum { E_SAMPLE_TIME=0, E_MODULE, P_NPARMS };

#define P_SAMPLE_TIME      mxGetScalar(ssGetSFcnParam(S,E_SAMPLE_TIME))
#define P_MODULE           mxGetScalar(ssGetSFcnParam(S,E_MODULE))

/* -----OPTIONAL FUNCTIONS-------------------------------------- */

/*====================*
 * S-function methods *
 *====================*/

/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *    The sizes information is used by Simulink to determine the S-function
 *    block's characteristics (number of inputs, outputs, states, etc.).
 */
static void mdlInitializeSizes(SimStruct *S)
{
        int idx;

        ssSetNumSFcnParams(S, P_NPARMS);  /* Number of expected parameters */
        // No parameters will be tunable
        for(idx=0; idx<P_NPARMS; idx++){
                ssSetSFcnParamNotTunable(S,idx);
        }

        if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
                /* Return if number of expected != number of actual parameters */
                return;
        }

        if (!ssSetNumInputPorts(S, (int_T) 0)) return;

        if (!ssSetNumOutputPorts(S, (int_T) 1)) return;

        ssSetOutputPortWidth(S,0,1);
        ssSetOutputPortOptimOpts(S,0, SS_REUSABLE_AND_LOCAL);
        ssSetOutputPortDataType (S,0,SS_BOOLEAN);

        ssSetNumContStates(S, 0);
        ssSetNumDiscStates(S, 0);


        ssSetNumSampleTimes(S, 1);
        ssSetNumRWork(S, 0);
        ssSetNumIWork(S, 0);
        ssSetNumPWork(S, 0);
        ssSetNumModes(S, 0);
        ssSetNumNonsampledZCs(S, 0);

        ssSetOptions(S, SS_OPTION_DISALLOW_CONSTANT_SAMPLE_TIME);
}

/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    This function is used to specify the sample time(s) for your
 *    S-function. You must register the same number of sample times as
 *    specified in ssSetNumSampleTimes.
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, P_SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0.0);
}

#undef MDL_START  /* Change to #undef to remove function */
#if defined(MDL_START) 
/* Function: mdlStart =======================================================
 * Abstract:
 *    This function is called once at start of model execution. If you
 *    have states that should be initialized once, this is the place
 *    to do it.
 */
static void mdlStart(SimStruct *S)
{
}
#endif /*  MDL_START */



#define U(element) (*uPtrs[element])  /* Pointer to Input Port0 */
#define UT(type,element) (*((type *)uPtrs[element])) /* Pointer to Input Port0 */

/* Function: mdlOutputs =======================================================
 * Abstract:
 *    In this function, you compute the outputs of your S-function
 *    block. Generally outputs are placed in the output vector, ssGetY(S).
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{

}

/* Function: mdlTerminate =====================================================
 * Abstract:
 *    In this function, you should perform any actions that are necessary
 *    at the termination of a simulation.  For example, if memory was
 *    allocated in mdlStart, this is the place to free it.
 */
static void mdlTerminate(SimStruct *S)
{
}


#define MDL_RTW  /* Change to #undef to remove function */
#if defined(MDL_RTW) && (defined(MATLAB_MEX_FILE) || defined(NRT))
static void mdlRTW(SimStruct *S)
{
    ssWriteRTWParamSettings(S,2,
                            SSWRITE_VALUE_NUM,
                            "SampleTime",
                            P_SAMPLE_TIME,
                            SSWRITE_VALUE_NUM,
                            "Module", 
                            P_MODULE
	);
}
#endif

/*======================================================*
 * See sfuntmpl_doc.c for the optional S-function methods *
 *======================================================*/

/*=============================*
 * Required S-function trailer *
 *=============================*/

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif



