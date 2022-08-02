/*  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc. */

/*  $Revision: 1.2.4.2 $ */

/*
* You must specify the S_FUNCTION_NAME as the name of your S-function
* (i.e. replace sfuntmpl with the name of your S-function).
*/

#define S_FUNCTION_LEVEL 2
#define S_FUNCTION_NAME  mv3xsplineEvalSFnV1

#define COEFFS ssGetSFcnParam(S,0)
#define ORDER ssGetSFcnParam(S,1)
#define REORDER ssGetSFcnParam(S,2)
#define KNOTS ssGetSFcnParam(S,3)
#define POLY_ORDER ssGetSFcnParam(S,4)
#define INTERACT ssGetSFcnParam(S,5)

/*
* Need to include simstruc.h for the definition of the SimStruct and
* its associated macro definitions.
*/
#include "simstruc.h"
#include <malloc.h>
/* Function prototypes */
static void SetKnot(double *K, int s, double *knots, int sizek);
static void SetInit(double *X,double *xget,int os, int sizek, int sizex, double *K);
static double* phi_calc(SimStruct *S,double *knots, int s,double *xget);
static void eval_loop(SimStruct *S, double *x,double *phi,double *c,double *n, 
			   int interact, int phiC, double *y);

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
	
    ssSetNumSFcnParams(S, 6);  /* Number of expected parameters */
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        /* Return if number of expected != number of actual parameters */
        return;
    }
	
    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 0);
	
	ssSetNumInputPorts(S, 1);
    /*if (!ssSetNumInputPorts(S, 1)) return;*/
	
    ssSetInputPortWidth(S, 0, DYNAMICALLY_SIZED);
    ssSetInputPortDirectFeedThrough(S, 0, 1);
	
	ssSetNumOutputPorts(S, 1);
    /*if (!ssSetNumOutputPorts(S, 1)) return;*/
	
    ssSetOutputPortWidth(S, 0, 1);
	
    ssSetNumSampleTimes(S, 1);
    ssSetNumRWork(S, DYNAMICALLY_SIZED);
    ssSetNumIWork(S, 0);
    ssSetNumPWork(S, 3); /* We will set up pointers to: K, B0, B1 */
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
#define MDL_SET_WORK_WIDTHS 

static void mdlSetWorkWidths(SimStruct *S){
	int width = ssGetInputPortWidth(S,0);
	ssSetNumRWork(S,width);
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
	/* Set up the pointer work vectors */
	// get the inputs parameters for s (poly_order) and Nk (number of knots)
	int s= (int) mxGetPr(POLY_ORDER)[0];
	int Nk = (int) mxGetN(KNOTS)*mxGetM(KNOTS);
	double *knots = mxGetPr(KNOTS);
	// Get the PWork vector
	void ** PWork = ssGetPWork(S);
	
	// Create the Knot pos vector(K)
	double *K = (double *)calloc( 2*(s+1)+Nk,sizeof(double) );	
	// Create the blank B0 and B1 matrices
	double *B0 = (double *) calloc((2*s+Nk),sizeof(double));
	double *B1 = (double *) calloc( (2*s+Nk),sizeof(double) );
	PWork[0]=K;
	PWork[1]= B0;
	PWork[2]= B1;

	// Set the Knot positions
	SetKnot(K,s,knots,Nk);
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
	InputRealPtrsType in = ssGetInputPortRealSignalPtrs(S,0);
	int width = ssGetInputPortWidth(S,0);
	
	/* Get the output vector y */
	real_T *y= ssGetOutputPortRealSignal(S,0);
	
	/* Get the work vector r */
	real_T *x= ssGetRWork(S);
	double *tx= x;
	
	/* Get the SFunction Parameters */
	double *c=			mxGetPr(COEFFS);
	double *n=			mxGetPr(ORDER);
	double *reorder=	mxGetPr(REORDER);
	double *knots=		mxGetPr(KNOTS);
	int poly_order=	(int) mxGetPr(POLY_ORDER)[0];
	int interact=	(int) mxGetPr(INTERACT)[0];
	int i, phiC;
	int lengthK = mxGetN(KNOTS)*mxGetM(KNOTS);
	
	/* Pointer to the PHI matrix */
	double *PHI;
	
	/* Reorder the input X */
	for (i=0;i<width;i++)
		*tx++ = *in[(int)(*reorder++ - 1)];
	
	/* Run the PHI_CALC routine....*/ 
	 PHI = phi_calc(S,knots,poly_order,x);

	/* Run the EVAL_LOOP routine... */
	phiC = poly_order + lengthK + 1;
	eval_loop(S,x,PHI,c,n,interact, phiC,y);	
//void eval_loop(SimStruct *S, double *x,double *phi,double *c,double *n, int interact, double *y);

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



// USER DEFINED ROUTINES...

static void eval_loop(SimStruct *S, double *x,double *phi,double *c,
			   double *n, int interact, int phiC, double *y)
{
	// create some intermediate variables
	double yi, yj, *tc=c, *xiplus1, *xjplus1, *xkplus1, *tphi;
	int i,j,k;

	*y=0;
	tphi= phi;
	for (i=0;i<phiC;i++)
		*y += (*tphi++)*(*tc++);	// y(:)=phi*c(i3:i3+Ns-1)
	// At this point, tc=c+1*Ns
	// reset the counter.
	tphi=phi;
	
	// I have expanded the original code, so that logical tests are only done
	// once. It is also easier to increment the pointer tc this way.
	
	if (interact == 0){
		xiplus1=x+1;// i starts at zero
		for (i=0;i<(int)n[0];i++){
			// Yi(:) = c(i3)+x(:,1).*(c(i3+1) + x(:,1)*c(i3+2));
			yi = *tc + *x *(*(tc+1) + *(tc+2)*(*x));
			tc +=3;			
			
			xjplus1= x+ (i+1);// j starts at i
			for (j=i;j<(int)n[1];j++){ // J loop.
				// Yj = c(i3) + x(:,1).*c(i3+1);
				yj = *tc + (*x)*(*(tc+1));
				tc+=2;				
				xkplus1= x + (j+1);//this sets up x(:,k+1); k starts at j

				for (k=j;k<(int)n[2];k++) // K loop
					// Yj(:)= Yj + c(i3)*x(:,k+1);
					yj += (*tc++)*(*(xkplus1++));
				// yi(:)=yi+x(:,j+1).*yj
				yi += (*xjplus1++)*(yj); 
				// Clean up temporary yj;
				yj = 0;
			}
			*y += *(xiplus1++)*(yi); // y(:) = y + x(:,i+1).*yi
			// Clean up temporary yi;
			yi = 0;
		}
	}// END OF 'IF' statement for case interact == 0
	
	else if(interact == 1){
		xiplus1=x+1;// i starts at zero
		for (i=0;i<(int)n[0];i++){	// I Loop

			// yi(:)=phi*c(i3:i3+Ns-1);
			for (j=0;j<phiC;j++)
				yi += *(tphi++)*(*tc++); 
			
			// reset the counter.
			tphi=phi;
			xjplus1=x+(i+1);//j starts at i

			for (j=i;j<(int)n[1];j++){	// J LOOP
				yj = *tc + *x*(*(tc+1));
				tc+=2;
				xkplus1= x + (j+1);//this sets up x(:,k+1); k starts at j

				for (k=j;k<(int)n[2];k++) // K loop
					// Yj(:)= Yj + c(i3)*x(:,k+1);
					yj += (*tc++)*(*(xkplus1++));
				// yi(:)=yi+x(:,j+1).*yj
				yi += *(xjplus1++)*(yj); 
				// Clean up temporary yj;
				yj = 0;
			}
			// y(:) = y + x(:,i+1).*yi
			*y += *(xiplus1++)*(yi); 
			// Clean up temporary yi;
			yi = 0;
		}
	}// END OF 'IF' statement for case interact == 1
	
	else if(interact >1){
		xiplus1=x+1;
		for (i=0;i<(int)n[0];i++){	// I Loop
			for (j=0;j<phiC;j++)
				// y(:)=phi*c(i3:i3+Ns-1);
				yi += (*tphi++)*(*tc++);	
			tphi=phi;
			xjplus1= x + (i+1);

			for (j=i;j<(int)n[1];j++){	// J LOOP
				for (k=0;k<phiC;k++)
					// y(:)=phi*c(i3:i3+Ns-1)
					yj += (*tphi++)*(*tc++);	
				tphi=phi;
				xkplus1= x + (j+1);

				for (k=j;k<(int)n[2];k++) // K loop
					yj += (*tc++)*(*(xkplus1++));
				
				yi += *(xjplus1++)*(yj); // yi(:)=yi+x(:,j+1).*yj

				// Clean up temporary yj;
				yj = 0;
			}
			// y(:) = y + x(:,i+1).*yi
			*y += *(xiplus1++)*(yi); 
			// Clean up temporary yi;
			yi = 0;
		}
	}// END OF 'IF' statement for case interact >1
	
}// End of routine.



// *************** PHI_CALC routine ********************
static double* phi_calc(SimStruct *S, double *knots, int s,double *xget)
{
	int Nk = mxGetN(KNOTS);
	int Nx=1;
	int os=s+1,L=1;
	double *K= ssGetPWorkValue(S,0);
	double *B0= ssGetPWorkValue(S,1);
	double *B1= ssGetPWorkValue(S,2);
	
	// Loop variables
	int i,j; 
	double delK, Ki, Kj;
	// tempory pointers for loops
	double *tB0, *tB1 , *tK, *tx;
	int sfinal = 2*s + Nk + 1;
	
	// Set up the initial B0
	SetInit(B0,xget,s+1,Nk,Nx,K);
	
	// recursive section...
	for (j=1;j<s+1;j++){
		// initialise tK to start of K
		tK=K;
		// swap B0 and B1 for next iteration
		tB0 = B0;
		tB1 = B1;
		B0  = B1;
		B1  = tB0;
		for (i=0 ;i<sfinal-j;i++) {			
		/*
		* Note that pointer increments mean that:
		*   tB0= B0 + Nx*i;  // at the start of each i iteration;
		*   tB1= B1 + Nx*i;  // at the start of each i iteration;
			*/			
			delK= *(tK+j) - *tK;
			if (delK != 0.0){
			/* 
			* The following loop does a vectorised version of 
			* B1[i] = (x - K[i])/(K[i+j]-K[i]) * B0[i]
				*/
				// Ki is a temporary static for K[i]
				Ki = *tK;
				// set tx to the top of X
				//tx = xget;
				*tB1 = (*xget - Ki)/delK * (*tB0);
			}
			else {
				// need to set B1[i] = 0
				*tB1 = 0.0;
				// also increment tB0 here so it is B0[i+1]
			}
			tB0++;
			
			// increment tK here as we need K[i+j+1] and K[i+1]
			tK++;
			delK= *(tK+j) - *tK;
			if (delK != 0.0){
				/* 
				* The following loop does a vectorised version of 
				* B1[i] =  B1[i] + (K[i+j+1]-x)/(K[i+j+1]-K[i+1]) * B0[i+1]
				*/
				// Kj is a temporary static for K[i+j+1]
				Kj  = *(tK+j);
				// set tx to the top of X
				*tB1 += (Kj - (*xget))/delK * (*tB0);
			}
			tB1++;
			
		}  // for i		
	} // for j


	return B0;
}

// *************** SETINIT routine ********************
static void SetInit(double *X,double *xget,int os, int sizek, int sizex, double *K)
{
	int i;
	double *tX=X;	// set the pointer to the correct position
	double *tx=xget,*tK=K+os-1;
	
	for (i=0; i<os-1 ; i++)
		*tX++ = 0.0;


	for (i=os-1;i<os+sizek;i++){
		if (*tx<-1)
			*tX++ = (*tK > -1) ? 0:1;
		else if(*tx >= 1)
			*tX++ = (*(tK+1) == 1) ? 1:0;
		else if ( (*tK <= *tx) && (*tx < *(tK +1)) )
			*tX++ =1.0;
		else
			*tX++=0.0;
		tK++;
	}
}

// *************** SETKNOT routine ********************
static void SetKnot(double *K, int s, double *knots, int sizek)
{
	// This routine will set the Knot position vector to be:
	// K = [-ones(sizes+1);knots(:);ones(s+1,1)]
	// 3 FOR loops seem like a good idea?? FOR loops are quick mate!
		double *tknots=knots,*tK=K;
	int i;
	for (i=0;i<s+1;i++)
		*tK++ = -1;
	for (i=0;i<sizek;i++)
		*tK++ = *tknots++;
	for (i=0;i<s+1;i++)
		*tK++ = 1;
}
