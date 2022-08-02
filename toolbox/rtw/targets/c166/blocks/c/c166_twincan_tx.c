/*
 * File: c166_twincan_tx.c
 *
 * Abstract:
 *   
 *
 * $Revision: 1.1.6.3 $
 * $Date: 2004/04/19 01:17:34 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 */

/*
 * You must specify the S_FUNCTION_NAME as the name of your S-function
 * (i.e. replace sfuntmpl_basic with the name of your S-function).
 */

#define S_FUNCTION_NAME c166_twincan_tx 
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
 * Parameters
 *===================*/

enum { E_MODULE = 0, E_TX_MODE, E_FIFO_QUEUE_LENGTH, E_BUFFERS, E_INT_LEVEL, E_SAMPLE_TIME, P_NPARMS };

#define P_MODULE           ((int)mxGetScalar(ssGetSFcnParam(S,E_MODULE)))

#define P_INT_LEVEL           ((int)mxGetScalar(ssGetSFcnParam(S,E_INT_LEVEL)))

#define P_TX_MODE      ( (int) mxGetScalar(ssGetSFcnParam(S,E_TX_MODE)) )

#define P_FIFO_QUEUE_LENGTH ( (int) mxGetScalar(ssGetSFcnParam(S, E_FIFO_QUEUE_LENGTH)) )

#define P_BUFFERS_REF  mxGetPr(ssGetSFcnParam(S,E_BUFFERS))

#define N_BUFFERS      mxGetNumberOfElements(ssGetSFcnParam(S,E_BUFFERS))

#define P_SAMPLE_TIME  ssGetSFcnParam(S,E_SAMPLE_TIME)


/* Values assigned to popup items in block mask */
#define TX_MODE_DIRECT 1
#define TX_MODE_FIFO 2


/* -----LOCAL DECLARATIONS-------------------------------------- */

static boolean_T isAcceptableDataType(SimStruct *, DTypeId);

/* -----OPTIONAL FUNCTIONS-------------------------------------- */


static boolean_T isAcceptableDataType(SimStruct * S, DTypeId dataType) {

    int_T     canExDT      = ssGetDataTypeId(S,SL_CAN_EXTENDED_FRAME_DTYPE_NAME );
    int_T     canStDT      = ssGetDataTypeId(S,SL_CAN_STANDARD_FRAME_DTYPE_NAME );
    boolean_T isAcceptable = (dataType == canExDT || dataType == canStDT );

    return isAcceptable;
}

#ifdef MATLAB_MEX_FILE

#define MDL_SET_INPUT_PORT_DATA_TYPE
static void mdlSetInputPortDataType(SimStruct *S, int_T port, DTypeId dataType) {

    if ( port == 0 ) {
        if( isAcceptableDataType( S, dataType ) ) {
            /*
             * Accept proposed data type if it is a CAN Extended or CAN
             * Standard. 
             */
            ssSetInputPortDataType(  S, 0, dataType );

        } else {
            /* Reject proposed data type */
            ssSetErrorStatus(S,"The TwinCAN Transmit block cannot be grounded or left unconnected. "
                               "Valid inputs are 'CAN_MESSAGE_STANDARD' or 'CAN_MESSAGE_EXTENDED' "
                               "Simulink datatypes. Please connect the block correctly, for example "
                               "by using one of the CAN Message Packing blocks from the CAN Message "
                               "Blocks library.");
            goto EXIT_POINT;
        }
    } else {
        /*
         * Should not end up here.  Simulink will only call this function
         * for existing input ports whose data types are unknown.
         */
        ssSetErrorStatus(S, "Error setting input port data type.");
        goto EXIT_POINT;
    }

EXIT_POINT:
    return;
} /* mdlSetInputPortDataType */


#define MDL_SET_DEFAULT_PORT_DATA_TYPES
static void mdlSetDefaultPortDataTypes(SimStruct *S) {

    int_T canStDT = ssGetDataTypeId(S,SL_CAN_STANDARD_FRAME_DTYPE_NAME );
    ssSetInputPortDataType(  S, 0, canStDT );

} /* mdlSetDefaultPortDataTypes */

#endif /* MATLAB_MEX_FILE */


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


        ssSetNumInputPorts(S,1);

        ssSetNumOutputPorts(S,0);

        if ( P_TX_MODE == TX_MODE_FIFO ) {
            ssSetInputPortWidth(S,0,DYNAMICALLY_SIZED);
        } else {
            /* Enforce inport width = 1 if using dedicated transmit buffer */
            ssSetInputPortWidth(S,0,1);
        }
         ssSetInputPortOptimOpts(S,0,SS_REUSABLE_AND_LOCAL);
        ssSetInputPortOverWritable(S,0,1);

        ssSetInputPortDataType (S,0,DYNAMICALLY_TYPED);

        ssSetInputPortDirectFeedThrough(S,0,true);

        ssSetNumContStates(S, 0);
        ssSetNumDiscStates(S, 0);


        ssSetNumSampleTimes(S, 1);
        ssSetNumRWork(S, 0);
        ssSetNumIWork(S, 0);

        if (P_TX_MODE == TX_MODE_FIFO) {
            /* Use PWork item to hold pointer to circular buffer structure */
            ssSetNumPWork(S, 1);
        } else {
            ssSetNumPWork(S, 0);
        }

        ssSetNumModes(S, 0);
        ssSetNumNonsampledZCs(S, 0);

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
    int     module = P_MODULE;
    int     int_level = P_INT_LEVEL;
    int     tx_mode = P_TX_MODE;
    int     fifo_queue_length = P_FIFO_QUEUE_LENGTH;
    
    
    ssWriteRTWParamSettings(S,5,
                            SSWRITE_VALUE_DTYPE_NUM, "Module",
                            &module,
                            DTINFO(SS_INT32,0),
                           
                            SSWRITE_VALUE_DTYPE_NUM, "IntLevel",
                            &int_level,
                            DTINFO(SS_INT32,0),
                           
                            SSWRITE_VALUE_DTYPE_NUM, "FifoQueueLength",
                            &fifo_queue_length,
                            DTINFO(SS_INT32,0),
                            
                            SSWRITE_VALUE_DTYPE_NUM, "TxMode",
                            &tx_mode,
                            DTINFO(SS_INT32,0),
                            
                            SSWRITE_VALUE_DTYPE_VECT, "Buffers",
                            P_BUFFERS_REF,
                            N_BUFFERS,
                            DTINFO(SS_INT32,0)
	);

    /* Reserve an element in the pointers vector for the circular buffer structure
     * in the generated code
     */
    if (P_TX_MODE == TX_MODE_FIFO) {
        ssWriteRTWWorkVect(S, "PWork", 1, "pCanTxCircBuffer", 1);
    }
}
#endif



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
