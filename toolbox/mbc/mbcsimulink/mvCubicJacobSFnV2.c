/*  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc. */

/*  $Revision: 1.4.4.3 $ */

/*
 * You must specify the S_FUNCTION_NAME as the name of your S-function
 * (i.e. replace sfuntmpl with the name of your S-function).
 */

#define S_FUNCTION_LEVEL 2
#define S_FUNCTION_NAME  mvCubicJacobSFnV2

#define ORDER     ssGetSFcnParam(S,0)
#define REORDER   ssGetSFcnParam(S,1)
#define INTERACT  ssGetSFcnParam(S,2)

/*
 * Need to include simstruc.h for the definition of the SimStruct and
 * its associated macro definitions.
 */
#include "simstruc.h"


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

    ssSetNumSFcnParams(S, 3);  /* Number of expected parameters */
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        /* Return if number of expected != number of actual parameters */
        return;
    }

    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 0);

	// Setup Input ports
	ssSetNumInputPorts(S, 2);
	// Port 1 is the coefficients of the model
    ssSetInputPortWidth(S, 0, DYNAMICALLY_SIZED);
    ssSetInputPortDirectFeedThrough(S, 0, 1);
 	
	// Port 2 is the factor input
	ssSetInputPortWidth(S, 1, mxGetNumberOfElements(REORDER));
    ssSetInputPortDirectFeedThrough(S, 1, 1);
 
	ssSetNumOutputPorts(S, 1);
    ssSetOutputPortWidth(S, 0, DYNAMICALLY_SIZED);

    ssSetNumSampleTimes(S, 1);
    ssSetNumRWork(S, DYNAMICALLY_SIZED);
    ssSetNumIWork(S, 0);
    ssSetNumPWork(S, 0);
    ssSetNumModes(S, 0);
    ssSetNumNonsampledZCs(S, 0);

    ssSetOptions(S, 0);
}



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

#if defined(MATLAB_MEX_FILE)
#define MDL_SET_INPUT_PORT_WIDTH
  static void mdlSetInputPortWidth(SimStruct *S, int_T port, int_T inputPortWidth)
  {
     ssSetInputPortWidth(S,port,inputPortWidth);
  }

#define MDL_SET_OUTPUT_PORT_WIDTH
  static void mdlSetOutputPortWidth(SimStruct *S, int_T port, int_T outputPortWidth)
  {
     ssSetOutputPortWidth(S, 0, ssGetInputPortWidth(S,0));
  }

#define MDL_SET_WORK_WIDTHS
  static void mdlSetWorkWidths(SimStruct *S)
  {
  	int numC = ssGetInputPortWidth(S,0);
	int numX = ssGetInputPortWidth(S,1);
	int mord = (int) *mxGetPr(INTERACT);
	// Set space for work vectors 
	if (mord < 1)
		mord = 1;
	/*
	 * This vector contains space for the reordered factors and the vector
	 * output. It also contains space for the iterative use of the function
	 * recursive eval. Note that mord could be 0 and hence needs to be made
	 * 1 to allow space for the output
	 */
	ssSetNumRWork(S, (numX) + (mord*numC));
  }
#endif

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
  }
#endif /* MDL_INITIALIZE_CONDITIONS */



#define MDL_START  /* Change to #undef to remove function */
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

const double * X;
const double * N;
double * FX;
int MORD;
int NUM_COEFFS;

/*
 * Recursive function based on i_recurse in xregcubic/eval
 * This function will be using global variables X, N, MAX_INTERACT
 * to evaluate the polynomial
 */
static int recursiveEval(int lvl, int st)
{
	int i, j, n;
	int p = 0;
	double Xi;
	// Local FX storage
	double * lFX = FX + lvl*NUM_COEFFS;
	// Next level down FX storage 
	double * nFX = FX + (lvl + 1) * NUM_COEFFS;
	
	//memset(lFX, 0, NUM_COEFFS*sizeof(double));

	*lFX = 1;

	for (i = st; i < (int) N[lvl]; i++) {
		Xi = X[i];
		lFX[++p] = Xi;
		if (lvl < MORD) {
			n = recursiveEval(lvl+1, i);
			for (j = 1; j < n; j++) {
				lFX[++p] = Xi * nFX[j];
			}
		} 
	}
	return ++p;
}

/*
 * Function to evaluate those terms in the polynomial that exceed
 * the MAX INTERACTION level. This function should be called immediately
 * after the recursiveEval function above, because it uses the same set
 * of global variables, especially the integer p.
 */
static void higherOrderEval(int nx, int maxOrder, int numFactors, double * Xi)
{
	int i;
	int j;
	const double * lX;
	double * lXi;
	double * lFX = FX + NUM_COEFFS - nx;

	// Get a local copy of the input factors for iteration
	
	for (i = 0, lXi = Xi; i < numFactors; i++)
		*lXi++ = 1;

	for (i = 0; i < maxOrder; i++) {
		// Multiply every member of Xi by X - Xi = Xi.*X
		for (j = 0, lX = X, lXi = Xi; j < numFactors; j++)
			(*lXi++) *= (*lX++);
		if (i > MORD) {
			for (j = 0, lXi = Xi; j < N[i]; j++) {
				*lFX++ = *lXi++;
			}
		}
	}
}

/*
 * Function that correctly sets up the global parameters used in the
 * recursive evaluation function above
 */
static void initialiseRecursiveEval(SimStruct *S, double * reorder)
{
	X			= reorder;
	N			= mxGetPr(ORDER);
	// Note : MORD is an indexing value and hence has to be zero
	// based and not one based as in MATLAB
	MORD		= (int) *mxGetPr(INTERACT)-1;
	NUM_COEFFS	= ssGetInputPortWidth(S,0);
	FX			= ssGetRWork(S) + ssGetInputPortWidth(S,1);
}
/* Function: mdlOutputs =======================================================
 * Abstract:
 *    In this function, you compute the outputs of your S-function
 *    block. Generally outputs are placed in the output vector, ssGetY(S).
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
	/* Get the SFunction Parameters */
	double *reorder = mxGetPr(REORDER);
	
	/* Set some temporary variables*/
	double yi;
	int maxOrder, nx;
	int i;

	/* Get the input factors */
	InputRealPtrsType in = ssGetInputPortRealSignalPtrs(S,1);
	int nFactors = ssGetInputPortWidth(S,1);
	
	/* Get the output vector y */
	real_T *y= ssGetOutputPortRealSignal(S,0);
	
	/* Get the work vector for the reordered input factors*/
	real_T *x = ssGetRWork(S);
	double *tx;
		
	/* Reorder the input X */
	for (i = 0, tx = x; i < nFactors; i++)
		*tx++ = *in[(int)(*reorder++ - 1)];

	maxOrder = mxGetN(ORDER)*mxGetM(ORDER);
	
	initialiseRecursiveEval(S, x);
	recursiveEval(0, 0);
	
	// Do we need to evaluate higher order terms?
	for (i = MORD+1, nx = 0; i < maxOrder; i++) {
		nx += (int)N[i];
	}
	if (nx > 0) {
		higherOrderEval(nx, maxOrder, nFactors, x+nFactors);
	}
	// Put the result in the output vector
	memcpy(y, FX, NUM_COEFFS * sizeof(double));
}

#define MDL_UPDATE  /* Change to #undef to remove function */
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



#define MDL_DERIVATIVES  /* Change to #undef to remove function */
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
 * See sfuntmpl.doc for the optional S-function methods *
 *======================================================*/

/*=============================*
 * Required S-function trailer *
 *=============================*/

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
