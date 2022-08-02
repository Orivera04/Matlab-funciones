/*  File    : saeroatmos.c
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
 *      MIL-HDBK-310                     aeroatmenvelope310.c,
 *                                       aeroatmprofile310.c 
 *      MIL-STD-210C                     aeroatmenvelope210c.c,
 *                                       aeroatmprofile210c.c
 *
 *
 *
 *  Copyright 1990-2004 The MathWorks, Inc.
 *  $Revision.1 $
 *
 *  Author:  R. Aberg   29-May-2000
 *  Modified: S. Gage   27-Nov-2001
 *            S. Gage   14-Aug-2002
 */


#define S_FUNCTION_NAME  saeroatmos
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"

#include "aeroatm.h" 
#include "aeroatmcoesa.h"
#include "aeroatmosstruct.h"
#include "aeroatm310.h"
#include "aeroatm210c.h"  

/* Parameters for this block */

#define MAX_PROFILE_SIZE 41
#define MAX_ENVELOPE_SIZE 27

/* volumetric mean radius of the earth in meters */
#define R_EARTH 6371010

/* utility macros */

#define OK2GET_PARAM(p)    (!mxIsEmpty(p))
#define IS_OKREAL_PARAM(p) (!mxIsEmpty(p) && !mxIsComplex(p) && mxIsNumeric(p) && (mxGetClassID(p)==mxDOUBLE_CLASS))

typedef enum { TYPE_IDX=0, MODEL_IDX, PVAR_IDX, PPERCENT_IDX, PALT_IDX,  
               EVAR_IDX, EPERCENT_IDX, ACTION_IDX, NPARAMS  } ParamIdx;

typedef enum { ALTGM_IDX=0, TEMP_IDX, DENS_IDX, PRES_IDX, ALT_IDX } DWorkIdx;

#define TYPE_PARAM(S) ssGetSFcnParam(S,TYPE_IDX)

#define MODEL_PARAM(S) ssGetSFcnParam(S,MODEL_IDX)

#define PVAR_PARAM(S) ssGetSFcnParam(S,PVAR_IDX)

#define PPERCENT_PARAM(S) ssGetSFcnParam(S,PPERCENT_IDX)

#define PALT_PARAM(S) ssGetSFcnParam(S,PALT_IDX)

#define EVAR_PARAM(S) ssGetSFcnParam(S,EVAR_IDX)

#define EPERCENT_PARAM(S) ssGetSFcnParam(S,EPERCENT_IDX)

#define ACTION_PARAM(S) ssGetSFcnParam(S,ACTION_IDX)

/* Function: CheckHeightStdDay ==============================================
 * Abstract:
 *   Check height and warn once if output values are extrapolated.
 *
 */
void fcn_CheckHeightStdDay(SimStruct *S,
                          const double *altitude, 
		          int numPoints,
                          SFcnCache *udata)

{ 
    static const char *AltMsg = "Height is outside the range of 0 meters "
                          "and 84852 meters.  Output values "
                          "will be extrapolated.";

    static const char *AltEMsg = "Height is  outside the range of 0 meters "
                          "and 84852 meters.";

    int i;

    switch( (ActionIdx)mxGetScalar(ACTION_PARAM(S)) ){
      case NONE:
        break;
      case WARNING:

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
        break;
      case ERROR:
        for ( i = 0; i < numPoints; i++ ){
            if (( altitude[i] >= 0.0 ) && (altitude[i] <= 84528.0 )){
                /* do nothing */
            }
            else {
                  ssSetErrorStatus(S, AltEMsg);
                  goto EXIT_POINT;   
           }
        }
	break;
    }
 EXIT_POINT:

    return;
}

/* Function: CheckHeight ==============================================
 * Abstract:
 *   Check height and warn once if output values are extrapolated.
 *
 */
void fcn_CheckHeight(SimStruct *S,
                     const double *altitude, 
	             int numPoints,
                     SFcnCache *udata)

{ 
    static const char *AltMsg = "Height is  outside the range of minimum "
                          "and maximum altitude values."
                          "  Output values will be held.";

    static const char *AltEMsg = "Height is outside the range of minimum "
                          "and maximum altitude values.";

    int i;

    switch( (ActionIdx)mxGetScalar(ACTION_PARAM(S)) ){
      case NONE:
        break;
      case WARNING:

        for ( i = 0; i < numPoints; i++ ){
            if (( altitude[i] >= udata->lower_alt ) && (altitude[i] <= udata->upper_alt )){
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
        break;
      case ERROR:
        for ( i = 0; i < numPoints; i++ ){
            if (( altitude[i] >= udata->lower_alt ) && (altitude[i] <= udata->upper_alt )){
                /* do nothing */
            }
            else {
                  ssSetErrorStatus(S, AltEMsg);
                  goto EXIT_POINT;   
           }
        }
	break;
    }
 EXIT_POINT:
    return;
}
/* Function: CalcGeomH ========================================================
 * Abstract:
 *   Calculate geometric height from geopotential height
 *
 */
void fcn_CalcGeomH(const double *altitude,
                    double alt_gm[], 
	            int numPoints)
{
    int i;

    for (i=0; i < numPoints; i++){
        /*
         * convert from geopotental alt to geometric alt
         */
        alt_gm[i] = (altitude[i]*R_EARTH)/(R_EARTH - altitude[i]);
    }

}

#if defined(MATLAB_MEX_FILE)
/* Function: mdlCheckParameters ==============================================
 * Abstract:
 *    Make sure parameter values are valid for the current run context.
 */
#define MDL_CHECK_PARAMETERS
static void mdlCheckParameters(SimStruct *S)
{
    static const char *typeValMsg = "Specification "
        "must be 1976 COESA-extended U.S. Standard Atmosphere (1),"
	" MIL-HDBK-310 (2), or MIL-STD-210C (3)";

    static const char *modelValMsg = "Atmospheric model type  "
        "must be Profile (1), or Envelope (2)";

    static const char *pvarValMsg = "Extreme Parameter "
        "must be High Temperature (1), Low Temperature (2), "
	"High Density (3), or Low Density (4)";

    static const char *ppercentValMsg = "Frequency of occurence "
        "must be either 1% (1) or 10% (2)";

    static const char *paltValMsg = "Altitude of extreme value "
        "must be 5 km (1), 10 km (2), 20 km (3), or 30 km (4)";

    static const char *evarValMsg = "Extreme Parameter "
        "must be High Temperature (1), Low Temperature (2), "
	"High Density (3), Low Density (4), High Pressure (5),"
	" or Low Pressure (6) ";

    static const char *epercentValMsg = "Frequency of occurence "
        "must be Extreme values (1), 1% (2), 5% (3), 10% (4), 20% (5)";

    static const char *actionValMsg = "Action for out of range input "
        "must be None, Warning or Error";

    /*
     * ---- Things to always check:
     */

    /* check Specification Type */

    if( IS_OKREAL_PARAM(TYPE_PARAM(S)) ) {
        switch( (TypeIdx)mxGetScalar(TYPE_PARAM(S)) ) {
          case COESA:
          case MILHDBK310:
          case MILSTD210C:
            break;
          default:
            ssSetErrorStatus(S, typeValMsg);
            goto EXIT_POINT;
        }
    } else {
        ssSetErrorStatus(S, typeValMsg);
        goto EXIT_POINT;
    }

    /* check Model of non-standard day */

    if ( IS_OKREAL_PARAM(MODEL_PARAM(S)) ) {
        switch( (ModelIdx)mxGetScalar(MODEL_PARAM(S)) ) {
          case PROFILE:
          case ENVELOPE:
            break;
          default:
            ssSetErrorStatus(S, modelValMsg);
            goto EXIT_POINT;
        }
    } else {
        ssSetErrorStatus(S, modelValMsg);
        goto EXIT_POINT;
    }

    /* check Profile extreme parameter */

    if ( IS_OKREAL_PARAM(PVAR_PARAM(S)) ) {
        switch( (VarIdx)mxGetScalar(PVAR_PARAM(S)) ){
          case HIGHTEMP:
	  case LOWTEMP:
	  case HIGHDENSITY:
	  case LOWDENSITY:
	    break;
	  default:
            ssSetErrorStatus(S, pvarValMsg);
            goto EXIT_POINT;
        }
    } else {
        ssSetErrorStatus(S, pvarValMsg);
        goto EXIT_POINT;
    }

    /* check Profile percent parameter */

    if ( IS_OKREAL_PARAM(PPERCENT_PARAM(S)) ) {
        switch( (PPercentIdx)mxGetScalar(PPERCENT_PARAM(S)) ){
          case PP1:
	  case PP10:
	    break;
	  default:
            ssSetErrorStatus(S, ppercentValMsg);
            goto EXIT_POINT;
        }
    } else {
        ssSetErrorStatus(S, ppercentValMsg);
        goto EXIT_POINT;
    }

    /* check Profile altitude parameter */

    if ( IS_OKREAL_PARAM(PALT_PARAM(S)) ) {
        switch( (PAltIdx)mxGetScalar(PALT_PARAM(S)) ){
          case K5:
	  case K10:
	  case K20:
	  case K30:
	  case K40:
	    break;
	  default:
            ssSetErrorStatus(S, paltValMsg);
            goto EXIT_POINT;
        }
    } else {
        ssSetErrorStatus(S, paltValMsg);
        goto EXIT_POINT;
    }

    /* check Envelope extreme parameter */

    if ( IS_OKREAL_PARAM(EVAR_PARAM(S)) ) {
        switch( (VarIdx)mxGetScalar(EVAR_PARAM(S)) ){
          case HIGHTEMP:
	  case LOWTEMP:
	  case HIGHDENSITY:
	  case LOWDENSITY:
	  case HIGHPRESSURE:
	  case LOWPRESSURE:
	    break;
	  default:
            ssSetErrorStatus(S, evarValMsg);
            goto EXIT_POINT;
        }
    } else {
        ssSetErrorStatus(S, evarValMsg);
        goto EXIT_POINT;
    } 
 
    /* check Envelope percent parameter */

    if ( IS_OKREAL_PARAM(EPERCENT_PARAM(S)) ) {
        switch( (EPercentIdx)mxGetScalar(EPERCENT_PARAM(S)) ){
          case EXTREME:
          case P1:
          case P5:
	  case P10:
	  case P20:
	    break;
	  default:
            ssSetErrorStatus(S, epercentValMsg);
            goto EXIT_POINT;
        }
    } else {
        ssSetErrorStatus(S, epercentValMsg);
        goto EXIT_POINT;
    }

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

/* Function: mdlStart =========================================================
 * Abstract:
 *   Store information about height limits and work data in user data.
 *   Initialize pressure and temperature tables. 
 */

#define MDL_START
static void mdlStart(SimStruct *S)
{
    static const char *msg  = "Could not allocate data cache memory";
    static const char *Smsg = "Unknown specification";
    static const char *Mmsg = "Unknown model type";

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

    /*
     * Set flags for input warnings
     */

    udata->below_min = false;
    udata->over_max  = false;

    udata->type      = (TypeIdx)mxGetScalar(TYPE_PARAM(S));
    udata->model     = (ModelIdx)mxGetScalar(MODEL_PARAM(S));
    udata->pvar      = (VarIdx)mxGetScalar(PVAR_PARAM(S));
    udata->ppercent  = (PPercentIdx)mxGetScalar(PPERCENT_PARAM(S));
    udata->palt      = (PAltIdx)mxGetScalar(PALT_PARAM(S));
    udata->evar      = (VarIdx)mxGetScalar(EVAR_PARAM(S));
    udata->epercent  = (EPercentIdx)mxGetScalar(EPERCENT_PARAM(S));
    udata->numpts    = (int)0;
    udata->lower_alt = (double)0.0;
    udata->upper_alt = (double)84852.0;
     
 
    switch (udata->type){
      case COESA:
        /* 
         * Initialize COESA pressure and temperature tables.
         */        
        InitCalcAtmosCOESA();
        break;
      case MILHDBK310:
        switch (udata->model){
          case PROFILE:
            {
            double *temp_table = ssGetDWork(S,TEMP_IDX);            
            double *dens_table = ssGetDWork(S,DENS_IDX);            
            InitCalcAtmosProfile310( udata,temp_table,dens_table );
            }
            break;
          case ENVELOPE:
            {
            double *temp_table = ssGetDWork(S,TEMP_IDX);            
            double *dens_table = ssGetDWork(S,DENS_IDX);             
            double *pres_table = ssGetDWork(S,PRES_IDX);            
            double *alt_table  = ssGetDWork(S,ALT_IDX);            
            InitCalcAtmosEnvelope310( udata,alt_table,temp_table,
                                           dens_table,pres_table );
            }
            break;
          default:
            ssSetErrorStatus(S, Mmsg);
            goto EXIT_POINT;

        } 
        break;
      case MILSTD210C:
        switch (udata->model){
          case PROFILE:
            {
            double *temp_table = ssGetDWork(S,TEMP_IDX);            
            double *dens_table = ssGetDWork(S,DENS_IDX);             
            InitCalcAtmosProfile210c( udata,temp_table,dens_table );
            }
            break;
          case ENVELOPE:
            {
            double *temp_table = ssGetDWork(S,TEMP_IDX);            
            double *dens_table = ssGetDWork(S,DENS_IDX);             
            double *pres_table = ssGetDWork(S,PRES_IDX);            
            double *alt_table  = ssGetDWork(S,ALT_IDX);            
            InitCalcAtmosEnvelope210c( udata,alt_table,temp_table,
                                           dens_table,pres_table );
            }
            break;
          default:
            ssSetErrorStatus(S, Mmsg);
            goto EXIT_POINT;

        } 
        break;
      default:
        ssSetErrorStatus(S, Smsg);
        goto EXIT_POINT;
    }
     
    /*
     * set number of points, min and max alt for table in structure
     */
    ssSetUserData(S, udata);
       
 EXIT_POINT:
    return;
}

/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *   Checks parameters and does setup on sizes of the various vectors.
 */

static void mdlInitializeSizes(SimStruct *S)
{
    int_T i;
    int_T  nWorkVector;

    ssSetNumSFcnParams(S,NPARAMS );   /* expected number */

#if defined(MATLAB_MEX_FILE)
    if (ssGetNumSFcnParams(S) == ssGetSFcnParamsCount(S)) {
        mdlCheckParameters(S);    
        if (ssGetErrorStatus(S) != NULL) return;
    }  
    else  { 
        ssSetErrorStatus(S,"Incorrect number of parameters specified.  "
                         "Need to supply 8: SPEC, MODEL, PROFILE_VAR, "
			 "PROFILE_PERCENT, PROFILE_ALT, ENVELOPE_VAR, "
			 "ENVELOPE_PERCENT and ACTION");
        return;
    }
#endif

    /* 
     * Parameter tunability.
     *
     * Lock all options OFF.
     */

    ssSetSFcnParamTunable(S, TYPE_IDX,     false);
    ssSetSFcnParamTunable(S, MODEL_IDX,    false);
    ssSetSFcnParamTunable(S, PVAR_IDX,     false);
    ssSetSFcnParamTunable(S, PPERCENT_IDX, false);
    ssSetSFcnParamTunable(S, PALT_IDX,     false);
    ssSetSFcnParamTunable(S, EVAR_IDX,     false);
    ssSetSFcnParamTunable(S, EPERCENT_IDX, false);
    ssSetSFcnParamTunable(S, ACTION_IDX, false);

    ssSetNumContStates( S, 0 );
    ssSetNumDiscStates( S, 0 );

    ssSetNumInputPorts(S, 1);
    ssSetInputPortWidth(S, 0, DYNAMICALLY_SIZED);
    ssSetInputPortDataType(S, 0, SS_DOUBLE);
    ssSetInputPortDirectFeedThrough(S, 0, 1);
    ssSetInputPortRequiredContiguous(S, 0, 1);

    ssSetNumOutputPorts(S, 4);
    ssSetOutputPortWidth(S, 0, DYNAMICALLY_SIZED); /* temperature */
    ssSetOutputPortDataType(S, 0, SS_DOUBLE);
    ssSetOutputPortWidth(S, 1, DYNAMICALLY_SIZED); /* speed of sound */
    ssSetOutputPortDataType(S, 1, SS_DOUBLE);
    ssSetOutputPortWidth(S, 2, DYNAMICALLY_SIZED); /* pressure     */
    ssSetOutputPortDataType(S, 2, SS_DOUBLE);
    ssSetOutputPortWidth(S, 3, DYNAMICALLY_SIZED); /* density     */
    ssSetOutputPortDataType(S, 3, SS_DOUBLE);

    /* set up pointer work vector for non-standard day tables */

    if ((TypeIdx) mxGetScalar(TYPE_PARAM(S)) != COESA){
        nWorkVector = ((ModelIdx)mxGetScalar(MODEL_PARAM(S)) == PROFILE )
            ? 3 : 5;        

        if (!ssSetNumDWork(S, nWorkVector)) return;
        for (i = 0; i < nWorkVector; i++) {
            ssSetDWorkDataType(S, i, SS_DOUBLE);
        }

        ssSetDWorkName(S, ALTGM_IDX, "alt_gm");
        ssSetDWorkName(S, TEMP_IDX, "temp_table");
        ssSetDWorkName(S, DENS_IDX, "dens_table");

        ssSetDWorkWidth(S, ALTGM_IDX, DYNAMICALLY_SIZED);  

        if (nWorkVector == 3)
        {
           ssSetDWorkWidth(S, TEMP_IDX, MAX_PROFILE_SIZE);  
           ssSetDWorkWidth(S, DENS_IDX, MAX_PROFILE_SIZE);  
        }

         if (nWorkVector == 5)
        {
            ssSetDWorkName(S, PRES_IDX, "pres_table");
            ssSetDWorkName(S, ALT_IDX, "alt_table");
            for (i = 1; i < nWorkVector; i++) {
                ssSetDWorkWidth(S, i, MAX_ENVELOPE_SIZE);  
	    }  
        }
    }

    /* Take care when specifying exception free code - see sfuntmpl_doc.c */
    ssSetOptions(S, (SS_OPTION_CALL_TERMINATE_ON_EXIT));

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

/* Function: mdlOutputs =======================================================
 * Abstract:
 *    Calculate base relationship for pressure
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
    static const char *Smsg = "Unknown specification";
    static const char *Mmsg = "Unknown model type";

    SFcnCache *udata = ssGetUserData(S);
    const double *alt = (const double *) ssGetInputPortSignal(S,0);
    double *T   = (double *) ssGetOutputPortRealSignal(S,0);
    double *SoS = (double *) ssGetOutputPortRealSignal(S,1);
    double *P   = (double *) ssGetOutputPortRealSignal(S,2);
    double *rho = (double *) ssGetOutputPortRealSignal(S,3);
    int     k   = ssGetInputPortWidth(S,0);

    switch (udata->type){
      case COESA:
        fcn_CheckHeightStdDay(S,alt,k,udata);
        CalcAtmosCOESA(alt,T,P,rho,SoS,k);
        break;
      case MILHDBK310:
          {
              double *alt_gm = ssGetDWork(S,ALTGM_IDX);
              double *temp_table = ssGetDWork(S,TEMP_IDX);            
              double *dens_table = ssGetDWork(S,DENS_IDX);             

              fcn_CalcGeomH(alt,alt_gm,k);
              fcn_CheckHeight(S,alt_gm,k,udata);

              switch (udata->model){
                case PROFILE:
                  {
                  CalcAtmosProfile310(alt_gm,temp_table,dens_table,T,P,
                                      rho,SoS,k,udata->numpts,udata->lower_alt,
				       udata->upper_alt);
                  }
                  break;
                case ENVELOPE:
                  {
                  double *pres_table = ssGetDWork(S,PRES_IDX);            
                  double *alt_table  = ssGetDWork(S,ALT_IDX);            
                  CalcAtmosEnvelope310(alt_gm,alt_table,temp_table,
                                        dens_table,pres_table,T,P,rho,
                                        SoS,k,udata);
                  }
                  break;
                default:
                  ssSetErrorStatus(S, Mmsg);
                  goto EXIT_POINT;
              }
          }
          break;
      case MILSTD210C:
          {
              double *alt_gm = ssGetDWork(S,ALTGM_IDX);
              double *temp_table = ssGetDWork(S,TEMP_IDX);            
              double *dens_table = ssGetDWork(S,DENS_IDX);             

              fcn_CalcGeomH(alt,alt_gm,k);
              fcn_CheckHeight(S,alt_gm,k,udata);

              switch (udata->model){
                case PROFILE:
                  {
                  CalcAtmosProfile210c(alt_gm,temp_table,dens_table,T,P,
                                       rho,SoS,k,udata->numpts,udata->lower_alt,
				       udata->upper_alt);
                  }
                  break;
                case ENVELOPE:
                  {
                  double *pres_table = ssGetDWork(S,PRES_IDX);            
                  double *alt_table  = ssGetDWork(S,ALT_IDX);            
                  CalcAtmosEnvelope210c(alt_gm,alt_table,temp_table,
                                        dens_table,pres_table,T,P,rho,
                                        SoS,k,udata);
                  }
                  break;
                default:
                  ssSetErrorStatus(S, Mmsg);
                  goto EXIT_POINT;
              } 
          }
          break;
      default:
        ssSetErrorStatus(S, Smsg);
        goto EXIT_POINT;
    }

 EXIT_POINT:  
    return;
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







