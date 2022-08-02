/*  File    : saerogravity.c
 *  Abstract:
 *
 *      A level 2 S-function to calculate Earth WGS-84 gravity.  
 *      Uses the following function files in common with MATLAB
 *       .mex utility for producing gravity data suitable for 
 *      use in tables:
 *
 *      Standard                         C file
 *      -------------------------------  ----------------------
 *      World Geodetic System (WGS 84)    aerogravitywgs84.c
 *
 *      Height is entered in the same unit system as selected for gravity.  
 *      Latitude and longitude (if required) are entered in degrees. 
 *      
 *      For more details about S-functions, see simulink/src/sfuntmpl_doc.c.
 *
 *  S. Gage, 16 JUL 2001
 *  Copyright 1990-2004 The MathWorks, Inc.
 *
 *  $Revision: 1.1.6.2 $ $Date: 2004/04/10 23:12:08 $
 */

#define S_FUNCTION_NAME  saerogravity2
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"
#include <math.h>

#include "aerodefs.h"

/* utility macros */

#define OK2GET_PARAM(p)    (!mxIsEmpty(p))
#define IS_OKREAL_PARAM(p) (!mxIsEmpty(p) && !mxIsComplex(p) && mxIsNumeric(p) && (mxGetClassID(p)==mxDOUBLE_CLASS))

typedef enum { TYPE_IDX=0, UNITS_IDX, NOATMOS_IDX, PRECESSING_IDX, MONTH_IDX, 
               DAY_IDX,  YEAR_IDX, CENTRIFUGAL_IDX, ACTION_IDX, NPARAMS  } ParamIdx;

#define TYPE_PARAM(S) ssGetSFcnParam(S,TYPE_IDX)

#define UNITS_PARAM(S) ssGetSFcnParam(S,UNITS_IDX)

#define NOATMOS_PARAM(S) ssGetSFcnParam(S,NOATMOS_IDX)

#define PRECESSING_PARAM(S) ssGetSFcnParam(S,PRECESSING_IDX)

#define MONTH_PARAM(S) ssGetSFcnParam(S,MONTH_IDX)

#define DAY_PARAM(S) ssGetSFcnParam(S,DAY_IDX)

#define YEAR_PARAM(S) ssGetSFcnParam(S,YEAR_IDX)

#define CENTRIFUGAL_PARAM(S) ssGetSFcnParam(S,CENTRIFUGAL_IDX)

#define ACTION_PARAM(S) ssGetSFcnParam(S,ACTION_IDX)

#include "aerogravitystruct.h"
#include "aerogravitywgs84.h"

#if defined(MATLAB_MEX_FILE)
/* Function: mdlCheckParameters ==============================================
 * Abstract:
 *    Make sure parameter values are valid for the current run context.
 */
#define MDL_CHECK_PARAMETERS
static void mdlCheckParameters(SimStruct *S)
{
    static const char *typeValMsg = "Method "
        "must be Taylor Series (1), Close Approximate (2), or "
        "Exact (3)";

    static const char *unitsValMsg = "Units "
        "must be Metric (1), or English (2)";

    static const char *atmosValMsg = "The 'Exclude Earth's Atmosphere' input "
        "must be either 0 (do not exclude) or 1 (exclude)";

    static const char *precessingValMsg = "The 'Precessing Reference Frame' "
        "input must be either 0 (non-precessing) or 1 (precessing)";

    static const char *monthValMsg = "The 'Month' input must be January (1), "
        "February (2), March (3), April (4), May (5), June (6), July (7), "
        "August (8), September (9), October (10), November (11), or "
        "December (12)";

    static const char *dayValMsg = "The 'Date' input must be at least 1,not "
        "more than 30 for April, June, September and November, not more than "
        "31 for January, March, May, July, August, October, and December, and "
        "not more than 28 for non-leap year February or 29 for leap year "
        "February";

    static const char *yearValMsg = "The 'Year' input must be 2000 or greater";

    static const char *centrifugalValMsg = "The 'Centrifugal Effects' input "
        "must be either 0 (use centrifugal forces) or 1 (do not use "
        "centrifugal forces)";
        
    static const char *actionValMsg = "Action for out of range input "
        "must be None, Warning or Error";        

    /*
     * ---- Things to always check:
     */

    /* check Method */

    if( IS_OKREAL_PARAM(TYPE_PARAM(S)) ) {
        switch( (TypeIdx)mxGetScalar(TYPE_PARAM(S)) ) {
          case WGS84TAYLORSERIES:
          case WGS84CLOSEAPPROX:
          case WGS84EXACT:
            break;
          default:
            ssSetErrorStatus(S, typeValMsg);
            goto EXIT_POINT;
        }
    } else {
        ssSetErrorStatus(S, typeValMsg);
        goto EXIT_POINT;
    }

    /* check Units */

    if ( IS_OKREAL_PARAM(UNITS_PARAM(S)) ) {
        switch( (UnitIdx)mxGetScalar(UNITS_PARAM(S)) ) {
          case METRIC:
          case ENGLISH:
            break;
          default:
            ssSetErrorStatus(S, unitsValMsg);
            goto EXIT_POINT;
        }
    } else {
        ssSetErrorStatus(S, unitsValMsg);
        goto EXIT_POINT;
    }

    /* check 'Exclude Earth's Atmosphere' input flag */

    if ( IS_OKREAL_PARAM(NOATMOS_PARAM(S)) ) {
        int noatmosFlag = (int)mxGetScalar(NOATMOS_PARAM(S));
        if ( noatmosFlag != 0 &&
             noatmosFlag != 1) {
            ssSetErrorStatus(S, atmosValMsg);
            goto EXIT_POINT;
        }
    } else {
        ssSetErrorStatus(S, atmosValMsg);
        goto EXIT_POINT;
    }

    /* check 'Precessing Ref. Frame' input flag */

    if ( IS_OKREAL_PARAM(PRECESSING_PARAM(S)) ) {
        int precessFlag = (int)mxGetScalar(PRECESSING_PARAM(S));
        if ( precessFlag != 0 &&
             precessFlag != 1) {
            ssSetErrorStatus(S, precessingValMsg);
            goto EXIT_POINT;
        }
    } else {
        ssSetErrorStatus(S, precessingValMsg);
        goto EXIT_POINT;
    }

    /* check Month */

    if( IS_OKREAL_PARAM(MONTH_PARAM(S)) ) {
        switch( (MonthIdx)mxGetScalar(MONTH_PARAM(S)) ) {
          case JANUARY:
          case FEBRUARY:
          case MARCH:
          case APRIL:
          case MAY:
          case JUNE:
          case JULY:
          case AUGUST:
          case SEPTEMBER:
          case OCTOBER:
          case NOVEMBER:
          case DECEMBER:
            break;
          default:
            ssSetErrorStatus(S, monthValMsg);
            goto EXIT_POINT;
        }
    } else {
        ssSetErrorStatus(S, monthValMsg);
        goto EXIT_POINT;
    }

    /* check Year */

    if ( IS_OKREAL_PARAM(YEAR_PARAM(S)) ) {
        int yearNum = (int)mxGetScalar(YEAR_PARAM(S));
        if ( yearNum < YEAR2000 ) {
            ssSetErrorStatus(S, yearValMsg);
            goto EXIT_POINT;
        }
    } else {
        ssSetErrorStatus(S, yearValMsg);
        goto EXIT_POINT;
    }

    /* check Day */

    if ( IS_OKREAL_PARAM(DAY_PARAM(S)) ) {
        int dayNum = (int)mxGetScalar(DAY_PARAM(S));
        if ( dayNum < 1 || 
             dayNum > 31 ) {
            ssSetErrorStatus(S, dayValMsg);
            goto EXIT_POINT;
        } else  {
            switch( (MonthIdx)mxGetScalar(MONTH_PARAM(S)) ) {
              case JANUARY:
              case MARCH:
              case MAY:
              case JULY:
              case AUGUST:
              case OCTOBER:
              case DECEMBER:
                break;
              case APRIL:
              case JUNE:
              case SEPTEMBER:
              case NOVEMBER:
                if ( dayNum > 30 ) {
                    ssSetErrorStatus(S, dayValMsg);
                    goto EXIT_POINT;
                } break;
              case FEBRUARY:
                if (dayNum > 28){
                    int yearNum  = (int)mxGetScalar(YEAR_PARAM(S));
                    bool leapyear = (((yearNum % 100)==0) && 
                                     ((yearNum % 400)!=0)) ? false : 
                                    (((yearNum % 4)==0) ? true : false );
                    if ( dayNum > 29 || (!leapyear) ) {
                        ssSetErrorStatus(S, dayValMsg);
                        goto EXIT_POINT;
                    }
                } break;
              default:
                ssSetErrorStatus(S, monthValMsg);
                goto EXIT_POINT;
            }
        } 
    } else {
        ssSetErrorStatus(S, dayValMsg);
        goto EXIT_POINT;
    }

    /* check 'Centrifugal Forces' input flag */

    if ( IS_OKREAL_PARAM(CENTRIFUGAL_PARAM(S)) ) {
        int forceFlag = (int)mxGetScalar(CENTRIFUGAL_PARAM(S));
        if ( forceFlag != 0 &&
             forceFlag != 1) {
            ssSetErrorStatus(S, centrifugalValMsg);
            goto EXIT_POINT;
        }
    } else {
        ssSetErrorStatus(S, centrifugalValMsg);
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
 *    allocate work data and initialize non-tunable items.
 */

#define MDL_START
static void mdlStart(SimStruct *S)
{
    static const char *msg = "Could not allocate data cache memory";
    SFcnCache   *udata;
    WGS_params  *WGS84;

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

    udata->type        = (TypeIdx)mxGetScalar(TYPE_PARAM(S));
    udata->units       = (UnitIdx)mxGetScalar(UNITS_PARAM(S));
    udata->noatmos     = (int)mxGetScalar(NOATMOS_PARAM(S));
    udata->precessing  = (int)mxGetScalar(PRECESSING_PARAM(S));
    udata->month       = (MonthIdx)mxGetScalar(MONTH_PARAM(S));
    udata->day         = (double)mxGetScalar(DAY_PARAM(S));
    udata->year        = (double)mxGetScalar(YEAR_PARAM(S));
    udata->centrifugal = (int)mxGetScalar(CENTRIFUGAL_PARAM(S));
     
    WGS84 = (WGS_params *) malloc(sizeof(WGS_params));
    if (WGS84 == NULL) {
        ssSetErrorStatus(S, msg);
        free( udata );
        goto EXIT_POINT;
    }

    WGS84->a             = 6378137.0;
    WGS84->inv_f         = 298.257223563;
    WGS84->omega_default = 7292115.0e-11;
    WGS84->GM_default    = 3986004.418e+8; 
    WGS84->GM_prime      = 3986000.9e+8; 
    WGS84->omega_prime   = 7292115.1467e-11;
    WGS84->gamma_e       = 9.7803253359;  
    WGS84->k             = 0.00193185265241;
    WGS84->e2            = 6.69437999014e-3;
    WGS84->E             = 5.2185400842339e+5;
    WGS84->b             = 6356752.3142;
    WGS84->b_over_a      = 0.996647189335;

    udata->WGS = WGS84;

    /*
     * Set flags for input warnings
     */

    udata->phi_wrap    = 0;
    udata->lambda_warn = 0;
    udata->lambda_wrap = 0;
    udata->below_min   = 0;
    udata->above_20000 = 0;

    /* 
     * Set the cached data into the user data area for 'this' block.
     */

    ssSetUserData( S, udata );

 EXIT_POINT:
    return;
}

/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *    The sizes information is used by Simulink to determine the S-function
 *    block's characteristics (number of inputs, outputs, states, etc.).
 */
static void mdlInitializeSizes(SimStruct *S)
{
    
    int_T  i;
    int_T  nInputPorts;

    ssSetNumSFcnParams(S, NPARAMS);  /* Number of expected parameters */

#if defined(MATLAB_MEX_FILE)
    if (ssGetNumSFcnParams(S) == ssGetSFcnParamsCount(S)) {
        mdlCheckParameters(S);    
        if (ssGetErrorStatus(S) != NULL) return;
    }  
    else  { 
        ssSetErrorStatus(S,"Incorrect number of parameters specified.  "
                         "Need to supply 9: MODEL, UNITS, "
                         "NO_ATMOS, PRECESSING, MONTH, "
                         "DAY, YEAR, NO_CENTRIFUGAL, AND ACTION ");
        return;
    }
#endif


    /* 
     * Parameter tunability.
     *
     * Lock all options OFF.
     */

    ssSetSFcnParamTunable(S, TYPE_IDX,        false);
    ssSetSFcnParamTunable(S, UNITS_IDX,       false);
    ssSetSFcnParamTunable(S, NOATMOS_IDX,     false);
    ssSetSFcnParamTunable(S, PRECESSING_IDX,  false);
    ssSetSFcnParamTunable(S, MONTH_IDX,       false);
    ssSetSFcnParamTunable(S, DAY_IDX,         false);
    ssSetSFcnParamTunable(S, YEAR_IDX,        false);
    ssSetSFcnParamTunable(S, CENTRIFUGAL_IDX, false);


    nInputPorts = 3;        

    if (!ssSetNumInputPorts(S, nInputPorts)) return;
    for (i = 0; i < nInputPorts; i++) {
        ssSetInputPortDataType(S, i, SS_DOUBLE);
        ssSetInputPortWidth(S, i, DYNAMICALLY_SIZED);
        ssSetInputPortDirectFeedThrough(S, i, 1);
        ssSetInputPortOverWritable(S, i, 1);
        ssSetInputPortReusable(S, i, 1); 
    }

    if (!ssSetNumOutputPorts(S, 1)) return;
    ssSetOutputPortWidth(S, 0, DYNAMICALLY_SIZED);
    ssSetOutputPortDataType(S, 0, SS_DOUBLE);

    ssSetNumSampleTimes(S, 1);
    ssSetNumRWork(S, 0);
    ssSetNumIWork(S, 0);
    ssSetNumPWork(S, 0);
    ssSetNumModes(S, 0);
    ssSetNumNonsampledZCs(S, 0);

 
    /* Take care when specifying exception free code - see sfuntmpl_doc.c */
    ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE);

    ssSetModelReferenceSampleTimeDefaultInheritance(S);

    return;
}



/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    Inherited Sample Time S-function
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, INHERITED_SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0.0);
}

/*
 * Function: fcn_check_positive_height  ============================
 * Abstract:
 *          Check if height entered is positive
 */
static void fcn_check_positive_height(SimStruct *S,
                                      SFcnCache *udata,
                                      double     h)
{    

switch( (ActionIdx)mxGetScalar(ACTION_PARAM(S)) ){
      case NONE:
        break;
      case WARNING:
        if ((!udata->below_min) && (h < 0.0)){
           udata->below_min = 1;        
           ssSetUserData( S, udata );

           ssWarning(S, "Height is less than zero.  Height must "
                     "be a non-negative number. ");
        }
        break;
      case ERROR:
        if ((!udata->below_min) && (h < 0.0)){
           ssSetErrorStatus(S, "Height is less than zero.  Height must "
                            "be a non-negative number. ");
           goto EXIT_POINT;
        }
   	    break;
    }
 EXIT_POINT:

    return;
}

/*
 * Function: fcn_phi_wrap ==========================================
 * Abstract: 
 *           Check and fix angle wrapping in latitude (phi)
 */
static void fcn_phi_wrap(SimStruct *S,
                         double    *phi,
                         boolean_T *phi_wrapped,
                         SFcnCache *udata)
{
    real_T fphi, pi_2;

    fphi = fabs(*phi);
    pi_2 =  AERO_PI/2.0;  

    if ( fphi > pi_2 ){
        real_T sign = *phi/fphi;

        *phi_wrapped = true;
        *phi =  pi_2*(2.0*ceil(((fphi/pi_2) - 1.0)/2.0) - (fphi/pi_2))*sign;

        switch( (ActionIdx)mxGetScalar(ACTION_PARAM(S)) ){
            case NONE:
              break;
            case WARNING:
              if (!udata->phi_wrap){
                  udata->phi_wrap = 1;        
                  ssSetUserData( S, udata );

                  ssWarning(S, "Absolute latitude value exceeds 90 degrees, "
                          "wrapping latitude value within -90 degrees "
                          "and 90 degrees, and continuing");
              }
              break;
            case ERROR:
              if (!udata->phi_wrap){
                  ssSetErrorStatus(S, "Absolute latitude value exceeds 90 degrees.");

                  goto EXIT_POINT;
              }
   	          break;
        }
    }
EXIT_POINT:
return;
}

/*
 * Function: fcn_lambda_wrap ==========================================
 * Abstract: 
 *           Check and fix angle wrapping in longitude (lambda)
 */
static void fcn_lambda_wrap(SimStruct *S, 
                            double    *lambda, 
                            boolean_T *phi_wrapped,
                            SFcnCache *udata)
{
    real_T flambda = fabs(*lambda);

    if ( *phi_wrapped ){
        *lambda = *lambda + AERO_PI;

        switch( (ActionIdx)mxGetScalar(ACTION_PARAM(S)) ){
            case NONE:
              break;
            case WARNING:
              if ((!udata->lambda_warn)&&(udata->phi_wrap)){
                  udata->lambda_warn = 1;        
                  ssSetUserData( S, udata );

                  ssWarning(S, "Adjusting longitude value, for wrapped"
                        " latitude value, and continuing");
              }
              break;
            case ERROR:
   	          break;
        }
    }


    /* check and fix angle wrapping in longitude (lambda) */

    if ( flambda > AERO_PI ){
        real_T sign = *lambda/flambda;

        *lambda = AERO_PI*(flambda/AERO_PI) - 2.0*ceil(((flambda/AERO_PI) 
                                                             - 1.0)/2.0)*sign;

        switch( (ActionIdx)mxGetScalar(ACTION_PARAM(S)) ){
            case NONE:
              break;
            case WARNING:
              if (!udata->lambda_wrap){
                udata->lambda_wrap = 1;        
                ssSetUserData( S, udata );

                ssWarning(S, "Absolute longitude value exceeds 180 degrees, "
                        "wrapping longitude value within -180 degrees "
                        "and 180 degrees, and continuing");
              }
              break;
            case ERROR:
              if (!udata->lambda_wrap){
                  ssSetErrorStatus(S, "Absolute longitude value exceeds 180 degrees.");

                  goto EXIT_POINT;
              }
   	          break;
        }
    }
EXIT_POINT:
return;
 }


/* Function: mdlOutputs =======================================================
 * Abstract:
 *      calculate normal (to the Earth's surface) gravity using one
 *      of three methods. (WGS84 Taylor Series, Close Approx. or Exact)
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
    SFcnCache  *udata       = ssGetUserData(S);
    real_T     *y           = ssGetOutputPortRealSignal(S,0);
    InputRealPtrsType height_ptr  = ssGetInputPortRealSignalPtrs(S,0);
    InputRealPtrsType phi_ptr     = ssGetInputPortRealSignalPtrs(S,1);
    WGS_params       *WGS         = udata->WGS;
    boolean_T         phi_wrapped = false;
    int_T             num_inputs  = ssGetInputPortWidth(S,0);

    double phi, h;

    double GM, opt_m2ft;
    int_T i;

    /* Linear Eccentricity Squared */
    double  E2          = WGS->E*WGS->E;

    /* get unit conversion factor  */
    opt_m2ft = 1.0;

    /* Use Earth's Atmosphere in Gravitational Const? */
    GM = ( udata->noatmos == 0 ) ? WGS->GM_default : 
        WGS->GM_prime;
       
    switch ( udata->type ) { 
      case WGS84TAYLORSERIES:
    
        for ( i = 0; i < num_inputs; i++ ){
            /* create short variables for latitude (phi) and height (h) */
            phi = *phi_ptr[i];
            h = *height_ptr[i];

            fcn_check_positive_height(S, udata, h);

            /* check and fix angle wrapping in latitude (phi) */
            fcn_phi_wrap(S, &phi, &phi_wrapped, udata);

            /* Check height if in acceptable region for method */
            switch( (ActionIdx)mxGetScalar(ACTION_PARAM(S)) ){
                case NONE:
                 break;
                case WARNING:
 
                if ((!udata->above_20000) && ( h > 20000.0 )){
                    udata->above_20000 = true;
                    ssSetUserData( S, udata );
          
                    ssWarning(S,  "Height is greater than 20000 meters "
                          "(65616.7979 feet).  Gravity calculated"
                          " may differ by more that 10^-6 from"
                          " exact.  Taylor Series methods will not"
                          " produce a result with sub-microgal"
                          " precision above the surface.");
                }     
                    break;
                case ERROR:
                    if ((!udata->above_20000) && ( h > 20000.0 )){
                      ssSetErrorStatus(S, "Height is greater than 20000 meters "
                          "(65616.7979 feet).");
                      goto EXIT_POINT;
                    }
   	                break;
            }
            y[i]= wgs84_taylor_series(h,phi,WGS,opt_m2ft);
      }
        break;
      case WGS84CLOSEAPPROX:
          {          
              /* Get additional inputs for methods */
              InputRealPtrsType lambda_ptr = ssGetInputPortRealSignalPtrs(S,2);

              for ( i = 0; i < num_inputs; i++ ){

                  double lambda;

                  /* create short variables for latitude (phi) and height (h)*/
                  phi = *phi_ptr[i];
                  h = *height_ptr[i];

                  /* create short variable for longitude (lambda) */ 
                  lambda = *lambda_ptr[i]; 

                  fcn_check_positive_height(S, udata, h);

                  /* check and fix angle wrapping in latitude (phi) */
                  fcn_phi_wrap(S, &phi, &phi_wrapped, udata);

                  /* check and fix angle wrapping in longitude (lambda) */
                  fcn_lambda_wrap(S, &lambda, &phi_wrapped, udata);

                  /* Check height if in acceptable region for method */
            switch( (ActionIdx)mxGetScalar(ACTION_PARAM(S)) ){
                case NONE:
                 break;
                case WARNING:
                    if ((!udata->above_20000) && ( h > 20000.0 )){
                         udata->above_20000 = true;
                         ssSetUserData( S, udata );
        
                         ssWarning(S, "Height is greater than 20000 meters "
                                "(65616.7979 feet).  Gravity calculated"
                                " may differ by more that a microgal from" 
                                " exact.");
                  }                    break;
                case ERROR:
                    if ((!udata->above_20000) && ( h > 20000.0 )){
                      ssSetErrorStatus(S, "Height is greater than 20000 meters "
                          "(65616.7979 feet).");
                      goto EXIT_POINT;
                    }
   	                break;
                }                  

                  /* Calculating approximate normal gravity */

                  /* Return normal gravity */
                  y[i] = wgs84_approx( h, phi, lambda,
                                       udata, E2, GM, opt_m2ft); 
              }
          } 
          break;
      case WGS84EXACT:
          {
              /* Get additional inputs for methods */
              InputRealPtrsType lambda_ptr = ssGetInputPortRealSignalPtrs(S,2);

              for ( i = 0; i < num_inputs; i++ ){
          
                  double lambda;

                  /* create short variables for latitude (phi) and height (h)*/
                  phi = *phi_ptr[i];
                  h = *height_ptr[i];

                  /* create short variable for longitude (lambda) */ 
                  lambda = *lambda_ptr[i]; 

 
                  fcn_check_positive_height(S, udata, h);

                  /* check and fix angle wrapping in latitude (phi) */
                  fcn_phi_wrap(S, &phi, &phi_wrapped, udata);

                  /* check and fix angle wrapping in longitude (lambda) */
                  fcn_lambda_wrap(S, &lambda, &phi_wrapped, udata);

                  /* Return total normal gravity */
                  y[i] = wgs84_exact( h, phi, lambda, 
                                      udata, E2, GM, opt_m2ft);
              }          }
          break;
    }
EXIT_POINT:
return;         
}

/* Function: mdlTerminate =====================================================
 * Abstract:
 *    Free up the parameter cache memory.
 */
static void mdlTerminate(SimStruct *S)
{
    SFcnCache *udata = ssGetUserData(S);

    if( udata != NULL ) {
        free( (void *)udata->WGS );
    }
    free( (void *)udata );
    ssSetUserData(S, NULL);

    return;
} 

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
