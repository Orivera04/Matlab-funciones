/*
 *  rtdx_src.c - CMEX S-function, currently functions as a stub
 *               in simulation, and utilizes tlc for code generation
 *
 *  Copyright 2001-2004 The MathWorks, Inc.
 *  $Revision: 1.1.6.3 $ $Date: 2004/04/08 21:08:19 $
 */

#define S_FUNCTION_NAME	rtdx_src
#define S_FUNCTION_LEVEL 2

#include "dsp_sim.h"
#include "dsp_ic_sim.h"

enum {NUM_INPORTS=0};
enum {OUTPORT=0,NUM_OUTPORTS};
enum {CHANNEL_NAME_ARGC=0,
      BLOCKING_ARGC,
      SAMPLE_TIME_ARGC,
      DIMS_ARGC,
      FRAME_ARGC,
      DATA_TYPE_ARGC,
      IC_ARGC, 
	IS_CHANNEL_ENABLED_ARGC,
	IS_HIGHSPEEDRTDX_USED_ARGC,
      NUM_ARGS};

enum {IC_RTP_INDEX, NUM_RTPS};
      
enum {DT_DOUBLE=1,
      DT_SINGLE,
      DT_UINT8,
      DT_INT16,
      DT_INT32};

#define CHANNEL_NAME_ARG(S) (ssGetSFcnParam(S,CHANNEL_NAME_ARGC))
#define BLOCKING_ARG(S)     (ssGetSFcnParam(S,BLOCKING_ARGC))
#define SAMPLE_TIME_ARG(S)  (ssGetSFcnParam(S,SAMPLE_TIME_ARGC))
#define DIMS_ARG(S)         (ssGetSFcnParam(S,DIMS_ARGC))
#define FRAME_ARG(S)        (ssGetSFcnParam(S,FRAME_ARGC))
#define DATA_TYPE_ARG(S)    (ssGetSFcnParam(S,DATA_TYPE_ARGC))
#define IC_ARG(S)           (ssGetSFcnParam(S,IC_ARGC))
#define IS_CHANNEL_ENABLED_ARG(S) (ssGetSFcnParam(S,IS_CHANNEL_ENABLED_ARGC))
#define IS_HIGHSPEEDRTDX_USED_ARG(S) (ssGetSFcnParam(S,IS_HIGHSPEEDRTDX_USED_ARGC))

static DTypeId getOutputDataType(SimStruct *S)
{
    const int_T type = (int_T)mxGetPr(DATA_TYPE_ARG(S))[0];
    DTypeId dtype;

    /* find matching dtype */
    switch (type){
    case DT_DOUBLE:
        dtype = SS_DOUBLE;
        break;
    case DT_SINGLE:
        dtype = SS_SINGLE;
        break;
    case DT_UINT8:
        dtype = SS_UINT8;
        break;
    case DT_INT16:
        dtype = SS_INT16;
        break;
    case DT_INT32:
        dtype = SS_INT32;
        break;
    }
    return dtype;
}
  

#define MDL_CHECK_PARAMETERS
static void mdlCheckParameters(SimStruct *S)
{
    if (!mxIsChar(CHANNEL_NAME_ARG(S))) {
        THROW_ERROR(S, "Channel name must be a string");
    }

    if (!IS_FLINT_IN_RANGE(BLOCKING_ARG(S),0,1)) {
        THROW_ERROR(S,"Blocking must be 0 (off) or 1 (on).");
    }

    if (OK_TO_CHECK_VAR(S, SAMPLE_TIME_ARG(S))) {
        if (!IS_SCALAR_DOUBLE(SAMPLE_TIME_ARG(S)) ||
            (mxGetPr(SAMPLE_TIME_ARG(S))[0] <= (real_T)0.0)
           ) {
            THROW_ERROR(S, "The sample time must be a scalar > 0,");
        }
    }

    /* We must demand that the dimension vector is filled in
     * and resolvable at apply time.  This is because mdlInitSizes
     * MUST have this information in order to init the block.
     */
    {
        static char *dim_msg = "Dimensions must be a 1x2 vector of doubles.";
        const int_T numEle = mxGetNumberOfElements(DIMS_ARG(S));
        int_T i;
        
        if ( mxIsEmpty(DIMS_ARG(S)) ||
            !IS_DOUBLE(DIMS_ARG(S)) ||
            !IS_ROW_VECTOR(DIMS_ARG(S)) ||
            (numEle > 2)) {
            THROW_ERROR(S, dim_msg);
        }
        for (i=0; i<numEle; i++) {
            if (!IS_IDX_FLINT_GE(DIMS_ARG(S),i,1)) THROW_ERROR(S, dim_msg);
        }
    }

    if (!IS_FLINT_IN_RANGE(FRAME_ARG(S),0,1) ) {
        THROW_ERROR(S, "Frame must be 0 (off) or 1 (on).");
    }

    if (!IS_FLINT_IN_RANGE(DATA_TYPE_ARG(S),1,5)) {
        THROW_ERROR(S,"Data type must be: double(1), single(2), "
                      "uint8(3), int16(4), or int32(5).");
    }

    if (!IS_FLINT_IN_RANGE(IS_CHANNEL_ENABLED_ARG(S),0,1)) {
        THROW_ERROR(S,"Checkbox to enable RTDX channel must be 0 (off) or 1 (on).");
    }
}


static void mdlInitializeSizes(SimStruct *S)
{
    REGISTER_SFCN_PARAMS(S,NUM_ARGS);

    /* non-tunable */
    ssSetSFcnParamTunable(S,CHANNEL_NAME_ARGC, 0);
    ssSetSFcnParamTunable(S,BLOCKING_ARGC,     0);
    ssSetSFcnParamTunable(S,SAMPLE_TIME_ARGC,  0);
    ssSetSFcnParamTunable(S,DIMS_ARGC,         0);
    ssSetSFcnParamTunable(S,FRAME_ARGC,        0);
    ssSetSFcnParamTunable(S,DATA_TYPE_ARGC,    0);
    ssSetSFcnParamTunable(S,IC_ARGC,           0);
    ssSetSFcnParamTunable(S,IS_CHANNEL_ENABLED_ARGC, 0);
    ssSetSFcnParamTunable(S,IS_HIGHSPEEDRTDX_USED_ARGC, 0);

    /* input ports */
    if (!ssSetNumInputPorts(S,NUM_INPORTS)) return;

    /* output ports */
    if (!ssSetNumOutputPorts(S,NUM_OUTPORTS)) return;

    {
        const int_T numDims = mxGetNumberOfElements(DIMS_ARG(S));
        const int_T rows    = (int_T)mxGetPr(DIMS_ARG(S))[0];
        const int_T isFrame = (int_T)mxGetPr(FRAME_ARG(S))[0];
        const int_T is1D    = (numDims==1);

        if (is1D && !isFrame) {
            
            /* 1-D only if non-frame output (cannot be a 1-D frame) */
            ssSetOutputPortWidth(S,OUTPORT,rows);

        } else {
            
            /*  Either 2-D dimensions, or frame bit is on
             *  NOTE: if 1-D dims and frame bit on, assume # cols = 1.
             */

            int_T cols = (is1D) ? 1 : (int_T)mxGetPr(DIMS_ARG(S))[1];

            ssSetOutputPortMatrixDimensions(S,OUTPORT,rows,cols);
        }
    }    
    
    ssSetOutputPortFrameData(S,OUTPORT,(int_T)mxGetPr(FRAME_ARG(S))[0]);
    ssSetOutputPortComplexSignal(S,OUTPORT,COMPLEX_NO);
  
#if 0  
    /* NOTE: Be sure to not reuse the output vector!
     * We assign the outputs once, then expect the downstream blocks
     * to not corrupt the data.

     */
    ssSetOutputPortReusable(S,OUTPORT,0);
#endif

    if (mxGetPr(IS_HIGHSPEEDRTDX_USED_ARG(S))[0] == 1)
        ssSetOutputPortOptimOpts(S, OUTPORT, SS_NOT_REUSABLE_AND_GLOBAL);
    //    ssSetOutputPortOptimOpts(S, OUTPORT, SS_REUSABLE_AND_GLOBAL);

    ssSetOutputPortDataType(S,OUTPORT,getOutputDataType(S));

    ssSetNumSampleTimes(S, 1);
    
    /* NOTE: 
     *  We should not use SS_OPTION_USE_TLC_WITH_ACCELERATOR with this block,
     *  since code gen for this block will engage RTDX transfers, and that is
     *  not what the accelerator is intended to do at this point (it should
     *  merely accelerate *simulation* speed).
     */
    ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE);
}


static void mdlInitializeSampleTimes(SimStruct *S)
{
    const real_T Ts = mxGetPr(SAMPLE_TIME_ARG(S))[0];

    /* For a non-frame, just output each matrix at the indicated "per message" sample time.
     * For a frame, the sample time is "per element", and we multiply the sample time 
     *  by the size of the frame (eg, # of rows).
     */
    int_T nRows = ((int_T)mxGetPr(FRAME_ARG(S))[0]) ? (int_T)mxGetPr(DIMS_ARG(S))[0] : 1;

    ssSetSampleTime(S,0,Ts*nRows);
    ssSetOffsetTime(S,0,0.0);
}


#define MDL_SET_WORK_WIDTHS
static void mdlSetWorkWidths(SimStruct *S)
{
    const int_T numICs             = mxGetNumberOfElements(IC_ARG(S));
    const int_T *outputDims        = ssGetOutputPortDimensions(S, OUTPORT);
    const int_T numChannels        = (isOutputFrameBased(S, OUTPORT)) 
                                   ? outputDims[1] 
                                   : ssGetOutputPortWidth(S, OUTPORT);
    const int_T sampsPerChannel    = (isOutputFrameBased(S, OUTPORT)) 
                                   ? outputDims[0] 
                                   : 1;
    const int_T outportNumElems    = numChannels * sampsPerChannel;
    /* Check IC dimensions */
    if ((numICs != 0) && (numICs != 1)              /* scalar */
	              && (numICs != sampsPerChannel)    /* vector */
	              && (numICs != outportNumElems)) { /* matrix */
        THROW_ERROR(S, "Initial condition vector has incorrect dimensions.");
    }

    /* Setup run-time parameters */
    if (!ssSetNumRunTimeParams(S, NUM_RTPS)) {
        THROW_ERROR(S,"Run time parameter allocation failed");
    }

    /* Create run-time parameter info for IC parameter */
    CreateICRTPFromSFcnParam(S, "IC", IC_RTP_INDEX, IC_ARGC, OUTPORT);
}


#define MDL_START
static void mdlStart(SimStruct *S)
{
    const int_T      numICs        = GetRTPNumElements(S, IC_RTP_INDEX);
    const int_T     *ICDimsInfo    = GetRTPDimsInfo(S, IC_RTP_INDEX);
    const int_T      IC_rows       = ICDimsInfo[0];
    const int_T      IC_cols       = ICDimsInfo[1];
    byte_T          *outBuf        = ssGetOutputPortSignal(S, OUTPORT);
    const byte_T    *IC_ptr        = GetRTPDataPtr(S, IC_RTP_INDEX);
    const int_T *outputDims        = ssGetOutputPortDimensions(S, OUTPORT);
    const int_T numChannels        = (isOutputFrameBased(S, OUTPORT)) 
                                   ? outputDims[1] 
                                   : ssGetOutputPortWidth(S, OUTPORT);
    const int_T sampsPerChannel    = (isOutputFrameBased(S, OUTPORT)) 
                                   ? outputDims[0] 
                                   : 1;
    const int_T outportNumElems    = numChannels * sampsPerChannel;
    const int_T  bytesPerRealElem  = ssGetDataTypeSize(S, ssGetOutputPortDataType(S,OUTPORT));
    const int_T  bytesPerElement   = ((isOutputComplex(S, OUTPORT)) ? 2 : 1) * bytesPerRealElem;

    RETURN_IF_ERROR(S);

    /* Preset output buffers to initial conditions: */
    if (numICs <= 1) {
        /* Scalar expansion */

        MWDSP_CopyScalarICs( outBuf, IC_ptr, outportNumElems, bytesPerElement );

    } else if (numICs == sampsPerChannel) {
        /* Vector ICs, same vector for all channels */
        const int_T bytesPerChannel = bytesPerElement * sampsPerChannel;

        MWDSP_CopyVectorICs( outBuf, IC_ptr, numChannels, bytesPerChannel );

    } else if ((IC_rows == sampsPerChannel) && (IC_cols == numChannels)){
        /* Matrix ICs */
        MWDSP_CopyMatrixICs( outBuf, IC_ptr, outportNumElems, bytesPerElement );
    }
}


static void mdlOutputs(SimStruct *S, int_T tid)
{
}


static void mdlTerminate(SimStruct *S)
{
    ParamRecFreeAll(S);
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
    boolean_T isBlocking = (mxGetPr(BLOCKING_ARG(S))[0] == 1);
    boolean_T isEnabled = (mxGetPr(IS_CHANNEL_ENABLED_ARG(S))[0] == 1);
    RETURN_IF_ERROR(S);

    if (mxGetString(CHANNEL_NAME_ARG(S), chanName, buflen) != 0) {
        slFree(chanName);
        THROW_ERROR(S, "Channel name was truncated.");
    }

    /* Non-tunable parameters */
    if (!ssWriteRTWParamSettings(S, 3,
        	SSWRITE_VALUE_QSTR, "ChannelName", chanName,
        	SSWRITE_VALUE_DTYPE_NUM, "isBlocking", &isBlocking, DTINFO(SS_BOOLEAN,COMPLEX_NO),
        	SSWRITE_VALUE_DTYPE_NUM, "IsChannelEnabled", &isEnabled, DTINFO(SS_BOOLEAN, COMPLEX_NO)
        )) {
        slFree(chanName);
        return;
    }

    slFree(chanName);
}
#endif

#include "dsp_trailer.c"

/* [EOF] rtdx_src.c */

