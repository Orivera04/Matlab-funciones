/*  File    : saeropalt.c
 *  Abstract:
 *
 *      A level 2 S-function to calculate pressure altitude.
 *      Uses the following function files in common with MATLAB 
 *      .mex utility:
 *
 *      Standard                         C file
 *      -------------------------------  ----------------------
 *      COESA-extended 1976 ISA          aeroatmcoesa.c
 *
 *
 *  Copyright 1990-2004 The MathWorks, Inc.
 *  $Revision: 1.1.6.3 $
 *
 *  Author:  R. Aberg   29-May-2000
 *  Modified: S. Gage   27-Nov-2001
 */


#define S_FUNCTION_NAME  saeropalt
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"

#include "aeroatm.h" 
#include "aeroatmcoesa.h"  
#include "aeroatmosstruct.h"

/* Parameters for this block */

#define PRES_LOW  0.3961

/* utility macros */

#define OK2GET_PARAM(p)    (!mxIsEmpty(p))
#define IS_OKREAL_PARAM(p) (!mxIsEmpty(p) && !mxIsComplex(p) && mxIsNumeric(p) && (mxGetClassID(p)==mxDOUBLE_CLASS))

typedef enum { ACTION_IDX=0, NPARAMS  } ParamIdx;

#define ACTION_PARAM(S) ssGetSFcnParam(S,ACTION_IDX)

/* Function: CheckPressueCOESA ==============================================
 * Abstract:
 *   Check height and warn once if output values are extrapolated.
 *
 */
void fcn_CheckPressureCOESA(SimStruct *S,
                          const double *pressure, 
		          int numPoints,
                          SFcnCache *udata)

{ 
    static const char *PMsg = "Pressure is outside the range of 0.3961 Pa to "
                      "101325 Pa. Output altitude will be extrapolated.";

    static const char *PEMsg = "Pressure is outside the range of 0.3961 Pa to "
                      "101325 Pa.";

    int i;

    switch( (ActionIdx)mxGetScalar(ACTION_PARAM(S)) ){
      case NONE:
        break;
      case WARNING:
        for ( i = 0; i < numPoints; i++ ){
            if (( pressure[i] >= PRES_LOW ) && (pressure[i] <= PRESSURE0 )){
                /* do nothing */
            }
            else {
                if ( (!udata->below_min) && (!udata->over_max)){
                    udata->below_min = true;
                    udata->over_max = true;
                    ssSetUserData(S, udata);

                    ssWarning(S, PMsg);
                }
           }
        }
        break;
      case ERROR:
        for ( i = 0; i < numPoints; i++ ){
            if (( pressure[i] >= PRES_LOW ) && (pressure[i] <= PRESSURE0 )){
                /* do nothing */
            }
            else {
                ssSetErrorStatus(S, PEMsg);
                goto EXIT_POINT;
                }
        }
	break;
    }
 EXIT_POINT:

    return;
}

#if defined(MATLAB_MEX_FILE)
/* Function: mdlCheckParameters ==============================================
 * Abstract:
 *    Make sure parameter values are valid for the current run context.
 */
#define MDL_CHECK_PARAMETERS
static void mdlCheckParameters(SimStruct *S)
{
    static const char *actionValMsg = "Action for out of range input "
        "must be None, Warning or Error";

    /*
     * ---- Things to always check:
     */

    /* check Action parameter */

    if ( IS_OKREAL_PARAM(ACTION_PARAM(S)) ) {
        switch( (ActionIdx)mxGetScalar(ACTION_PARAM(S)) ){
          case NONE:
          case WARNING:
          case ERROR:
	    break;
          default:
            ssSetErrorStatus(S, actionValMsg);
            goto EXIT_POINT;
        }
    } else {
        ssSetErrorStatus(S, actionValMsg);
        goto EXIT_POINT;
    }
 
 EXIT_POINT:
    return;
}
#endif

/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *   Checks parameters and does setup on sizes of the various vectors.
 */

static void mdlInitializeSizes(SimStruct *S)
{
    ssSetNumSFcnParams(S,NPARAMS);   /* expected number */
#if defined(MATLAB_MEX_FILE)
    if (ssGetNumSFcnParams(S) == ssGetSFcnParamsCount(S)) {
        mdlCheckParameters(S);    
        if (ssGetErrorStatus(S) != NULL) return;
    }  
    else  { 
        ssSetErrorStatus(S,"Incorrect number of parameters specified.  "
                         "Need to supply 1: ACTION");
        return;
    }
#endif

    /* 
     * Parameter tunability.
     *
     * Lock all options OFF.
     */

    ssSetSFcnParamTunable(S, ACTION_IDX, false);

    ssSetNumContStates( S, 0 );
    ssSetNumDiscStates( S, 0 );

    ssSetNumInputPorts(S, 1);
    ssSetInputPortWidth(S, 0, DYNAMICALLY_SIZED);
    ssSetInputPortDataType(S, 0, SS_DOUBLE);
    ssSetInputPortDirectFeedThrough(S, 0, 1);
    ssSetInputPortRequiredContiguous(S, 0, 1);

    ssSetNumOutputPorts(S, 1);
    ssSetOutputPortWidth(S, 0, DYNAMICALLY_SIZED); 
    ssSetOutputPortDataType(S, 0, SS_DOUBLE);

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
    const double *pres = (const double *) ssGetInputPortSignal(S,0);
    double *alt   = (double *) ssGetOutputPortRealSignal(S,0);
    int     k   = ssGetInputPortWidth(S,0);

    fcn_CheckPressureCOESA(S,pres,k,udata); 

    CalcPAltCOESA(pres,alt,k);
  
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







