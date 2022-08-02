/* 
 * File: sfun_enforce_real.c
 *
 * Abstract:
 *   S-Function to enforce real datatype, i.e. single or double
 *   In simulation the input is propagated directly to the output
 *   but the block is designed to throw an error if the input is
 *   not either a double or a single precision real. The output
 *   datatype is inherited from the input.
 *
 * $Revision: 1.7.4.2 $
 * $Date: 2004/04/19 01:30:16 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 */

/*
 * You must specify the S_FUNCTION_NAME as the name of your S-function.
 */

#define S_FUNCTION_NAME  sfun_enforce_real
#define S_FUNCTION_LEVEL 2


/* define error messages */
#define ERR_INVALID_SET_INPUT_DTYPE_CALL  \
              "Invalid call to mdlSetInputPortDataType"

#define ERR_INVALID_DTYPE     "Invalid input port data type: the input signal data type must be either double or single"

/*
 * Need to include simstruc.h for the definition of the SimStruct and
 * its associated macro definitions.
 */
#include "simstruc.h"

/* Set up S-Function Parameters */
typedef enum {
  NUM_PARAMS
} ParamIdx;


/*=====================================*
 * Configuration and execution methods *
 *=====================================*/

/* Function: mdlInitializeSizes ===============================================
 */
static void mdlInitializeSizes(SimStruct *S)
{
    /* This block should be removed from the compiled model if possible */
    ssSetBlockReduction(S, true);

    /* Number of expected parameters */
    ssSetNumSFcnParams(S, NUM_PARAMS);
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        /* Invalid number of S-Function parameters */
        return;
    }

    /* Register the number and type of states the S-Function uses */
    ssSetNumContStates(S, 0);   /* number of continuous states */
    ssSetNumDiscStates(S, 0);   /* number of discrete states   */

    /*
     * Configure the input ports. First set the number of input ports. 
     */
    if (!ssSetNumInputPorts(S, 1)) return;    

    /* Input port 1 */
    if(!ssSetInputPortDimensionInfo(S, 0, DYNAMIC_DIMENSION)) return;
    ssSetInputPortDataType(S, 0, DYNAMICALLY_TYPED);
    ssSetInputPortComplexSignal(S, 0, COMPLEX_INHERITED);
    ssSetInputPortFrameData(S, 0, FRAME_INHERITED);
    ssSetInputPortSampleTime(S, 0, INHERITED_SAMPLE_TIME);
    ssSetInputPortDirectFeedThrough(S, 0, true);
    ssSetInputPortAcceptExprInRTW(S, 0, true);
    ssSetInputPortRequiredContiguous(S, 0, true);
    ssSetInputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
    ssSetInputPortOverWritable(S, 0, 1);

    /*
     * Configure the output ports. First set the number of output ports.
     */
    if (!ssSetNumOutputPorts(S, 0)) return;

    /*
     * Set the number of sample times.
     * 
     * NOTE:
     * - To do proper error checking of sample times, we should be using 
     *   PORT_BASED_SAMPLE_TIMES. However, this forces the output signal to be 
     *   global so it can not be reused or folded (using expression folding).
     * - The mdlSetInputPortSampleTime & mdlSetOutputPortSampleTime functions
     *   are ignored when using block-based sample times.
     * 
     * ssSetNumSampleTimes(S, PORT_BASED_SAMPLE_TIMES); 
     *
     */
    ssSetNumSampleTimes(S, 1); /* number of sample times */

    /*
     * Set size of the work vectors.
     */
    ssSetNumRWork(         S, 0);   /* number of real work vector elements   */
    ssSetNumIWork(         S, 0);   /* number of integer work vector elements*/
    ssSetNumPWork(         S, 0);   /* number of pointer work vector elements*/
    ssSetNumModes(         S, 0);   /* number of mode work vector elements   */
    ssSetNumNonsampledZCs( S, 0);   /* number of nonsampled zero crossings   */

    /*
     * Set options.
     * See matlabroot/simulink/include/simstruc.h for details.
     */

    ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE |
                    SS_OPTION_REQ_INPUT_SAMPLE_TIME_MATCH|
                    SS_OPTION_NONVOLATILE);

} /* end mdlInitializeSizes */


/* Function: mdlInitializeSampleTimes =========================================
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    /* Register one pair for each sample time */
    ssSetSampleTime(S, 0, INHERITED_SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0.0);

} /* end mdlInitializeSampleTimes */


/* Function: mdlOutputs =======================================================
 * Abstract:
 *    In this function, you compute the outputs of your S-function
 *    block. Generally outputs are placed in the output vector(s),
 *    ssGetOutputPortSignal.
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
} /* end mdlOutputs */


/* Function: mdlTerminate =====================================================
 */
static void mdlTerminate(SimStruct *S)
{
}


/* Function: mdlSetWorkWidths ===============================================
 * Abstract:
 *    Set up run-time parameters.
 */
#define MDL_SET_WORK_WIDTHS
static void mdlSetWorkWidths(SimStruct *S)
{
    ssSetNumRunTimeParams(S, 0);
}


/* Function: mdlRTW ===========================================================
 * Abstract:
 *      Write out enableSimPassThru parameter for RTW usage.
 */
//#define MDL_RTW
//static void mdlRTW(SimStruct *S)
//{
    /* Add non-tunable parameters */

//    if (!ssWriteRTWParamSettings( S, 1,
//                                  SSWRITE_VALUE_NUM, "EnablePassThru",
//                                  mxGetScalar(ENABLE_PASS_THRU(S)))) {
//        return;
//    }
//    return;
//}


#ifdef MATLAB_MEX_FILE

/* Function: isAcceptableDataType
 *    determine if the data type ID corresponds to a double or 
 *    single precision float
 */
static boolean_T isAcceptableDataType(DTypeId dataType) 
{
    boolean_T isAcceptable = (dataType == SS_DOUBLE || 
                              dataType == SS_SINGLE );
    
    return isAcceptable;
}

#define MDL_SET_INPUT_PORT_DATA_TYPE
/* Function: mdlSetInputPortDataType ==========================================
 *    This routine is called with the candidate data type for a dynamically
 *    typed port.  If the proposed data type is acceptable, the routine should
 *    go ahead and set the actual port data type using ssSetInputPortDataType.
 *    If the data tyoe is unacceptable an error should generated via
 *    ssSetErrorStatus.  Note that any other dynamically typed input or
 *    output ports whose data types are implicitly defined by virtue of knowing
 *    the data type of the given port can also have their data types set via 
 *    calls to ssSetInputPortDataType or ssSetOutputPortDataType.
 */
static void mdlSetInputPortDataType(SimStruct *S, 
                                    int       port, 
                                    DTypeId   dataType)
{
    if (port==0) {
        if( isAcceptableDataType( dataType ) ) {
            /*
             * Accept proposed data type if it is a single or double
             * precision real.
             */
            ssSetInputPortDataType(  S, 0, dataType );            
        } else {
            /* Reject proposed data type */
            ssSetErrorStatus(S,ERR_INVALID_DTYPE);
            goto EXIT_POINT;
        }
    } else {
        /* 
         * Should not end up here.  Simulink will only call this function
         * for existing input ports whose data types are unknown.
         */
        ssSetErrorStatus(S, ERR_INVALID_SET_INPUT_DTYPE_CALL);
        goto EXIT_POINT;
    }
    
  EXIT_POINT:
    return;
} /* mdlSetInputPortDataType */

#endif /* MATLAB_MEX_FILE */



/*=============================*
 * Required S-function trailer *
 *=============================*/

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
