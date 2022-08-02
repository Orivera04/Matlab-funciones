/*  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc. */

/*  $Revision: 1.3.4.4 $ */

/*
 * You must specify the S_FUNCTION_NAME as the name of your S-function
 * (i.e. replace sfuntmpl with the name of your S-function).
 */

#define S_FUNCTION_LEVEL 2
#define S_FUNCTION_NAME  mvCubicEvalSFnV2

/*
 * Need to include simstruc.h for the definition of the SimStruct and
 * its associated macro definitions.
 */

#include "simstruc.h"
#include "mvcubiceval_helper.h"

enum { E_ORDER=0, E_REORDER, E_INTERACT };
#define P_NPARMS 3

#define PTR_ORDER(S)    ssGetSFcnParam(S,E_ORDER)
#define PTR_REORDER(S)  ssGetSFcnParam(S,E_REORDER)       

#define P_INTERACT      ((int)mxGetScalar(ssGetSFcnParam(S,E_INTERACT)))
#define P_ORDER         mxGetPr(ssGetSFcnParam(S,E_ORDER))
#define P_REORDER       mxGetPr(ssGetSFcnParam(S,E_REORDER))

#define P_NORDER        mxGetNumberOfElements(PTR_ORDER(S))
#define P_NREORDER      mxGetNumberOfElements(PTR_REORDER(S))

#define ORDER           &ssGetIWork(S)[0]
#define REORDER         &ssGetIWork(S)[P_NORDER]

#define COEFF_IDX       0
#define INPUT_IDX       1

/* Error handling
 * --------------
 *
 * You should use the following technique to report errors encountered within
 * an S-function:
 *
 *       ssSetErrorStatus(S,"Error encountered due to ...");
 *       return;
 *
 * Note that the 2nd argument to ssSetErrorStatus must be persistent memory.
 * It cannot be a local variable. For example the following will cause
 * unpredictable errors:
 *
 *      mdlOutputs()
 *      {
 *         char msg[256];         {ILLEGAL: to fix use "static char msg[256];"}
 *         sprintf(msg,"Error due to %s", string);
 *         ssSetErrorStatus(S,msg);
 *         return;
 *      }
 *
 * See matlabroot/simulink/src/sfunctmpl.doc for more details.
 */

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

    /* See sfuntmpl.doc for more details on the macros below */

    ssSetNumSFcnParams(S, P_NPARMS);  /* Number of expected parameters */
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        /* Return if number of expected != number of actual parameters */
        return;
    }

    // Tunable parameters will get passed down to code generation 
    ssSetSFcnParamTunable(S, E_INTERACT, false);
    ssSetSFcnParamTunable(S, E_ORDER, false);
    ssSetSFcnParamTunable(S, E_REORDER, false);

    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 0);

    // Setup Input ports
    if (!ssSetNumInputPorts(S, 2)) return;

    // model coefficients
    {
      ssSetInputPortDataType(S, COEFF_IDX, SS_DOUBLE);
      ssSetInputPortWidth(S, COEFF_IDX, DYNAMICALLY_SIZED);
      ssSetInputPortDirectFeedThrough(S, COEFF_IDX, 1);
      ssSetInputPortRequiredContiguous(S, COEFF_IDX, 1);
    }   

    // input factor
    {
      ssSetInputPortDataType(S, INPUT_IDX, SS_DOUBLE);
      ssSetInputPortWidth(S, INPUT_IDX, P_NREORDER);
      ssSetInputPortDirectFeedThrough(S, INPUT_IDX, 1);
      ssSetInputPortRequiredContiguous(S, INPUT_IDX, 1);
    }

    if (!ssSetNumOutputPorts(S, 1)) return;
    // output
    {
      ssSetOutputPortDataType(S, 0, SS_DOUBLE);
      ssSetOutputPortWidth(S, 0, 1);
    }

    ssSetNumSampleTimes(S, 1);
    ssSetNumRWork(S, DYNAMICALLY_SIZED);
    ssSetNumIWork(S, DYNAMICALLY_SIZED);
    ssSetNumPWork(S, 0);
    ssSetNumModes(S, 0);
    ssSetNumNonsampledZCs(S, 0);

    ssSetOptions(S, SS_OPTION_USE_TLC_WITH_ACCELERATOR);
}

#if defined(MATLAB_MEX_FILE)
#define MDL_SET_INPUT_PORT_WIDTH
static void mdlSetInputPortWidth(SimStruct *S, int_T port, int_T inputPortWidth)
{
  ssSetInputPortWidth(S,port,inputPortWidth);
}

#define MDL_SET_OUTPUT_PORT_WIDTH
static void mdlSetOutputPortWidth(SimStruct *S, int_T port, int_T outputPortWidth)
{
  ssSetOutputPortWidth(S, 0, 1);
}

#define MDL_SET_WORK_WIDTHS
static void mdlSetWorkWidths(SimStruct *S)
{
  ssSetNumRWork(S, 2*ssGetInputPortWidth(S, INPUT_IDX)); // need to store X and Xi
  ssSetNumIWork(S, P_NORDER+P_NREORDER);
}
#endif /* MATLAB_MEX_FILE */

/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    This function is used to specify the sample time(s) for your
 *    S-function. You must register the same number of sample times as
 *    specified in ssSetNumSampleTimes.
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, INHERITED_SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0.0);
}

#define MDL_INITIALIZE_CONDITIONS   /* Change to #undef to remove function */
#if defined(MDL_INITIALIZE_CONDITIONS)
  /* Function: mdlInitializeConditions ========================================
   * Abstract:
   *    In this function, you should initialize the continuous and discrete
   *    states for your S-function block.  The initial states are placed
   *    in the state vector, ssGetContStates(S) or ssGetRealDiscStates(S).
   *    You can also perform any other initialization activities that your
   *    S-function may require. Note, this routine will be called at the
   *    start of simulation and if it is present in an enabled subsystem
   *    configured to reset states, it will be call when the enabled subsystem
   *    restarts execution to reset the states.
   */
  static void mdlInitializeConditions(SimStruct *S)
  {

    int i;
    int currIndex;

    const double *order  =P_ORDER;
    const double *reorder=P_REORDER;

    // store order vector
    currIndex=0;
    for(i=0; i<P_NORDER; i++) {
      ssSetIWorkValue(S,currIndex++,(int) *order++);
    }
    for(i=0; i<P_NREORDER; i++) {
      ssSetIWorkValue(S,currIndex++,(int) *reorder++);
    }
  }
#endif /* MDL_INITIALIZE_CONDITIONS */



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

/* Function: mdlOutputs =======================================================
 * Abstract:
 *    In this function, you compute the outputs of your S-function
 *    block. Generally outputs are placed in the output vector, ssGetY(S).
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
        double yi;
        int nx, i, maxInteraction;
        int currPosition=0;

        int *reorder=REORDER;
        int *order=ORDER;

        const real_T* coeff = ssGetInputPortRealSignal(S,COEFF_IDX);
        const real_T* input = ssGetInputPortRealSignal(S,INPUT_IDX);
        int numInputs = ssGetInputPortWidth(S,INPUT_IDX);
        real_T* output = ssGetOutputPortRealSignal(S,0);

        /* Get the work vector for the reordered input factors*/
        real_T *X = ssGetRWork(S);

        /* Reorder the input X */
        for (i = 0; i < numInputs; i++) {
          X[i] = input[reorder[i]-1];
        }  

        // Note : maxInteraction is an indexing value and hence has to be zero
        // based and not one based as in MATLAB
        maxInteraction=P_INTERACT-1;
                
        yi = recursiveEval(coeff[0], 0, 0, X, order, coeff, maxInteraction, &currPosition);

        // Do we need to evaluate higher order terms?
        for (i = maxInteraction+1, nx = 0; i < P_NORDER; i++) {
          nx += order[i];
        }

        if (nx > 0) {
          yi = higherOrderEval(yi, P_NORDER, numInputs, X+numInputs, X, order, coeff, maxInteraction, &currPosition);
        }

        // Put the result in the output vector
        *output= yi;
}

#undef MDL_UPDATE  /* Change to #undef to remove function */
#if defined(MDL_UPDATE)
  /* Function: mdlUpdate ======================================================
   * Abstract:
   *    This function is called once for every major integration time step.
   *    Discrete states are typically updated here, but this function is useful
   *    for performing any tasks that should only take place once per
   *    integration step.
   */
  static void mdlUpdate(SimStruct *S, int_T tid)
  {
  }
#endif /* MDL_UPDATE */



#undef MDL_DERIVATIVES  /* Change to #undef to remove function */
#if defined(MDL_DERIVATIVES)
  /* Function: mdlDerivatives =================================================
   * Abstract:
   *    In this function, you compute the S-function block's derivatives.
   *    The derivatives are placed in the derivative vector, ssGetdX(S).
   */
  static void mdlDerivatives(SimStruct *S)
  {
  }
#endif /* MDL_DERIVATIVES */



/* Function: mdlTerminate =====================================================
 * Abstract:
 *    In this function, you should perform any actions that are necessary
 *    at the termination of a simulation.  For example, if memory was
 *    allocated in mdlStart, this is the place to free it.
 */
static void mdlTerminate(SimStruct *S)
{
}


/*======================================================*
 * See sfuntmpl_doc.c for the optional S-function methods *
 *======================================================*/

#undef MDL_RTW
#if defined(MDL_RTW) && (defined(MATLAB_MEX_FILE) || defined(NRT))
static void mdlRTW(SimStruct *S) {
  int interact=P_INTERACT;

  if (!ssWriteRTWParamSettings(S, 3,
                               SSWRITE_VALUE_DTYPE_VECT, "order", P_ORDER, P_NORDER, DTINFO(SS_DOUBLE,0),  
                               SSWRITE_VALUE_DTYPE_VECT, "reorder", P_REORDER, P_NREORDER, DTINFO(SS_DOUBLE,0),
                               SSWRITE_VALUE_DTYPE_NUM, "interact", &interact, DTINFO(SS_INT32,0)
                               )) {
    ssSetErrorStatus(S,"Error writing parameter data to .rtw file");
    return;
  }
}
#endif /* MDL_RTW */

/*=============================*
 * Required S-function trailer *
 *=============================*/

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
