/*
 *   HC12_SFCN_ADC_V C-MEX S-function for HC12 Analog to Digital Converter
 *   supporting vectored signals.
 *                  
 *  Copyright 2002-2004 The MathWorks, Inc.
 *  $Revision: 1.1.6.4 $  
 *  $Date: 2004/04/19 01:23:22 $
 */

/*=====================================*
 * Required setup for C MEX S-Function *
 *=====================================*/

#define S_FUNCTION_NAME  hc12_sfcn_adc_v
#define S_FUNCTION_LEVEL 2


/* define error messages */
#define ERR_INVALID_SET_INPUT_DTYPE_CALL  \
              "Invalid call to mdlSetInputPortDataType"

#define ERR_INVALID_SET_OUTPUT_DTYPE_CALL \
              "Invalid call to mdlSetOutputPortDataType"

#define ERR_INVALID_DTYPE     "Invalid input or output port data type"


/*========================*
 * General Defines/macros *
 *========================*/

/*
 * Need to include simstruc.h for the definition of the SimStruct and
 * its associated macro definitions.
 */
#include "simstruc.h" 

#define TRUE    1
#define FALSE   0

/* Total number of block parameters */
#define N_PAR   5 

/* 
 *  CHANNELARRAY_ARG  - Array of ADC channels (one or more values between 0 and 7) 
 *                      Signal width is also determined from this list
 *  SAMPLETIME(S)     - Sample time
 %  ATDBANK(S)        - Bank 0, or Bank 1. Each bank provides 8 channels.
 *  USE10BITS(S)       - If (USE10BITS_ARGC==1), use 10-bits of ADC resolution
 *                      otherwise, use 8-bits ADC resolution
 *  LEFTJUSTIFY(S)    - If (LEFTJUSTIFY_ARGC==1), left justify the result in 
 *                      16-bit word. Else, use right justification (default)
 */

enum {ATDBANK_ARGC=0, CHANNELARRAY_ARGC, USE10BITS_ARGC, LEFTJUSTIFY_ARGC, SAMPLETIME_ARGC};

#define ATDBANK(S)          (mxGetScalar(ssGetSFcnParam(S,ATDBANK_ARGC)))
#define CHANNELARRAY_ARG(S) (ssGetSFcnParam(S,CHANNELARRAY_ARGC))
#define USE10BITS(S)        (mxGetScalar(ssGetSFcnParam(S,USE10BITS_ARGC)))
#define LEFTJUSTIFY(S)      (mxGetScalar(ssGetSFcnParam(S,LEFTJUSTIFY_ARGC)))
#define SAMPLETIME(S)       (mxGetScalar(ssGetSFcnParam(S,SAMPLETIME_ARGC)))


/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *   Initialize the sizes array
 */
static void mdlInitializeSizes(SimStruct *S)
{
    const unsigned int *paramPtr = mxGetData( CHANNELARRAY_ARG(S) );
    int nChannels;
    /* Set and Check parameter count  */
      
    ssSetNumSFcnParams(S, N_PAR);
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) return;
    ssSetSFcnParamNotTunable(S, 0);
    ssSetSFcnParamNotTunable(S, 1);
    ssSetSFcnParamNotTunable(S, 2);
    ssSetSFcnParamNotTunable(S, 3);
    ssSetSFcnParamNotTunable(S, 4);

    nChannels  = mxGetNumberOfElements( CHANNELARRAY_ARG(S) );

    /* Single input port of width equal to nChannels */
    if ( !ssSetNumInputPorts(  S, 1 ) ) return;
    ssSetInputPortWidth(       S, 0, nChannels );

    /* Single output port of width equal to nChannels */
    if ( !ssSetNumOutputPorts( S, 1 ) ) return;
    ssSetOutputPortWidth(      S, 0, nChannels );

   /* Set datatypes on input and output ports relative
    * to users choice of 8-, or, 10-bit resolution.
    */
    if (USE10BITS(S))
    {   
       /* 
        * Input and output datatypes are uint16
        * when using 10-bit ADC resolution 
        */
        ssSetInputPortDataType(  S, 0, SS_UINT16 );
        ssSetOutputPortDataType( S, 0, SS_UINT16 );
    } else {
       /* 
        * Input and output datatypes are uint8
        * when using 8-bit ADC resolution 
        */
        ssSetInputPortDataType(  S, 0, SS_UINT8 );
        ssSetOutputPortDataType( S, 0, SS_UINT8 );
    }
    
    ssSetInputPortDirectFeedThrough( S, 0, TRUE );

    /* sample times */
    ssSetNumSampleTimes( S, 1 );
    
    /* options */
    ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE);  
    } /* end mdlInitializeSizes */


/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    Initialize the sample times array.
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime( S, 0, SAMPLETIME(S) ); 
    
} /* end mdlInitializeSampleTimes */


/* Function: mdlOutputs =======================================================
 * Abstract:
 *   Compute the outputs of the S-function.
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
    /* 
     * Get "uPtrs" for input port 0 and 1.  
     * uPtrs is essentially a vector of pointers because the input signal may 
     * not be contiguous.  
     */
    
    DTypeId   y0DataType;   /* SS_UINT8 or SS_UINT16 */
    int_T     y0Width    = ssGetOutputPortWidth(S, 0);
    InputPtrsType u0Ptrs = ssGetInputPortSignalPtrs(S,0);
    
    /* 
     * Get data type Identifier for output port 0. 
     * This matches the data type ID for input port 0.
     */
     
    y0DataType = ssGetOutputPortDataType(S, 0);

    /* 
     * Set output signals equal to input signals
     * for either 16 bit, or 8 bit signals.
     */
     
    switch (y0DataType)
    {
        case SS_UINT8:
        {
            uint8_T           *pY0 = (uint8_T *)ssGetOutputPortSignal(S,0);
            InputUInt8PtrsType pU0 = (InputUInt8PtrsType)u0Ptrs;
            int     i;
            /* Set all outputs equal to inputs */
            for( i = 0; i < y0Width; ++i){
                pY0[i] = *pU0[i];
                /* For 8-bit ADC results, left-justify is ignored. */
            }
            break;
        }
        case SS_UINT16:
        {
            uint16_T           *pY0 = (uint16_T *)ssGetOutputPortSignal(S,0);
            InputUInt16PtrsType pU0 = (InputUInt16PtrsType)u0Ptrs;
            int     i; 
        
            for( i = 0; i < y0Width; ++i){              
                /* Set all outputs equal to inputs */
                if (LEFTJUSTIFY(S)) {
                    /* Shift left for left justify */
                    pY0[i] = *pU0[i]<<6;
                } else {
                    /* No shift required for right justify */
                    pY0[i] = *pU0[i];
                }
            }                                        
            break;
        }
    } /* end switch (y0DataType) */

} /* end mdlOutputs */


/* Function: mdlTerminate =====================================================
 * Abstract:
 *    Called when the simulation is terminated.
 */
static void mdlTerminate(SimStruct *S)
{
} /* end mdlTerminate */


/* Function: isAcceptableDataType
 *    Determine if the data type ID corresponds to an 8 or 16 bit unsigned int
 */
static boolean_T isAcceptableDataType(DTypeId dataType) 
{
    boolean_T isAcceptable = (dataType == SS_UINT8  || 
                              dataType == SS_UINT16);
    return isAcceptable;
}


#define MDL_SET_INPUT_PORT_DATA_TYPE
/* Function: mdlSetInputPortDataType ==========================================
 *    This routine is called with the candidate data type for a dynamically
 *    typed port.  If the proposed data type is acceptable, the routine should
 *    go ahead and set the actual port data type using ssSetInputPortDataType.
 *    If the data tyoe is unacceptable an error should generated via
 *    ssSetErrorStatus.  Note that any other dynamically typed input or
 *    output ports whose data types are implicitly defined by virtue of knowing
 *    the data type of the given port can also have their data types set via 
 *    calls to ssSetInputPortDataType or ssSetOutputPortDataType.
 */
static void mdlSetInputPortDataType(SimStruct *S, 
                                    int       port, 
                                    DTypeId   dataType)
{
    if ( port == 0 ) {
        if( isAcceptableDataType( dataType ) ) {
            /*
             * Accept proposed data type if it is an unsigned integer type
             * force all data ports to use this data type.
             */
            ssSetInputPortDataType(  S, 0, dataType );               
            ssSetOutputPortDataType( S, 0, dataType );            
        } else {
            /* Reject proposed data type */
            ssSetErrorStatus(S,ERR_INVALID_DTYPE);
            goto EXIT_POINT;
        }
    } else {
        /* 
         * Should not end up here.  Simulink will only call this function
         * for existing input ports whose data types are unknown.
         */
        ssSetErrorStatus(S, ERR_INVALID_SET_INPUT_DTYPE_CALL);
        goto EXIT_POINT;
    }

EXIT_POINT:
    return;
} /* mdlSetInputPortDataType */


#define MDL_SET_OUTPUT_PORT_DATA_TYPE
/* Function: mdlSetOutputPortDataType =========================================
 *    This routine is called with the candidate data type for a dynamically
 *    typed port.  If the proposed data type is acceptable, the routine should
 *    go ahead and set the actual port data type using ssSetOutputPortDataType.
 *    If the data tyoe is unacceptable an error should generated via
 *    ssSetErrorStatus.  Note that any other dynamically typed input or
 *    output ports whose data types are implicitly defined by virtue of knowing
 *    the data type of the given port can also have their data types set via 
 *    calls to ssSetInputPortDataType or ssSetOutputPortDataType.
 */
static void mdlSetOutputPortDataType(SimStruct *S, 
                                     int       port, 
                                     DTypeId   dataType)
{
    if ( port == 0 ) {
        if( isAcceptableDataType( dataType ) ) {
            /*
             * Accept proposed data type if it is an unsigned integer type
             * force all the ports to use this data type.
             */
            ssSetInputPortDataType(  S, 0, dataType );                    
            ssSetOutputPortDataType( S, 0, dataType );            
        } else {
            /* reject proposed data type */
            ssSetErrorStatus(S,ERR_INVALID_DTYPE);
            goto EXIT_POINT;
        }
    } else {
        /* 
         * Should not end up here.  Simulink will only call this function
         * for existing output ports whose data types are unknown.  
         */
        ssSetErrorStatus(S, ERR_INVALID_SET_OUTPUT_DTYPE_CALL);
        goto EXIT_POINT;
    }

EXIT_POINT:
    return;

} /* mdlSetOutputPortDataType */

#define MDL_SET_DEFAULT_PORT_DATA_TYPES
/* Function: mdlSetDefaultPortDataTypes ========================================
 *    This routine is called when Simulink is not able to find data type 
 *    candidates for dynamically typed ports. This function must set the data 
 *    type of all dynamically typed ports.
 */
static void mdlSetDefaultPortDataTypes(SimStruct *S)
{
    /* Set input port data type to uint8 */
    ssSetInputPortDataType(  S, 0, SS_UINT8 );               
    ssSetOutputPortDataType( S, 0, SS_UINT8 );            

} /* mdlSetDefaultPortDataTypes */


#define MDL_RTW
static void mdlRTW(SimStruct *S)
{
    uint8_T   atdbank     = (uint8_T) ATDBANK(S);
    uint16_T *channels    = (uint16_T *) mxGetData(CHANNELARRAY_ARG(S));
    uint8_T   use10BitRes = (uint8_T) USE10BITS(S);
    uint8_T   leftjustify = (uint8_T) LEFTJUSTIFY(S);

    /* Write out parameters for this block.*/
    if (!ssWriteRTWParamSettings(S, 4, 
                                 SSWRITE_VALUE_DTYPE_NUM,"ATDBank",
                                 &atdbank,DTINFO(SS_UINT8, COMPLEX_NO),

                                 SSWRITE_VALUE_DTYPE_VECT, "Channels",
                                 channels,
                                 mxGetNumberOfElements(CHANNELARRAY_ARG(S)),
                                 DTINFO(SS_UINT16, COMPLEX_NO),

                                 SSWRITE_VALUE_DTYPE_NUM,"Use10BitRes",
                                 &use10BitRes,DTINFO(SS_UINT8, COMPLEX_NO),

                                 SSWRITE_VALUE_DTYPE_NUM,"LeftJustify",
                                 &leftjustify,DTINFO(SS_UINT8, COMPLEX_NO)
                                 )) {
        return; /* An error occurred which will be reported by SL */
    }
}
/*==============================================*
* Enforce use of inlined S-function             * 
* (e.g. must have TLC file hc12_sfcn_adc_v.tlc) *
*===============================================*/

#ifdef    MATLAB_MEX_FILE  /* Is this file being compiled as a MEX-file?    */
# include "simulink.c"     /* MEX-file interface mechanism                  */
#else                      /* Prevent usage by RTW if TLC file is not found */
# error "Attempted use non-inlined S-function hc12_sfcn_adc_v.c"
#endif

/* [EOF] hc12_sfcn_adc_v.c */
