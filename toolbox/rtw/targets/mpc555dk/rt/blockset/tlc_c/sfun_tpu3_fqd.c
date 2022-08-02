/*
  * File: sfun_tpu3_fqd.c
  *
  * Abstract:
  *    S-function to implement TPU3 device driver for
  *    Fast Quadrature Decode
  *
  * Disclaimers / restrictions if any.
  *
  * $Revision: 1.2.4.4 $
  * $Date: 2004/04/19 01:30:27 $
  *
  * Copyright 2002-2003 The MathWorks, Inc.
  */


/*
 * You must specify the S_FUNCTION_NAME as the name of your S-function
 * (i.e. replace sfuntmpl with the name of your S-function).
 */

#define S_FUNCTION_LEVEL 2
#define S_FUNCTION_NAME  sfun_tpu3_fqd

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
enum { SAMPLE_TIME=0,      /* Sample time of the block */
   MODULE,                 /* TPU Module */
   CHANNEL,                /* TPU Channel */
   CHANNEL_PRIORITY,       /* Channel Priority */
   INIT_POSITION_COUNT,    /* Initial value of position count parameter */
   SHOW_FAST_MODE,         /* Show the fast mode input port */
   PC_ALIAS,               /* The lable for the position count alias */
   NPARAM                  /* The number of parameters */
};

#define P_REAL(pID,idx) ( mxGetPr(ssGetSFcnParam(S,(pID)))[(idx)] )
#define P_INT(pID,idx)  ( (int_T)mxGetPr(ssGetSFcnParam(S,(pID)))[(idx)] )
#define P_LEN(pID)      ( mxGetNumberOfElements(ssGetSFcnParam(S,(pID))) )
#define P_REF(pID)      ( mxGetPr(ssGetSFcnParam(S,(pID))) )
#define P_REF_UINT8(pID)  ( (uint8_T *) P_REF(pID) )
#define P_REF_UINT16(pID) ( (uint16_T *) P_REF(pID) )
#define P_STRING(pID) ((char *) mxGetChars(P_REF(pID)))

#define P_SAMPLE_TIME               ssGetSFcnParam(S,SAMPLE_TIME) 

/* note: the following are not used at Simulation time */
#define P_INIT_POSITION_COUNT_REF   P_REF_UINT16(INIT_POSITION_COUNT)
#define P_SHOW_FAST_MODE            P_INT(SHOW_FAST_MODE, 0)
#define P_CHANNEL_REF               P_REF_UINT8(CHANNEL)
#define P_CHANNEL_PRIORITY_REF      P_REF_UINT8(CHANNEL_PRIORITY)
#define P_PC_ALIAS                  P_STRING(PC_ALIAS)


static void mdlInitializeSizes(SimStruct *S)
{
    int idx;
  
    /* current port */
    int currPort = 0;
    
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

    if (!ssSetNumInputPorts(S, 1)) return;

    if (!ssSetNumOutputPorts(S, 1)) return;
   
   /* setup input ports */
   /* Fast Mode port */
   ssSetInputPortWidth(S, currPort, 1); 
   ssSetInputPortOptimOpts(S, currPort,SS_REUSABLE_AND_LOCAL);
   ssSetInputPortDirectFeedThrough(S, currPort, true);
   ssSetInputPortDataType(S, currPort, SS_BOOLEAN);
   ssSetInputPortAcceptExprInRTW(S,currPort,true);
   ssSetInputPortOverWritable(S, currPort, 1);
   ssSetInputPortReusable(S, currPort, 1);

   /* setup the only output port - POSITION_COUNT */ 
   ssSetOutputPortDataType(S, currPort, SS_UINT16);
   ssSetOutputPortWidth(S, currPort, 1); 
   ssSetOutputPortOptimOpts(S, currPort, SS_REUSABLE_AND_LOCAL);
   
   ssSetNumSampleTimes(S, 1);
   ssSetNumRWork(S, 0);
   ssSetNumIWork(S, 0);
   ssSetNumPWork(S, 0);
   ssSetNumModes(S, 0);
   ssSetNumNonsampledZCs(S, 0);
    
   /* Prevent code from being optimised out */
    ssSetOptions(S, SS_OPTION_DISALLOW_CONSTANT_SAMPLE_TIME);
}



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
    char p_alias[80];
    mxGetString(ssGetSFcnParam(S,MODULE),module,MODULE_STR_LEN);
    mxGetString(ssGetSFcnParam(S,PC_ALIAS), p_alias, 80);

    ssWriteRTWParamSettings(S,6,
                            
                            /* Param 1*/
                            SSWRITE_VALUE_STR,
                            "Module",
                            module,

                            /* Param 2*/
                            SSWRITE_VALUE_DTYPE_NUM,
                            "Channel",
                            P_CHANNEL_REF,
                            DTINFO(SS_UINT8,0),

                            /* Param 3*/
                            SSWRITE_VALUE_DTYPE_NUM,
                            "ChannelPriority",
                            P_CHANNEL_PRIORITY_REF,
                            DTINFO(SS_UINT8,0),

                            /* Param 4*/
                            SSWRITE_VALUE_DTYPE_NUM,
                            "InitPositionCount",
                            P_INIT_POSITION_COUNT_REF,
                            DTINFO(SS_UINT16,0),

                            /* Param 5*/
                            SSWRITE_VALUE_NUM,
                            "FastMode",
                            (real_T) P_SHOW_FAST_MODE,

                            /* Param 6*/
                            SSWRITE_VALUE_STR,
                            "PC_ALIAS",
                            p_alias
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
