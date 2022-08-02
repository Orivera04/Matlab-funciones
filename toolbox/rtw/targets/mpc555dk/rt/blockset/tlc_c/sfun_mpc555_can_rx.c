/*
 * File: sfun_mpc555_can_rx.c
 *
 * Abstract:
 *   
 *
 * $Revision: 1.7.2.4 $
 * $Date: 2004/04/19 01:30:19 $
 *
 * Copyright 2001-2003 The MathWorks, Inc.
 */

/*
 * You must specify the S_FUNCTION_NAME as the name of your S-function
 * (i.e. replace sfuntmpl_basic with the name of your S-function).
 */

#define S_FUNCTION_NAME sfun_mpc555_can_rx 
#define S_FUNCTION_LEVEL 2

/*
 * Need to include simstruc.h for the definition of the SimStruct and
 * its associated macro definitions.
 */
#include "simstruc.h"
#include "sfun_can_util.h"


/*=============================
 * Externally defined functions
 *=============================*/

/*====================*
 * Defines
 *===================*/

enum { E_MODULE = 0, 
       E_IDENTIFIER,
       E_SAMPLE_TIME,
       E_TYPE,
       E_BUFFER,
       E_USE_QUEUE,
       E_QUEUE_LEN,
       E_NOTIFICATION_TYPE,
       P_NPARMS };

#define SFPARAM(type, i) ((type)mxGetScalar(ssGetSFcnParam(S,(i))))

#define P_MODULE              SFPARAM(int, E_MODULE)
#define P_IDENTIFER           SFPARAM(int, E_IDENTIFIER)
#define P_SAMPLE_TIME         ssGetSFcnParam(S,2)
#define P_TYPE                SFPARAM(int, E_TYPE)
#define P_BUFFER              SFPARAM(int, E_BUFFER)
#define P_USE_QUEUE           SFPARAM(int, E_USE_QUEUE) 
#define P_NOTIFICATION_TYPE   SFPARAM(int, E_NOTIFICATION_TYPE)
#define P_QUEUE_LEN           SFPARAM(int, E_QUEUE_LEN)


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

        int idx;

        int_T canExDT; // Extended extended frame
        int_T canStDT; // Standard frame


        /* See sfuntmpl_doc.c for more details on the macros below */

        ssSetNumSFcnParams(S, P_NPARMS);  /* Number of expected parameters */
        // No parameters will be tunable
        for(idx=0; idx<P_NPARMS; idx++){
                ssSetSFcnParamNotTunable(S,idx);
        }

        if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
                /* Return if number of expected != number of actual parameters */
                return;
        }

        CAN_Common_MdlInitSizes(S);
        canExDT = ssGetDataTypeId(S,SL_CAN_EXTENDED_FRAME_DTYPE_NAME );
        canStDT = ssGetDataTypeId(S,SL_CAN_STANDARD_FRAME_DTYPE_NAME );


        ssSetNumInputPorts(S,0);

        ssSetNumOutputPorts(S,2);

        ssSetOutputPortWidth(S,0,1);
        ssSetOutputPortOptimOpts(S,0, SS_REUSABLE_AND_LOCAL);

        ssSetOutputPortWidth(S,1,1);
        ssSetOutputPortOptimOpts(S,1, SS_REUSABLE_AND_LOCAL);

        if( P_TYPE == CAN_MESSAGE_STANDARD){
                ssSetOutputPortDataType(S,1,canStDT);
        }else if ( P_TYPE == CAN_MESSAGE_EXTENDED ){
                ssSetOutputPortDataType(S,1,canExDT);
        }


        ssSetNumContStates(S, 0);
        ssSetNumDiscStates(S, 0);


        ssSetNumSampleTimes(S, 1);
        ssSetNumRWork(S, 0);
        ssSetNumIWork(S, 0);

        /* Reserve an element in the pointers vector for the circular buffer structure
         * in the generated code
         */
        if (P_USE_QUEUE == 1) {
            ssSetNumPWork(S, 1);
        } else {
            ssSetNumPWork(S,0);
        }

        ssSetNumModes(S, 0);
        ssSetNumNonsampledZCs(S, 0);

        ssSetOptions(S, SS_OPTION_NONVOLATILE);
}



/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    This function is used to specify the sample time(s) for your
 *    S-function. You must register the same number of sample times as
 *    specified in ssSetNumSampleTimes.
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
   int idx;

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


   ssSetCallSystemOutput(S,0); 
}




#undef MDL_START  /* Change to #undef to remove function */
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



#define U(element) (*uPtrs[element])  /* Pointer to Input Port0 */
#define UT(type,element) (*((type *)uPtrs[element])) /* Pointer to Input Port0 */

/* Function: mdlOutputs =======================================================
 * Abstract:
 *    In this function, you compute the outputs of your S-function
 *    block. Generally outputs are placed in the output vector, ssGetY(S).
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{

}

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
   int     queue_len;
   int     use_queue;
   int     type;
   int     module;
   int     buffer;
   int identifier;
   int notification_type;
   double  t;

   queue_len = P_QUEUE_LEN;
   use_queue = P_USE_QUEUE;
   type = P_TYPE;
   module = P_MODULE;
   buffer = P_BUFFER;
   identifier = P_IDENTIFER;
   notification_type = P_NOTIFICATION_TYPE;

   ssWriteRTWParamSettings
       (S, 7,
        SSWRITE_VALUE_DTYPE_NUM, "Module",
        &module,
        DTINFO(SS_INT32,0),
        
        SSWRITE_VALUE_DTYPE_NUM, "Identifier",
        &identifier,
        DTINFO(SS_INT32,0),
        
        SSWRITE_VALUE_DTYPE_NUM, "Type",
        &type,
        DTINFO(SS_INT32,0),
        
        SSWRITE_VALUE_DTYPE_NUM, "Buffer",
        &buffer,
        DTINFO(SS_INT32,0),

        SSWRITE_VALUE_DTYPE_NUM, "UseQueue",
        &use_queue,
        DTINFO(SS_INT32,0),
        
        SSWRITE_VALUE_DTYPE_NUM, "QueueLen",
        &queue_len,
        DTINFO(SS_INT32,0),

        SSWRITE_VALUE_DTYPE_NUM, "NotificationType",
        &notification_type,
        DTINFO(SS_INT32,0)
        ) ;

   /* Reserve an element in the pointers vector for the circular buffer structure
    * in the generated code
    */
   if (P_USE_QUEUE == 1) {
       ssWriteRTWWorkVect(S, "PWork", 1, "pCanRxCircBuffer", 1);
   }
   

}
#endif /* MDL_RTW */
/*======================================================*
 * See sfuntmpl_doc.c for the optional S-function methods *
 *======================================================*/

/*=============================*
 * Required S-function trailer *
 *=============================*/

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
