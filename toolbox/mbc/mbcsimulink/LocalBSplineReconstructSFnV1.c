/*  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc. */

/*  $Revision: 1.2.4.2 $ */

/*
* You must specify the S_FUNCTION_NAME as the name of your S-function
* (i.e. replace sfuntmpl with the name of your S-function).
*/

#define S_FUNCTION_LEVEL 2
#define S_FUNCTION_NAME  LocalBSplineReconstructSFnV1

#define NUMKNOTS		ssGetSFcnParam(S,0)
#define FEATINDEX		ssGetSFcnParam(S,1)
#define POLY_ORDER		ssGetSFcnParam(S,2)
#define LIMITS			ssGetSFcnParam(S,3)

/*
* Need to include simstruc.h for the definition of the SimStruct and
* its associated macro definitions.
*/
#include "simstruc.h"
#include <malloc.h>
#include "xregsimulinkutils.h"


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
static
void mdlInitializeSizes(SimStruct *S)
{
    /* See sfuntmpl.doc for more details on the macros below */
	
	// Get input port sizes
	int numKnots = (int) *mxGetPr(NUMKNOTS);
	int numParam = mxGetNumberOfElements(FEATINDEX);

    ssSetNumSFcnParams(S, 4);  /* Number of expected parameters */
	
	/* Return if number of expected != number of actual parameters */
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        return;
    }
    
    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 0);
    
    ssSetNumInputPorts(S, 2);
    
    ssSetInputPortWidth(S, 0, numKnots);
    ssSetInputPortDirectFeedThrough(S, 0, 1);

    ssSetInputPortWidth(S, 1, numParam);
    ssSetInputPortDirectFeedThrough(S, 1, 1);

    ssSetNumOutputPorts(S, 1);  
    ssSetOutputPortWidth(S, 0, numParam*numParam);
    
    ssSetNumSampleTimes(S, 1);
    ssSetNumRWork(S, 1);
    ssSetNumIWork(S, 0);
    ssSetNumPWork(S, 4); /* We will set up pointers to: K, B0, B1 */
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
    return;
}

#if defined(MATLAB_MEX_FILE)
# define MDL_SET_INPUT_PORT_WIDTH
static
void mdlSetInputPortWidth(SimStruct *S, int_T port, int_T inputPortWidth)
{
}

# define MDL_SET_OUTPUT_PORT_WIDTH
static
void mdlSetOutputPortWidth(SimStruct *S, int_T port, int_T outputPortWidth)
{
}
#endif

#undef MDL_INITIALIZE_CONDITIONS   /* Change to #undef to remove function */
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
static
void mdlInitializeConditions(SimStruct *S)
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
static void
mdlStart(SimStruct *S)
{
    /* Set up the pointer work vectors */
    /*
     * get the inputs parameters for s (poly_order) and Nk (number of knots)
     */
    int poly_order = (int) *mxGetPr(POLY_ORDER);
    int num_knots  = (int) *mxGetPr(NUMKNOTS);
	
    /*
     * Get the PWork vector
     */
    void** PWork = ssGetPWork(S);
	
    /*
     * Create the Knot pos vector(K)
     */
    double* K = (double *) calloc( 2*(poly_order + 1) + num_knots,sizeof(double) );	
    /*
     * Create the blank B0 and B1 matrices
     */
    double* B0 = (double *) calloc( (2*poly_order + num_knots),sizeof(double) );
    double* B1 = (double *) calloc( (2*poly_order + num_knots),sizeof(double) );

    real_T* KN = (real_T *) malloc( num_knots * sizeof(real_T) );

    PWork[0]= K;
    PWork[1]= B0;
    PWork[2]= B1;
    PWork[3]= KN;

    return;
}
#endif /*  MDL_START */



/* Function: mdlOutputs =======================================================
* Abstract:
*    In this function, you compute the outputs of your S-function
*    block. Generally outputs are placed in the output vector, ssGetY(S).
*/
static
void mdlOutputs(SimStruct *S, int_T tid)
{
    /* Get the knots */
    InputRealPtrsType in0 = ssGetInputPortRealSignalPtrs(S, 0);
    int numKnots = ssGetInputPortWidth(S, 0);

    /* Get the X values */
    InputRealPtrsType in1 = ssGetInputPortRealSignalPtrs(S,1);
    int numX = ssGetInputPortWidth(S,1);

    /* Get the output vector y */
    real_T* out = ssGetOutputPortRealSignal(S,0);
	
    /* Get the R & P work vectors */
    real_T* x		= ssGetRWork(S);
	double* K		= (double *)ssGetPWorkValue(S, 0);
	double* B0		= (double *)ssGetPWorkValue(S, 1);
	double* B1		= (double *)ssGetPWorkValue(S, 2);
	double* knots	= (double *)ssGetPWorkValue(S, 3);	
	
	// get the limits of the range e.g. [-1 1]
	double* limits	= mxGetPr(LIMITS);

    /* Get the SFunction Parameters */
    int      poly_order = (int) *mxGetPr(POLY_ORDER);
    double * featIndex  = mxGetPr(FEATINDEX);
	int		 RFparam;
    int      i, j;
    
    /* Pointer to the PHI matrix */
    double * PHI;
         
    /* Run the PHI_CALC routine....*/ 
	for ( i = 0; i < numX; i++, featIndex++ ) {
		
		/* Should we evaluate phi_calc for this particular output
		 * or is it just zeros and one
		 */
		if ( *featIndex <= numX + numKnots ) {
			
			RFparam = (int)*featIndex - numKnots - 1;
			for ( j = 0; j < numX; j++ )
				if ( j ==  RFparam )
					*out++ = 1;
				else
					*out++ = 0;
		} else {

			for ( j = 0; j < numKnots; j++ )
				knots[j] = *in0[j];

			// Set the Knot positions
			SetKnot(K, poly_order, knots, numKnots, limits);

			PHI = phi_calc(poly_order, *in1[i], numKnots, K, B0, B1, limits);
			
			for ( j = 0; j < numX; j++ )
				*out++ = *PHI++;
		}
	
	}
    
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
	/* Get the PWork vector pointer */
    void **PWork = ssGetPWork(S);
	
    /* free the PWork vector */
    free(PWork[0]);
    free(PWork[1]);
    free(PWork[2]);
    free(PWork[3]);
    return;
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
