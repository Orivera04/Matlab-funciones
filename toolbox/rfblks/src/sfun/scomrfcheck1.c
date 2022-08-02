/*
* SCOMRFCHECK1 RF Blockset S-Function for
* checking input sample time and complexity.
*
*  Copyright 2003-2004 The MathWorks, Inc.
*  $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:40:29 $
*/

#define  S_FUNCTION_NAME  scomrfcheck1
#define  S_FUNCTION_LEVEL 2

#include "simstruc.h"

/* List input & output ports*/
enum {INPORT=0, NUM_INPORTS};

enum {TSAMPC=0, NUM_ARGS};

#define TSAMP(S) (ssGetSFcnParam(S,TSAMPC))
#define THROW_ERROR(S,MSG) {ssSetErrorStatus(S,MSG); return;}


/* Function: mdlInitializeSizes  =============================================*/
static void mdlInitializeSizes(SimStruct *S)
{
  ssSetNumSFcnParams(S, NUM_ARGS);

  if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) return;
      
  ssSetNumInputPorts( S, 1);
  ssSetNumOutputPorts(S, 0);
 
  ssSetNumSampleTimes(S, PORT_BASED_SAMPLE_TIMES);

  ssSetInputPortDirectFeedThrough( S, INPORT, 1);
  ssSetInputPortReusable(          S, INPORT, 1);
  ssSetInputPortRequiredContiguous(S, INPORT, 0);
  ssSetInputPortOverWritable(      S, INPORT, 1);
  ssSetInputPortFrameData(         S, INPORT, FRAME_INHERITED);
  ssSetInputPortComplexSignal(     S, INPORT, COMPLEX_YES);
  ssSetInputPortDataType(          S, INPORT, DYNAMICALLY_TYPED);
  ssSetInputPortDimensionInfo(     S, INPORT, DYNAMIC_DIMENSION);
  ssSetInputPortSampleTime(        S, INPORT, INHERITED_SAMPLE_TIME);


  ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE      |
                  SS_OPTION_NONVOLATILE              |
                  SS_OPTION_WORKS_WITH_CODE_REUSE    |
                  SS_OPTION_ALLOW_PORT_SAMPLE_TIME_IN_TRIGSS);
  

  ssSetSFcnParamTunable(S, TSAMPC, 0);
}
 /* End  of mdlInitializeSizes(SimStruct  *S) */

/* Function: mdlInitializeSampleTimes ========================================*/
static void mdlInitializeSampleTimes(SimStruct *S)
{
}

#define MDL_SET_INPUT_PORT_SAMPLE_TIME
static void mdlSetInputPortSampleTime(SimStruct *S,
                                      int_T     portIdx,
                                      real_T    sampleTime,
                                      real_T    offsetTime)
{
	  real_T Tset;
    real_T Tget;

    ssSetInputPortSampleTime(S, portIdx, sampleTime);
    ssSetInputPortOffsetTime(S, portIdx, offsetTime);

		Tset = ssGetInputPortWidth(S, INPORT)*mxGetPr(TSAMP(S))[0];
		Tget = ssGetInputPortSampleTime(S, INPORT);

    if (ssGetInputPortConnected(S, INPORT)) {
        if (Tset != Tget) {
           THROW_ERROR(S, "Sample time of input to RF block incorrectly specified.");
        }
    }
}

#define MDL_SET_OUTPUT_PORT_SAMPLE_TIME
static void mdlSetOutputPortSampleTime(SimStruct *S,
                                       int_T     portIdx,
                                       real_T    sampleTime,
                                       real_T    offsetTime)
{
}

/* Function: mdlOutputs  =====================================================*/
static void mdlOutputs(SimStruct *S, int_T tid)
{
    UNUSED_ARG(S);
    UNUSED_ARG(tid);
}
/* End of mdlOutputs (SimStruct  *S, int_T tid) */

static void mdlTerminate(SimStruct *S)
{
    UNUSED_ARG(S);
}


#ifdef  MATLAB_MEX_FILE
#include "simulink.c"
#else
#include "cg_sfun.h"
#endif

