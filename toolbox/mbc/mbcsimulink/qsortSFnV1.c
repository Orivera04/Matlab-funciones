/*  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc. */

/* $Revision: 1.2.4.2 $ */

/*
* You must specify the S_FUNCTION_NAME as the name of your S-function
* (i.e. replace sfuntmpl with the name of your S-function).
*/

#define S_FUNCTION_LEVEL 2
#define S_FUNCTION_NAME  qsortSFnV1

/*
* Need to include simstruc.h for the definition of the SimStruct and
* its associated macro definitions.
*/
#include "simstruc.h"
#include <malloc.h>

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
	
    ssSetNumSFcnParams(S, 0);  /* Number of expected parameters */
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        /* Return if number of expected != number of actual parameters */
        return;
    }
    
    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 0);
    
    ssSetNumInputPorts(S, 1);
    
    ssSetInputPortWidth(S, 0, DYNAMICALLY_SIZED);
    ssSetInputPortDirectFeedThrough(S, 0, 1);

    ssSetNumOutputPorts(S, 1);  
    ssSetOutputPortWidth(S, 0, DYNAMICALLY_SIZED);
    
    ssSetNumSampleTimes(S, 1);
    ssSetNumRWork(S, 0);
    ssSetNumIWork(S, 0);
    ssSetNumPWork(S, 0); /* We will set up pointers to: K, B0, B1 */
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
	ssSetInputPortWidth(S, port, inputPortWidth);
}

# define MDL_SET_OUTPUT_PORT_WIDTH
static
void mdlSetOutputPortWidth(SimStruct *S, int_T port, int_T outputPortWidth)
{
	// -1 means that the input is still DYNAMICALLY_SIZED and so we 
	// need to have a better guess at the output size
    if ( ssGetInputPortWidth(S, 0) < 1 ) {
		ssSetOutputPortWidth(S, port, outputPortWidth);
	} else {
		ssSetOutputPortWidth(S, port, ssGetInputPortWidth(S, 0));
	}
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
}
#endif /*  MDL_START */

// *************** compare routine ********************
int compare( const void *arg1, const void *arg2 )
{
	double d1 = * (double*) arg1;
	double d2 = * (double*) arg2;

	if (d1 < d2)
		return -1;
	if (d1 == d2)
		return 0;
	
	return 1;
}


/* Function: mdlOutputs =======================================================
* Abstract:
*    In this function, you compute the outputs of your S-function
*    block. Generally outputs are placed in the output vector, ssGetY(S).
*/
static
void mdlOutputs(SimStruct *S, int_T tid)
{
    /* Get the knots */
    InputRealPtrsType pIN = ssGetInputPortRealSignalPtrs(S, 0);
    int lenIN = ssGetInputPortWidth(S, 0);


    /* Get the output vector y */
    real_T * pOUT = ssGetOutputPortRealSignal(S,0);
	int i;
	
	/* Copy the knots to the output */
	for (i = 0; i < lenIN; i++)
		pOUT[i] = *pIN[i];

	/* Sort the knots into the right order */
	qsort(pOUT, lenIN, sizeof(double), compare);
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




