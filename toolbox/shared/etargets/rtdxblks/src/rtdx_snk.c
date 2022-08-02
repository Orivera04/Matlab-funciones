/*
 *  rtdx_snk.c - CMEX S-function, currently functions as a stub
 *               in simulation, and utilizes tlc for code generation
 *
 *  Copyright 2001-2004 The MathWorks, Inc.
 *  $Revision: 1.1.6.3 $ $Date: 2004/04/08 21:08:18 $
 */

#define S_FUNCTION_LEVEL 2
#define S_FUNCTION_NAME	rtdx_snk

#include "dsp_sim.h"

enum {INPORT=0,NUM_INPORTS};
enum {NUM_OUTPORTS=0};
enum {CHANNEL_NAME_ARGC=0, 
	IS_CHANNEL_ENABLED_ARGC, 
	NUM_ARGS};

#define CHANNEL_NAME_ARG(S) (ssGetSFcnParam(S,CHANNEL_NAME_ARGC))
#define IS_CHANNEL_ENABLED_ARG(S) (ssGetSFcnParam(S,IS_CHANNEL_ENABLED_ARGC))
  
static void CheckInputDataType(SimStruct *S)
{
    int_T isValid;

    switch (ssGetInputPortDataType(S,INPORT))
    {
        case SS_DOUBLE:
        case SS_SINGLE:
        case SS_UINT8:
        case SS_INT16:
        case SS_INT32:
            isValid = 1;
            break;
        default:
            isValid = 0;
            break;
    }
    if(!isValid) {
        THROW_ERROR(S,"Input data type must be either"
                      " double, single, uint8, int16 or int32.");
    }
}


#define MDL_CHECK_PARAMETERS
static void mdlCheckParameters(SimStruct *S)
{
    if (!mxIsChar(CHANNEL_NAME_ARG(S))) {
        THROW_ERROR(S, "Channel name must be a string.");
    }
    if (!IS_FLINT_IN_RANGE(IS_CHANNEL_ENABLED_ARG(S),0,1)) {
        THROW_ERROR(S,"Checkbox to enable RTDX channel must be 0 (off) or 1 (on).");
    }
}


static void mdlInitializeSizes(SimStruct *S)
{
    REGISTER_SFCN_PARAMS(S,NUM_ARGS);

    /* non-tunable parameters */
    ssSetSFcnParamTunable(S,CHANNEL_NAME_ARGC, 0);
    ssSetSFcnParamTunable(S,IS_CHANNEL_ENABLED_ARGC, 0);

    /* initialize input port(s) */
    if (!ssSetNumInputPorts(S, NUM_INPORTS)) return;

    if (!ssSetInputPortDimensionInfo(S, INPORT, DYNAMIC_DIMENSION)) return;

    ssSetInputPortReusable(          S, INPORT, 1);
    ssSetInputPortFrameData(         S, INPORT, FRAME_INHERITED);
    ssSetInputPortDataType(          S, INPORT, DYNAMICALLY_TYPED);
    ssSetInputPortComplexSignal(     S, INPORT, COMPLEX_NO);
    ssSetInputPortDirectFeedThrough( S, INPORT, 1);            /* Accessing inputs during mdlOutput */

    /* initialize output port(s) */
    if (!ssSetNumOutputPorts(S,NUM_OUTPORTS)) return;

    /* intialize number of sample times */
    ssSetNumSampleTimes(S, 1);
}


static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, INHERITED_SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0.0);
}
      

#ifdef MATLAB_MEX_FILE
#define MDL_SET_INPUT_PORT_DIMENSION_INFO
static void mdlSetInputPortDimensionInfo(SimStruct *S, 
                                      int_T port,
                                      const DimsInfo_T *portInfo)
{
    if (!ssSetInputPortDimensionInfo(S, port, portInfo)) return;
}


#define MDL_SET_INPUT_PORT_FRAME_DATA
static void mdlSetInputPortFrameData(SimStruct *S, 
                                     int_T     port,
                                     Frame_T   frameData)
{
    ssSetInputPortFrameData(S, port, frameData);
}


#define MDL_SET_INPUT_PORT_DATA_TYPE
static void mdlSetInputPortDataType(SimStruct *S,
                                    int_T     portIdx,
                                    DTypeId   inputPortDataType)
{
    ssSetInputPortDataType(S, portIdx, inputPortDataType);

    CheckInputDataType(S);
}
#endif /* MATLAB_MEX_FILE */


static void mdlOutputs(SimStruct *S, int_T tid)
{
}	


static void mdlTerminate(SimStruct *S)
{
}


#if defined(MATLAB_MEX_FILE) || defined(NRT)
#define MDL_RTW
static void mdlRTW(SimStruct *S)
{
    /*
     * buflen is the length of the string
     *
     * NOTE: We use mxCalloc here, not slCalloc, since we want MATLAB
     * to free up this memory when the MEX function returns.  We do
     * not have an opportunity to free this allocation, so we rely on
     * MATLAB to do it for us.
     */
    int_T buflen = 1 + mxGetNumberOfElements(CHANNEL_NAME_ARG(S));

    char_T *chanName = (char_T *)slCalloc(S, buflen, sizeof(char_T));
    boolean_T isEnabled = (mxGetPr(IS_CHANNEL_ENABLED_ARG(S))[0] == 1);
    RETURN_IF_ERROR(S);

    if (mxGetString(CHANNEL_NAME_ARG(S), chanName, buflen) != 0) {
        slFree(chanName);
        THROW_ERROR(S, "Channel name was truncated.");
    }

    /* Non-tunable parameters */
    if (!ssWriteRTWParamSettings(S, 2,
        	SSWRITE_VALUE_QSTR, "ChannelName", chanName, 
		SSWRITE_VALUE_DTYPE_NUM, "IsChannelEnabled", &isEnabled, DTINFO(SS_BOOLEAN, COMPLEX_NO)
	  )) {
        slFree(chanName);
        return;
    }

    slFree(chanName);}
#endif

#include "dsp_trailer.c"

/* [EOF] rtdx_snk.c */
