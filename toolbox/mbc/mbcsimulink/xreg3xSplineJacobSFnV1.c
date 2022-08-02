/*  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc. */

/* $Revision: 1.3.4.2 $ */

/*
* You must specify the S_FUNCTION_NAME as the name of your S-function
* (i.e. replace sfuntmpl with the name of your S-function).
*/

#define S_FUNCTION_LEVEL 2
#define S_FUNCTION_NAME  xreg3xSplineJacobSFnV1

//#define COEFFS ssGetSFcnParam(S,0)
#define ORDER ssGetSFcnParam(S,0)
#define REORDER ssGetSFcnParam(S,1)
#define KNOTS ssGetSFcnParam(S,2)
#define POLY_ORDER ssGetSFcnParam(S,3)
#define INTERACT ssGetSFcnParam(S,4)

/*
* Need to include simstruc.h for the definition of the SimStruct and
* its associated macro definitions.
*/
#include "simstruc.h"
#include <malloc.h>
#include "xregsimulinkutils.h"


void DoPhiLoop(real_T ** J, double * phi, int phiC, double x);
void DoXLoop(real_T ** J, double x, double x1, int c);

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
	
    ssSetNumSFcnParams(S, 5);  /* Number of expected parameters */
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        /* Return if number of expected != number of actual parameters */
        return;
    }
	
    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 0);
	
	ssSetNumInputPorts(S, 2);
	
    ssSetInputPortWidth(S, 0, DYNAMICALLY_SIZED);
    ssSetInputPortDirectFeedThrough(S, 0, 1);
	
    ssSetInputPortWidth(S, 1, mxGetNumberOfElements(REORDER));
    ssSetInputPortDirectFeedThrough(S, 1, 1);
	
	ssSetNumOutputPorts(S, 1);
	
    ssSetOutputPortWidth(S, 0, DYNAMICALLY_SIZED);
	
    ssSetNumSampleTimes(S, 1);
    ssSetNumRWork(S, DYNAMICALLY_SIZED);
    ssSetNumIWork(S, 0);
    ssSetNumPWork(S, 3); /* We will set up pointers to: K, B0, B1 */
    ssSetNumModes(S, 0);
    ssSetNumNonsampledZCs(S, 0);
	
    ssSetOptions(S, 0);
}

#if defined(MATLAB_MEX_FILE)
# define MDL_SET_INPUT_PORT_WIDTH
  static void mdlSetInputPortWidth(SimStruct *S, int_T port,
                                   int_T inputPortWidth)
  {
     ssSetInputPortWidth(S,port,inputPortWidth);
  }

#define MDL_SET_OUTPUT_PORT_WIDTH
  static void mdlSetOutputPortWidth(SimStruct *S, int_T port, int_T outputPortWidth)
  {
     ssSetOutputPortWidth(S, 0, ssGetInputPortWidth(S,0));
  }

#define MDL_SET_WORK_WIDTHS 
static void mdlSetWorkWidths(SimStruct *S){
	int width = ssGetInputPortWidth(S,1);
	ssSetNumRWork(S, width);
}

#endif


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
	/* Set up the pointer work vectors */
	// get the inputs parameters for s (poly_order) and Nk (number of knots)
	int poly_order = (int) mxGetPr(POLY_ORDER)[0];
	int num_knots  = mxGetNumberOfElements(KNOTS);
	double* knots  = mxGetPr(KNOTS);
	// Get the PWork vector
	void ** PWork = ssGetPWork(S);
	
	// Create the Knot pos vector(K)
	double *K = (double *)calloc( 2*(poly_order + 1)+ num_knots, sizeof(double) );	
	// Create the blank B0 and B1 matrices
	double *B0 = (double *) calloc( (2*poly_order + num_knots), sizeof(double) );
	double *B1 = (double *) calloc( (2*poly_order + num_knots), sizeof(double) );
	double limits[2] = {-1.0, 1.0};
	PWork[0] = K;
	PWork[1] = B0;
	PWork[2] = B1;

	// Set the Knot positions
	SetKnot(K, poly_order, knots, num_knots, limits);
}
#endif /*  MDL_START */



/* Function: mdlOutputs =======================================================
* Abstract:
*    In this function, you compute the outputs of your S-function
*    block. Generally outputs are placed in the output vector, ssGetY(S).
*/
static void mdlOutputs(SimStruct *S, int_T tid)
{
	/* Get the input signal */
	InputRealPtrsType in = ssGetInputPortRealSignalPtrs(S,1);
	int width = ssGetInputPortWidth(S,1);
	
	/* Get the output vector y */
	real_T *J= ssGetOutputPortRealSignal(S,0);
	
	/* Get the work vector r */
	real_T *x  = ssGetRWork(S);
	double *tx = x;
	
	/* Get the SFunction Parameters */
	double *n		= mxGetPr(ORDER);
	double *reorder = mxGetPr(REORDER);
	double *knots	= mxGetPr(KNOTS);
	int poly_order	= (int) mxGetPr(POLY_ORDER)[0];
	int interact	= (int) mxGetPr(INTERACT)[0];
	int numKnots	= mxGetNumberOfElements(KNOTS);
	int i,j,k, phiC;
	
	double Ji, Jj, *xi, *xj, *xk, *phi, *Jt;

	double *K  = ssGetPWorkValue(S,0);
	double *B0 = ssGetPWorkValue(S,1);
	double *B1 = ssGetPWorkValue(S,2);
	double limits[2] = {-1.0, 1.0};

	/* Reorder the input X */
	for (i = 0; i < width; i++)
		*tx++ = *in[(int)(*reorder++ - 1)];
	
	/* Run the PHI_CALC routine....*/ 
	phi = phi_calc(poly_order, *x, numKnots, K, B0, B1, limits);

	phiC = poly_order + numKnots + 1;

	// initalise xi
	xi = x;
	Jt = J;
	DoPhiLoop(&J, phi, phiC, 1);

	// First order terms
	for (i = 0;i < (int)n[0]; i++)
	{
		// iniitalise xj
		xj = xi++;
		if ( interact>0 )
			DoPhiLoop(&J, phi, phiC, *xi);
		else
			DoXLoop(&J, *xi, *x, 3);
		Ji = *xi;
		//second order terms
		for (j = i; j< (int)n[1]; j++)
		{
			//initialise xk
			xk = xj++;
			if ( interact>1 )
				DoPhiLoop(&J, phi, phiC, (Ji)*(*xj) );
			else
				DoXLoop(&J, (Ji)*(*xj), *x, 2);
			Jj = (Ji)*(*xj);
			//third order terms
			for (k = j; k < (int)n[2]; k++)
			{
				xk++;
				*J++ = (Jj) * (*xk);
			}
		}// End of the j (Second order terms) loop
	}// End of i (First order) loop.		


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
	/* Get the PWork vector pointer */
	void **PWork = ssGetPWork(S);
	
	/* free the PWork vector */
	free(PWork[0]);
	free(PWork[1]);
	free(PWork[2]);

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


// *************** DOPHILOOP routine ********************
void DoPhiLoop(real_T ** pJ, double * phi, int phiC, double x)
{
	int c;
	double * tphi = phi;
	double * J = *pJ;
	
	for(c=0;c<phiC;c++)
		*J++ = (*tphi++) * x;
	*pJ = J;
}

// *************** DOPHILOOP routine ********************
void DoXLoop(real_T ** pJ, double x, double x1, int c)
{
	int i;
	double t = 1;
	double * J = *pJ;

	for(i=0;i<c;i++)
	{
		*J++ = x*t;
		t *= x1;
	}
	*pJ = J;
}
