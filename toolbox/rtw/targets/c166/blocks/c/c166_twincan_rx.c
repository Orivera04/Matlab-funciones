/*
 * File: c166_twincan_rx.c
 *
 * Abstract:
 *    S-function for TwinCAN Receive block
 *   
 *
 * $Revision: 1.1.6.2 $
 * $Date: 2004/04/19 01:17:32 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 */

/*
 * You must specify the S_FUNCTION_NAME as the name of your S-function
 * (i.e. replace sfuntmpl_basic with the name of your S-function).
 */

#define S_FUNCTION_NAME c166_twincan_rx 
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

//P1
#define P_MODULE       ((int)mxGetScalar(ssGetSFcnParam(S,0)))

//P2
#define P_IDS_REF      mxGetPr(ssGetSFcnParam(S,1))
#define P_IDS(idx)     ((int)( P_IDS_REF[(idx)] ) )
#define N_IDS          mxGetNumberOfElements(ssGetSFcnParam(S,1))

//P3
#define P_SAMPLE_TIME  ssGetSFcnParam(S,2)

//P4
#define P_TYPE         ((int)mxGetScalar(ssGetSFcnParam(S,3)))

//P5
#define P_BUFFERS_REF   mxGetPr(ssGetSFcnParam(S,4))
#define P_BUFFERS(idx) ((int)( P_BUFFERS_REF[(idx)] ) )
#define N_BUFFERS       mxGetNumberOfElements(ssGetSFcnParam(S,4))


#define P_NPARMS    5 


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
        ssSetOutputPortWidth(S,0,N_IDS);
        ssSetOutputPortOptimOpts(S,0, SS_REUSABLE_AND_LOCAL);
        ssSetOutputPortWidth(S,1,N_IDS);
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
        ssSetNumPWork(S, 0);
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


   for(idx=0;idx<N_IDS;idx++){
      ssSetCallSystemOutput(S,idx); 
   }
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
   int     type;
   int     module;
   double  t;

   type = P_TYPE;
   module = P_MODULE;

   ssWriteRTWParamSettings(S,4,
         SSWRITE_VALUE_DTYPE_NUM, "Module",
         &module,
         DTINFO(SS_INT32,0),

         SSWRITE_VALUE_DTYPE_VECT, "IDS",
         P_IDS_REF,
         N_IDS,
         DTINFO(SS_INT32,0),

         SSWRITE_VALUE_DTYPE_NUM, "Type",
         &type,
         DTINFO(SS_INT32,0),

         SSWRITE_VALUE_DTYPE_VECT, "Buffers",
         P_BUFFERS_REF,
         N_BUFFERS,
         DTINFO(SS_INT32,0)

        ) ;

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
