/*
  * File: sfun_tpu3_pwm.c
  *
  * Abstract:
  *    S-function to implement TPU3 device driver for digital 
  *    output
  *
  * Disclaimers / restrictions if any.
  *
  * $Revision: 1.12.4.3 $
  * $Date: 2004/04/19 01:30:32 $
  *
  * Copyright 2002-2003 The MathWorks, Inc.
  */


/*
 * You must specify the S_FUNCTION_NAME as the name of your S-function
 * (i.e. replace sfuntmpl with the name of your S-function).
 */

#define S_FUNCTION_LEVEL 2
#define S_FUNCTION_NAME  sfun_tpu3_pwm

/*
 * Need to include simstruc.h for the definition of the SimStruct and
 * its associated macro definitions.
 */
#include "simstruc.h"

/*====================*
 * S-function methods *
 *====================*/

/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *    The sizes information is used by Simulink to determine the S-function
 *    block's characteristics (number of inputs, outputs, states, etc.).
 */
enum { SAMPLE_TIME=0, MODULE, CHANNEL, CHANNEL_PRIORITY, PWMPER, PERIOD_INPUT, NPARAM };

#define P_REAL(pID,idx) ( mxGetPr(ssGetSFcnParam(S,(pID)))[(idx)] )
#define P_INT(pID,idx)  ( (int_T)mxGetPr(ssGetSFcnParam(S,(pID)))[(idx)] )
#define P_LEN(pID)      ( mxGetNumberOfElements(ssGetSFcnParam(S,(pID))) )
#define P_REF(pID)      ( mxGetPr(ssGetSFcnParam(S,(pID))) )
#define P_REF_UINT8(pID)  ( (uint8_T *) P_REF(pID) )
#define P_REF_UINT16(pID) ( (uint16_T *) P_REF(pID) )

#define P_SAMPLE_TIME            ssGetSFcnParam(S,SAMPLE_TIME) 
#define P_PERIOD_INPUT           P_INT(PERIOD_INPUT, 0)
#define P_CHANNEL_REF            P_REF_UINT8(CHANNEL)
#define P_CHANNEL_PRIORITY_REF   P_REF_UINT8(CHANNEL_PRIORITY)
#define P_PWMPER_REF             P_REF_UINT16(PWMPER)

static void mdlInitializeSizes(SimStruct *S)
{
    int idx;
    int currPort;
      
    /* See sfuntmpl.doc for more details on the macros below */

    ssSetNumSFcnParams(S, NPARAM);  /* Number of expected parameters */
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        /* Return if number of expected != number of actual parameters */
        return;
    }

    for(idx=0;idx<NPARAM;idx++){
      ssSetSFcnParamNotTunable(S, idx);
    }

    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 0);
   
    /* 2 input ports */
    if (!ssSetNumInputPorts(S, 2)) return;

    /* 0 output ports */
    if (!ssSetNumOutputPorts(S, 0)) return;
   
   /* setup input ports */
    currPort = 0;
    
   /* port 0 = duty cycle port
    * Set the input size to be the number of channels we are dealing with */
    ssSetInputPortWidth(S, currPort, 1); 
    ssSetInputPortOptimOpts(S, currPort, SS_REUSABLE_AND_LOCAL);
    ssSetInputPortOverWritable(S, currPort, 1);
    ssSetInputPortDirectFeedThrough(S, currPort, true);
    ssSetInputPortDataType(S, currPort, DYNAMICALLY_TYPED);
    ssSetInputPortAcceptExprInRTW(S, currPort,true);
    ssSetInputPortOverWritable(S, currPort, 1);
    ssSetInputPortReusable(S, currPort++, 1);
  
   /* setup port 1 = period port */
    ssSetInputPortWidth(S, currPort, 1); 
    ssSetInputPortOptimOpts(S, currPort, SS_REUSABLE_AND_LOCAL);
    ssSetInputPortOverWritable(S, currPort, 1);
    ssSetInputPortDirectFeedThrough(S, currPort, true);
    ssSetInputPortDataType(S, currPort, SS_UINT16);
    ssSetInputPortAcceptExprInRTW(S,currPort,true);
    ssSetInputPortOverWritable(S, currPort, 1);
    ssSetInputPortReusable(S, currPort, 1);
   
    ssSetNumSampleTimes(S, 1);
    ssSetNumRWork(S, 0);
    ssSetNumIWork(S, 0);
    ssSetNumPWork(S, 0);
    ssSetNumModes(S, 0);
    ssSetNumNonsampledZCs(S, 0);
    
/* Prevent code from being optimised out */
    ssSetOptions(S, SS_OPTION_DISALLOW_CONSTANT_SAMPLE_TIME);
}

#define MDL_SET_DEFAULT_PORT_DATA_TYPES
/* Function: mdlSetDefaultPortDataTypes ========================================
*    This routine is called when Simulink is not able to find data type 
*    candidates for dynamically typed ports. This function must set the data 
*    type of all dynamically typed ports.
*/
static void mdlSetDefaultPortDataTypes(SimStruct *S)
{
   /* duty cycle port
    * this is the only dynamically typed port */
   int port = 0;
   
   /* Only apply default datatype if none already set */
   if (ssGetInputPortDataType(S, port) == -1) {
      /* duty cycle input defaults to double */
      ssSetInputPortDataType(S, port, SS_DOUBLE);
   }
} /* mdlSetDefaultPortDataTypes */


/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    This function is used to specify the sample time(s) for your
 *    S-function. You must register the same number of sample times as
 *    specified in ssSetNumSampleTimes.
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
   switch (mxGetNumberOfElements(P_SAMPLE_TIME)){
      case 1:
         ssSetSampleTime(S, 0, mxGetPr(P_SAMPLE_TIME)[0]);
         ssSetOffsetTime(S, 0, 0.0);
         break;
      case 2:
         ssSetSampleTime(S, 0, mxGetPr(P_SAMPLE_TIME)[0]);
         ssSetOffsetTime(S, 0, mxGetPr(P_SAMPLE_TIME)[1]);
         break;
      default:
         ssSetErrorStatus(S,"Bad Sample time setting.");
   }
}

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



/* Function: mdlOutputs =======================================================
 * Abstract:
 *    In this function, you compute the outputs of your S-function
 *    block. Generally outputs are placed in the output vector, ssGetY(S).
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
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


#define MDL_RTW  /* Change to #undef to remove function */
#if defined(MDL_RTW) && (defined(MATLAB_MEX_FILE) || defined(NRT))
static void mdlRTW(SimStruct *S)
{
#define MODULE_STR_LEN 2
    char module[MODULE_STR_LEN];
    mxGetString(ssGetSFcnParam(S,MODULE),module,MODULE_STR_LEN);

    ssWriteRTWParamSettings(S,5,
                            
                            SSWRITE_VALUE_STR,
                            "Module",
                            module,

                            SSWRITE_VALUE_DTYPE_NUM,
                            "Channel",
                            P_CHANNEL_REF,
                            DTINFO(SS_UINT8,0),

                            SSWRITE_VALUE_DTYPE_NUM,
                            "ChannelPriority",
                            P_CHANNEL_PRIORITY_REF,
                            DTINFO(SS_UINT8,0),

                            SSWRITE_VALUE_DTYPE_NUM,
                            "Pwmper",
                            P_PWMPER_REF,
                            DTINFO(SS_UINT16,0),

                            SSWRITE_VALUE_NUM,
                            "PeriodInput",
                            (real_T) P_PERIOD_INPUT
	);
}
#endif


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
