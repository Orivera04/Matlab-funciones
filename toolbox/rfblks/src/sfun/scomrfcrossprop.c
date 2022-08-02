/*
 * SCOMRFCROSSPROP RF Blockset block to cross-propagate attributes
 *
 *   Copyright 2004 The MathWorks, Inc.
 *   $Revision: 1.1.6.1 $ $Date: 2004/02/09 08:40:52 $
 */

#define S_FUNCTION_NAME scomrfcrossprop
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"

enum {NUM_ARGS};
enum {NUM_INPORTS=2};
enum {NUM_OUTPORTS};
enum {INPUT_1, INPUT_2};

/* Function: mdlInitializeSizes ===============================================*/
static void mdlInitializeSizes(SimStruct *S)
{
    
    ssSetNumSFcnParams(S,NUM_ARGS);

    #if defined(MATLAB_MEX_FILE)
        if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) return;
        if (ssGetErrorStatus(S) != NULL) return;
    #endif

    if (!ssSetNumInputPorts(S, NUM_INPORTS)) return;
    if (!ssSetNumOutputPorts(S, NUM_OUTPORTS)) return;

     /*Dynamically size inport 1, inherit frame data, sample time, complexity*/
     if(!ssSetInputPortDimensionInfo(S, INPUT_1, DYNAMIC_DIMENSION)) return;
     ssSetInputPortFrameData(S,INPUT_1,FRAME_INHERITED);
     ssSetInputPortComplexSignal(S,INPUT_1,COMPLEX_INHERITED);   
   
     /*Dynamically size inport 1, inherit frame data, sample time, complexity*/
    if(!ssSetInputPortDimensionInfo(S, INPUT_2, DYNAMIC_DIMENSION)) return;
    ssSetInputPortFrameData(S,INPUT_2,FRAME_INHERITED);
    ssSetInputPortComplexSignal(S,INPUT_2, COMPLEX_INHERITED);

    /* One Sample time for this block*/
    ssSetNumSampleTimes(S, PORT_BASED_SAMPLE_TIMES);

    ssSetInputPortSampleTime(S, INPUT_1, INHERITED_SAMPLE_TIME);
    ssSetInputPortSampleTime(S, INPUT_2, INHERITED_SAMPLE_TIME);
}

/* End of mdlInitializeSizes(SimStruct *S) */

#if defined(MATLAB_MEX_FILE)
#define MDL_SET_INPUT_PORT_DIMENSION_INFO
/*Function: mdlSetInputPortDimensionInfo========================================*/
static void mdlSetInputPortDimensionInfo(SimStruct *S,int_T port, const DimsInfo_T *dimsInfo)
{
    int       otherPort;

    /* Set the port prop */
    ssSetInputPortDimensionInfo(S, port, dimsInfo);

    if (port==INPUT_1) {
        otherPort = INPUT_2;
    } else {
        otherPort = INPUT_1;
    }
     ssSetInputPortDimensionInfo(S, otherPort, dimsInfo);

}
#endif

#if defined(MATLAB_MEX_FILE)
#define MDL_SET_INPUT_PORT_SAMPLE_TIME
/*Function: mdlSetInputPortSampleTime ===========================================*/
static void mdlSetInputPortSampleTime(SimStruct *S, int_T port, real_T sampleTime, real_T offsetTime)
{

     /*Set both sample times and offsets to match port 1*/
    int       otherPort;

    /* Set the port prop */
    ssSetInputPortSampleTime(S, port, sampleTime);
    ssSetInputPortOffsetTime(S, port, offsetTime);

    if (port==INPUT_1) {
        otherPort = INPUT_2;
    } else {
        otherPort = INPUT_1;
    }
    ssSetInputPortSampleTime(S, otherPort, sampleTime);
    ssSetInputPortOffsetTime(S, otherPort, offsetTime);
          
}
#endif
/*End of mdlSetInputPortSampleTime*/

#if defined(MATLAB_MEX_FILE)
#define MDL_SET_OUTPUT_PORT_SAMPLE_TIME
/*Function: mdlSetOutputPortSampleTime==========================================*/
static void mdlSetOutputPortSampleTime(SimStruct *S, int_T port, real_T sampleTime, real_T offset_Tims)
{
    /* Do nothing*/
}
#endif
/*End of mdlSetOutputPortSampleTime*/

/* Function: mdlInitializeSampleTimes =========================================*/
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetModelReferenceSampleTimeInheritanceRule(S, USE_DEFAULT_FOR_DISCRETE_INHERITANCE);
}

#if defined (MATLAB_MEX_FILE)
#define MDL_SET_INPUT_PORT_COMPLEX_SIGNAL
/* Fuunction: mdlSetInputPortComlpexSignal =====================================*/
static void mdlSetInputPortComplexSignal(SimStruct *S, int_T port, CSignal_T csig)
{
    int       otherPort;
    CSignal_T csigOther;

    /* Set the port prop */
    ssSetInputPortComplexSignal(S, port, csig);

    if (port==INPUT_1) {
        otherPort = INPUT_2;
    } else {
        otherPort = INPUT_1;
    }
     ssSetInputPortComplexSignal(S, otherPort, csig);  
}
#endif
/*End of mdlSetInputPortComplexSignal*/

/* Function: mdlOutputs =======================================================*/
static void mdlOutputs(SimStruct *S, int_T tid)
{
    /*No outputs*/
}

/* Function: mdlTerminate ===============================================*/
static void mdlTerminate(SimStruct *S)
{
}

#ifdef  MATLAB_MEX_FILE
#include "simulink.c"
#else
#include "cg_sfun.h"
#endif
