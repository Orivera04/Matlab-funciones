/*  File    : saeroatmcoesa.c
 *  Abstract:
 *
 *      A level 2 S-function to calculate atmospheric pressure, 
 *      temperature, and density models.  Uses the following 
 *      function files in common with MATLAB .mex utility for 
 *      producing pressure data suitable for use in tables:
 *
 *      Standard                         C file
 *      -------------------------------  ----------------------
 *      COESA-extended 1976 ISA          aeroatmcoesa.c
 *
 *
 *  Notes:
 *
 *  xxx need range check options
 *  xxx need more methods (MIL-STD-310B, MIL-STD-210C)
 *
 *  Copyright 1990-2004 The MathWorks, Inc.
 *  $Revision: 1.5.2.2 $
 *
 *  Author:  R. Aberg   29-May-2000
 *  Modified: S. Gage   27-Nov-2001
 */


#define S_FUNCTION_NAME  saeroatmcoesa
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"

#include "aeroatm.h" 
#include "aeroatmcoesa.h"  

/* Parameters for this block */

#define NUM_SPARAMS    0 

typedef struct SFcnCache_tag {
    boolean_T  below_min;  /* flag denoting if altitude went below zero */
    boolean_T  over_max;   /* flag denoting if altitude went above 84528 */   
} SFcnCache;

/* Function: CheckHeightCOESA ==============================================
 * Abstract:
 *   Check height and warn once if output values are extrapolated.
 *
 */
void fcn_CheckHeightCOESA(SimStruct *S,
                          const double *altitude, 
		          int numPoints,
                          SFcnCache *udata)

{ 
    static const char *AltMsg = "Height is outside the range of 0 meters "
                          "and 84852 meters.  Output values "
                          "will be extrapolated.";

    int i;

        for ( i = 0; i < numPoints; i++ ){
            if (( altitude[i] >= 0.0 ) && (altitude[i] <= 84528.0 )){
                /* do nothing */
            }
            else {
                if ( (!udata->below_min) && (!udata->over_max)){
                    udata->below_min = true;
                    udata->over_max = true;
                    ssSetUserData(S, udata);

                    ssWarning(S, AltMsg);
                }
           }

        }

    return;
}

/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *   Checks parameters and does setup on sizes of the various vectors.
 */

static void mdlInitializeSizes(SimStruct *S)
{
    ssSetNumSFcnParams(S,NUM_SPARAMS);   /* expected number */

    ssSetNumContStates( S, 0 );
    ssSetNumDiscStates( S, 0 );

    ssSetNumInputPorts(S, 1);
    ssSetInputPortWidth(S, 0, DYNAMICALLY_SIZED);
    ssSetInputPortDirectFeedThrough(S, 0, 1);
    ssSetInputPortRequiredContiguous(S, 0, 1);

    ssSetNumOutputPorts(S, 4);
    ssSetOutputPortWidth(S, 0, DYNAMICALLY_SIZED); /* temperature */
    ssSetOutputPortWidth(S, 1, DYNAMICALLY_SIZED); /* speed of sound */
    ssSetOutputPortWidth(S, 2, DYNAMICALLY_SIZED); /* pressure     */
    ssSetOutputPortWidth(S, 3, DYNAMICALLY_SIZED); /* density     */

    ssSetModelReferenceSampleTimeDefaultInheritance(S);

    return;
}


/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    Specifiy that we inherit our sample time from the driving block.
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, INHERITED_SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0);
}


/* Function: mdlStart =========================================================
 * Abstract:
 *   Store information about height limits in user data and
 *   Initialize pressure and temperature tables. 
 */
#define MDL_START
static void mdlStart(SimStruct *S)
{
    static const char *msg = "Could not allocate data cache memory";
    SFcnCache   *udata;

    /*
     * Allocate memory blocks for UserData.
     */

    udata = (SFcnCache *) malloc( sizeof(SFcnCache) );
    if (udata == NULL) {
        ssSetErrorStatus(S, msg);
        goto EXIT_POINT;
    }

    /*
     * === Populate the cache members ==========
     */

    udata->below_min = false;
    udata->over_max  = false;

    /* 
     * Set the cached data into the user data area for 'this' block.
     */

    ssSetUserData( S, udata );

    /* 
     * Initialize pressure and temperature tables.
     */

    InitCalcAtmosCOESA();

 EXIT_POINT:
    return;
}
 

/* Function: mdlOutputs =======================================================
 * Abstract:
 *    CassGetInputPortSignallculate base relationship for pressure
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
    SFcnCache *udata = ssGetUserData(S);
    const double *alt = (const double *) ssGetInputPortSignal(S,0);
    double *T   = (double *) ssGetOutputPortRealSignal(S,0);
    double *SoS = (double *) ssGetOutputPortRealSignal(S,1);
    double *P   = (double *) ssGetOutputPortRealSignal(S,2);
    double *rho = (double *) ssGetOutputPortRealSignal(S,3);
    int     k   = ssGetInputPortWidth(S,0);


    fcn_CheckHeightCOESA(S,alt,k,udata);

    CalcAtmosCOESA(alt,T,P,rho,SoS,k);
  
}


/* Function: mdlTerminate =====================================================
 * Abstract:
 *    
 */
static void mdlTerminate(SimStruct *S)
{    

    SFcnCache *udata = ssGetUserData(S);

    free( ( void *)udata );
    ssSetUserData(S, NULL);

    return;
 
}

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif







