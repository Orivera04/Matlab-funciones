/*
 * File: sfun_xtra_bitop.cpp
 *
 * Abstract:
 *      S-function Bitwise logical operators
 *
 *
 * $Revision: 1.11.4.2 $  
 * $Date: 2004/04/19 01:30:33 $
 *
 * Copyright 2001-2003 The MathWorks, Inc.
 */

#ifdef __cplusplus
extern "C" { // use the C fcn-call standard for all functions  
#endif       // defined within this scope                     

    /*=====================================*
     * Required setup for C MEX S-Function *
     *=====================================*/
#define S_FUNCTION_NAME sfun_xtra_bitop
#define S_FUNCTION_LEVEL 2

    /*
     * Define indices for s_function parameters 
     */
    enum {
        I_PAR_UseBitMask, 
        I_PAR_NUMINPUTPORTS,
        I_PAR_BitMask,
        I_PAR_LogicOp,
        I_PAR_TestIfZero,
        N_PAR
    };


    /*
     * Need to include simstruc.h for the definition of the SimStruct and
     * its associated macro definitions.
     */
#include <string.h>
#include "simstruc.h"

    /*
     *  make access to VALUEs of parameters more readable
     */
#define PMX_PAR_LOGICOPSTR      PMX_PAR_STRING

#define MAX_LEN_LOGICOPSTR    5

#define       PMX_PAR_UseBitMask        ( ssGetSFcnParam(S,I_PAR_UseBitMask) )
#define     EMPTY_PAR_UseBitMask             ( mxIsEmpty(PMX_PAR_UseBitMask) )
#define NOTSAFE_V_PAR_UseBitMask (          (int)mxGetPr(PMX_PAR_UseBitMask)[0] )
#define         V_PAR_UseBitMask                     ( EMPTY_PAR_UseBitMask ? 0 : \
        NOTSAFE_V_PAR_UseBitMask )

#define       PMX_PAR_TestIfZero        ( ssGetSFcnParam(S,I_PAR_TestIfZero) )
#define     EMPTY_PAR_TestIfZero             ( mxIsEmpty(PMX_PAR_TestIfZero) )
#define NOTSAFE_V_PAR_TestIfZero (          (int)mxGetPr(PMX_PAR_TestIfZero)[0] )
#define         V_PAR_TestIfZero                     ( EMPTY_PAR_TestIfZero ? 0 : \
        NOTSAFE_V_PAR_TestIfZero )


#define       PMX_PAR_BitMask        ( ssGetSFcnParam(S,I_PAR_BitMask) )

#define VI_PAR_BitMask(idx)            (((uint32_T *)mxGetPr(PMX_PAR_BitMask))[(idx)])
#define VI_PAR_BitMaskLength           ( mxGetNumberOfElements(PMX_PAR_BitMask) )

#define      PMX_PAR_NUMINPUTPORTS    ( ssGetSFcnParam(S,I_PAR_NUMINPUTPORTS) )
#define      V_PAR_NUMINPUTPORTS       ( (int) mxGetPr(PMX_PAR_NUMINPUTPORTS)[0] ) 


#define       PMX_PAR_LogicOp        ( ssGetSFcnParam(S,I_PAR_LogicOp) )
#define     EMPTY_PAR_LogicOp             ( mxIsEmpty(PMX_PAR_LogicOp) )
#define NOTSAFE_V_PAR_LogicOp (          (int)mxGetPr(PMX_PAR_LogicOp)[0] )
#define         V_PAR_LogicOp                     ( EMPTY_PAR_LogicOp ? 0 : \
        NOTSAFE_V_PAR_LogicOp )
/*
 * define integer values to represent the logical operations
 */
enum {
    DO_AND=1,
    DO_OR,
    DO_NAND,
    DO_NOR,
    DO_XOR, 
    DO_NOT,
    DO_SHIFT_LEFT,
    DO_SHIFT_RIGHT,
    DO_BIT_SET,
    DO_BIT_CLEAR,

    DO_NOTA_AND_B,
    DO_A_AND_NOTB,
    DO_NOTA_OR_B,
    DO_A_OR_NOTB
};

enum {
   NoZeroTest=1,
   TestIfZero,
   TestIfNotZero
};

static const char *  OPERATORS[] = {
    "AND",
    "OR",
    "NAND",
    "NOR",
    "XOR",
    "NOT",
    "SHIFT_LEFT",
    "SHIFT_RIGHT",
    "BIT_SET",
    "BIT_CLEAR",
    "~A & B",
    "A & ~B",
    "~A | B",
    "A | ~B"
};

/*
 * Userdata structure
 *   holds pointer to integer code for logic operator
 */
typedef struct {
    int inputPortWidth;
    DTypeId inputPortDataTypes;
    DTypeId outputPortDataTypes;
} UserDataStruct;






/*--------------------------------------------------------------------------------
 *  Static Function Prototypes
 *--------------------------------------------------------------------------------*/

static  void        InitUserData(SimStruct *S);

inline  uint32_T    uPtr2uint32_T(InputPtrsType uPtr,int signal,DTypeId dataType);

inline  uint32_T    bitOperators(SimStruct * S,uint32_T input1, uint32_T input2,int logicOP);

inline  void        assignVoid(SimStruct * S,void * y,int signal,
                    uint32_T tempU,DTypeId dataType);

        void        generateMaskRtwString(SimStruct * S, char_T ** opStrPtr );

static  void        setPortDataType(SimStruct *S, int portIndex, 
                    DTypeId portDataType, int wasInput );

/*--------------------------------------------------------------------------------
 *  End Static Function Prototypes
 *--------------------------------------------------------------------------------*/




#define     MDL_CHECK_PARAMETERS
/* Function: mdlCheckParameters =============================================
 * Abstract:
 *    This routine will be called whenever parameters change or get re-evaluated.
 *    The purpose of this routine is
 *    to verify that the new parameter setting are correct.
 */
#ifdef MDL_CHECK_PARAMETERS
static void mdlCheckParameters(SimStruct *S)
{

} /* MDL_CHECK_PARAMETERS */
#endif



//#define     MDL_PROCESS_PARAMETERS
/* Function: mdlProcessParameters =============================================
 * Abstract:
 *    Carry out any operations that are necessary due to the initial choice of
 *    parameters or due to a change in the parameter values.
 */
#ifdef MDL_PROCESS_PARAMETERS
static void mdlProcessParameters(SimStruct *S)
{

} /* MDL_PROCESS_PARAMETERS */
#endif


#if defined(MATLAB_MEX_FILE)
# define MDL_SET_INPUT_PORT_WIDTH
void mdlSetInputPortWidth (SimStruct *S, int_T port, int_T width){

    UserDataStruct * ud = (UserDataStruct * ) ssGetUserData(S);


    if ( V_PAR_UseBitMask || V_PAR_LogicOp == DO_NOT ){
        //=========================================
        // A bit mask is used or the unary NOT 
        // operator is used
        //=========================================

        ssSetInputPortWidth(S,0,width);
        ud->inputPortWidth = width;
        if ( width == 1){
            //============================================
            // Use scalar expansion on input.
            //
            // Eg the input port is 1 wide but the masks
            // have been specified as 8 wide, then provide
            // and 8 wide output signal.
            //
            // out(0)[i] = in(0)[0] <op> mask[i]
            //
            // Do not use expression folding here unless
            // this bitmask is of length 1
            //=============================================
            ssSetOutputPortWidth(S,0,VI_PAR_BitMaskLength);
            if(VI_PAR_BitMaskLength==1){
                ssSetOutputPortOutputExprInRTW(S,0,true);
                ssSetInputPortAcceptExprInRTW(S,0,true);
            }
        }else{
            //====================================
            // Outputs are mapped element
            // to element to the input
            //
            // wide mask
            //  out(0)[i] = in(0)[i] <op> mask[i]
            //
            // or
            //
            // single mask
            //  out(0)[i] = in(0)[i] <op> mask[0]
            //
            // Expression folding is acceptable here
            // because we are going to use a roll
            //====================================
            ssSetOutputPortWidth(S,0,width);
            ssSetInputPortAcceptExprInRTW(S,0,true);
            ssSetOutputPortOutputExprInRTW(S,0,true);
        }

    }else if ( ! V_PAR_UseBitMask && V_PAR_NUMINPUTPORTS == 1 ){
        //=======================================
        // A single wide (width >= 2) input with binary
        // operators and no mask will perform
        //
        // out(0)[0] = in(0)[0] <op> in(0)[1] <op> in(0)[2] ......
        //
        // ======================================= 
        if ( width < 2 ){
            ssSetErrorStatus(S,
                "The input signal must have a width of at least 2 for binary operators");
            return;
        }
        ssSetInputPortWidth(S,0,width);
        ssSetOutputPortWidth(S,0,1);
        ud->inputPortWidth = width;

    }else{
        ssSetInputPortWidth(S,port,width);
        if ((ssGetOutputPortWidth(S,0)==DYNAMICALLY_SIZED) && ( width != 1 )){
           /* Key the output port width of the first input port not of width 1 */
           ssSetOutputPortWidth(S,0,width);
           ud->inputPortWidth = width;
        }else{
           if ( ( width != 1 ) && ( ssGetOutputPortWidth(S,0) != width )){
              ssSetErrorStatus(S,"All input port widths must be the same size or scalar.");
           }
        }
    }
}
#endif

#if defined(MATLAB_MEX_FILE)
#define MDL_SET_OUTPUT_PORT_WIDTH
static void mdlSetOutputPortWidth (SimStruct *S, int_T port, int_T width){
    ssSetOutputPortWidth(S,port,width);
}
#endif

/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *   Initialize the sizes array
 */
    static 
void mdlInitializeSizes(SimStruct *S)
{
    /*
     * options
     */
    int idx;
    InitUserData(S);

    ssSetNumSFcnParams(S,N_PAR);
    for(idx=0;idx<N_PAR;idx++){
        ssSetSFcnParamNotTunable(S,idx);
    }

    // Make the bitmask tunable
    ssSetSFcnParamTunable(S,I_PAR_BitMask,true);

    // ==========================================
    // Verify Parameters
    // ==========================================
    if (!mxIsUint32(PMX_PAR_BitMask)){
        ssSetErrorStatus(S,"Bit mask parameter must be uint32.");
    }


    if ( V_PAR_UseBitMask || V_PAR_LogicOp == DO_NOT ) {
        //========================
        // Use the bit mask
        //========================

        ssSetNumInputPorts(S,1);
        ssSetInputPortWidth(S,0,DYNAMICALLY_SIZED);
        ssSetInputPortDataType(S,0,DYNAMICALLY_TYPED);
        ssSetInputPortDirectFeedThrough(S,0,true);
        ssSetInputPortAcceptExprInRTW(S,0,true);
        ssSetInputPortOptimOpts(S, 0,SS_REUSABLE_AND_LOCAL);
        ssSetInputPortOverWritable(S, 0, 1);

        ssSetNumOutputPorts(S,1);
        ssSetOutputPortWidth(S,0,DYNAMICALLY_SIZED);
    }else{
        int idx;
        //========================
        // Do not use the bit mask
        //========================
        ssSetNumOutputPorts(S,1);

        ssSetNumInputPorts(S,V_PAR_NUMINPUTPORTS);
        if ( V_PAR_NUMINPUTPORTS == 1 ){
            //==============================
            // Single Wide Input Mapped
            // to single scalar output
            //==============================
            ssSetOutputPortOutputExprInRTW(S,0,true);
            ssSetOutputPortWidth(S,0,1);
            ssSetInputPortDataType(S,0,DYNAMICALLY_TYPED);
            ssSetInputPortWidth(S,0,DYNAMICALLY_SIZED);
            ssSetInputPortDirectFeedThrough(S,0,true);
            ssSetInputPortAcceptExprInRTW(S,0,true);
            ssSetInputPortOptimOpts(S, 0,SS_REUSABLE_AND_LOCAL);
            ssSetInputPortOverWritable(S, 0, 1);
        }else{
            //==============================
            // Multiple Wide/Scalar Inputs Mapped
            // to a single Wide/Scalar output
            //==============================
            ssSetOutputPortOutputExprInRTW(S,0,true);
            ssSetOutputPortWidth(S,0,DYNAMICALLY_SIZED);
            for(idx=0;idx<V_PAR_NUMINPUTPORTS;idx++){
                ssSetInputPortDataType(S,idx,DYNAMICALLY_TYPED);
                ssSetInputPortWidth(S,idx,DYNAMICALLY_SIZED);
                ssSetInputPortDirectFeedThrough(S,idx,true);
                ssSetInputPortAcceptExprInRTW(S,idx,true);
                ssSetInputPortOptimOpts(S, 0,SS_REUSABLE_AND_LOCAL);
                ssSetInputPortOverWritable(S, idx, 1);
            }
        }
    }
    ssSetOutputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
    ssSetOutputPortDataType(S,0,DYNAMICALLY_TYPED);

    ssSetOptions(S,SS_OPTION_USE_TLC_WITH_ACCELERATOR|
          SS_OPTION_NONVOLATILE);

} /* end mdlInitializeSizes */


#define MDL_SET_WORK_WIDTHS   /* Change to #undef to remove function */
#if defined(MDL_SET_WORK_WIDTHS) && defined(MATLAB_MEX_FILE)
static void mdlSetWorkWidths(SimStruct *S){
   const char * pNames [] = {
      "BitMasks",
   };
   ssRegAllTunableParamsAsRunTimeParams(S,pNames );

}
#endif

/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    Initialize the sample times array.
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime( S, 0, INHERITED_SAMPLE_TIME );
    ssSetOffsetTime( S, 0, FIXED_IN_MINOR_STEP_OFFSET );

} /* end mdlInitializeSampleTimes */



/* Function: InitUserData =======================================================
 * Abstract:
 *   Allocate memory for user data.
 */
static void InitUserData(SimStruct *S)
{
    UserDataStruct *userData = (UserDataStruct *) ssGetUserData(S);

    if (userData != NULL)
    {
        ssSetErrorStatus(S,"UserData not NULL before mdlStart.");
        return;
    }
    userData = ( UserDataStruct * ) malloc(sizeof(UserDataStruct));

    userData->inputPortDataTypes = -1;
    userData->outputPortDataTypes = -1;
    userData->inputPortWidth = 1;

    ssSetUserData(S, (void *)userData);
} /* end InitUserData */




//#define     MDL_START
/* Function: mdlStart =======================================================
 * Abstract:
 *    This function is called once at start of model execution. If you
 *    have states that should be initialized once, this is the place
 *    to do it.
 */
static void mdlStart(SimStruct *S)
{

} /*  MDL_START */



/* Function: mdlOutputs =======================================================
 * Abstract:
 *   Compute the outputs of the S-function.
 */
    static 
void mdlOutputs(SimStruct *S, int_T tid)
{
    UserDataStruct *userData = ( UserDataStruct * ) ssGetUserData(S);
    uint32_T tempU,tempU2;
    int idx,idx2;
    void * yVoid;
    DTypeId dtypeID = userData->inputPortDataTypes;
    InputPtrsType uPtr = ssGetInputPortSignalPtrs(S,0);

    yVoid = ssGetOutputPortSignal(S,0);

    if ( V_PAR_UseBitMask || V_PAR_LogicOp == DO_NOT ){

        //----------------------------------------------------------
        // We have one input that could be wide.
        // Each element of the vector is to be operated on with a mask

        if(VI_PAR_BitMaskLength == ssGetInputPortWidth(S,0)){
            //---------------------------------
            // There is a mask element for every
            // signal.
            //---------------------------------
            for ( idx = 0 ; idx < ssGetInputPortWidth(S,0) ; idx++ ){
                tempU = uPtr2uint32_T(uPtr,idx,dtypeID);
                tempU = bitOperators(S,tempU,(uint32_T) VI_PAR_BitMask(idx) ,V_PAR_LogicOp);
                assignVoid(S,yVoid,idx,tempU,dtypeID);
            }
        }else if ( ssGetInputPortWidth(S,0) ==1 && VI_PAR_BitMaskLength > 1){
            //-----------------------------------------
            // A single input is scalar expanded over
            // multiple masks to multipe outputs
            // ----------------------------------------
            tempU = uPtr2uint32_T(uPtr,0,dtypeID);
            for ( idx = 0; idx < ssGetOutputPortWidth(S,0) ; idx++){
                tempU2 = bitOperators(S,tempU,(uint32_T) VI_PAR_BitMask(idx) ,V_PAR_LogicOp);
                assignVoid(S,yVoid,idx,tempU2,dtypeID);
            }
        }else {
            //---------------------------------
            // Use the same mask value over
            // all inputs
            //---------------------------------
            for ( idx = 0 ; idx < ssGetInputPortWidth(S,0) ; idx++ ){
                tempU = uPtr2uint32_T(uPtr,idx,dtypeID);
                tempU = bitOperators(S,tempU,(uint32_T) VI_PAR_BitMask(0) ,V_PAR_LogicOp);
                assignVoid(S,yVoid,idx,tempU,dtypeID);
            }
        }
    }else{
        //-------------------------------------------------
        int logicOp = V_PAR_LogicOp;
        InputPtrsType uPtr = ssGetInputPortSignalPtrs(S,0);
        if ( V_PAR_NUMINPUTPORTS == 1){
            // We have N==1 inputs with width>=2 which will be operated together
            int width = ssGetInputPortWidth(S,0);
            tempU = uPtr2uint32_T(uPtr,0,dtypeID);
            for(idx=1;idx<width;idx++){
                tempU2 = uPtr2uint32_T(uPtr,idx,dtypeID);
                tempU = bitOperators(S,tempU,tempU2,logicOp);
            }
            assignVoid(S,yVoid,0,tempU,dtypeID);
        }else{
            // We have N>=2 inputs with width==1 which will be operated together
            UserDataStruct * ud = (UserDataStruct *) ssGetUserData(S);
            // Iterate over all elements of the input signals
            for(idx2=0; idx2 < ud->inputPortWidth ; idx2 ++ ){
               uPtr = ssGetInputPortSignalPtrs(S,0);
               if ( ssGetInputPortWidth(S,0) == 1 ){
                  tempU = uPtr2uint32_T(uPtr,0,dtypeID);
               }else{
                  tempU = uPtr2uint32_T(uPtr,idx2,dtypeID);
               }
               // Iterate over all the signals
               for(idx=1;idx<V_PAR_NUMINPUTPORTS;idx++){
                   uPtr = ssGetInputPortSignalPtrs(S,idx);
                   if ( ssGetInputPortWidth(S,idx) == 1 ){
                      // Scalar Expanded Input
                      tempU2 = uPtr2uint32_T(uPtr,0,dtypeID);
                   }else{
                      // Wide Input
                      tempU2 = uPtr2uint32_T(uPtr,idx2,dtypeID);
                   }
                   tempU = bitOperators(S,tempU,tempU2,logicOp);
               }
               assignVoid(S,yVoid,idx2,tempU,dtypeID);
            }
        }
    }
} /* end mdlOutputs */

inline void assignVoid(SimStruct * S,void * y,int signal,uint32_T tempU,DTypeId dataType){
    switch (dataType){
        case SS_UINT8:
            ((uint8_T *)y)[signal] = tempU & 0xFF; 
            break;
        case SS_UINT16:
            ((uint16_T *)y)[signal] = tempU & 0xFFFF; 
            break;
        case SS_UINT32:
            ((uint32_T *)y)[signal] = tempU; 
            break;
        default:
            ssSetErrorStatus(S,"Invalid type used in mdlOutputs");
            return;
    }
}


/* Function: mdlTerminate =====================================================
 * Abstract:
 *    Called when the simulation is terminated.
 */
static void mdlTerminate(SimStruct *S)
{
    UserDataStruct    *userData = ( UserDataStruct *) ssGetUserData(S);

    /* terminate actions depend on the fact that
     * userData has been properly intialized.
     */
    if (userData != NULL) 
    {
        /*
         * free user data
         */
        free(userData);
        ssSetUserData(S, NULL);
    }

} /* end mdlTerminate */





#define     MDL_SET_INPUT_PORT_DATA_TYPE
/* Function: mdlSetInputPortDataType ===========================================
 */
static void mdlSetInputPortDataType(SimStruct *S, int portIndex, DTypeId portDataType)
{
    setPortDataType(S, portIndex, portDataType, 1);

}  /* MDL_SET_INPUT_PORT_DATA_TYPE */



#define     MDL_SET_OUTPUT_PORT_DATA_TYPE
/* Function: mdlSetOutputPortDataType ===========================================
 */
static void mdlSetOutputPortDataType(SimStruct *S, int portIndex, DTypeId portDataType)
{
    setPortDataType(S, portIndex, portDataType, 0);

}  /* MDL_SET_OUTPUT_PORT_DATA_TYPE */



/* Function: mdlRTW ===========================================================
 * Abstract:
 *   RTW function.  Write parameters and parameter settings:
 */
#define MDL_RTW
void mdlRTW(SimStruct *S)
{
    uint32_T zeroTest = V_PAR_TestIfZero;
    UserDataStruct * ud = (UserDataStruct *)ssGetUserData(S);

    if ( !ssWriteRTWParamSettings(S, 7 ,
                SSWRITE_VALUE_NUM, "UseBitMask", 
                ( const real_T ) V_PAR_UseBitMask ,

                SSWRITE_VALUE_NUM, "BitMaskLength",
                ( const real_T ) VI_PAR_BitMaskLength,

                SSWRITE_VALUE_NUM, "NumberInputPorts",
                ( const real_T ) V_PAR_NUMINPUTPORTS,

                SSWRITE_VALUE_NUM, "InputPortWidth",
                ( const real_T ) ud->inputPortWidth, // Handle scalar
                                                     // Expansion

                SSWRITE_VALUE_NUM, "OutputPortWidth",
                ( const real_T ) ssGetOutputPortWidth(S,0),

                SSWRITE_VALUE_DTYPE_NUM, "ZeroTest",
                ( const void * ) &zeroTest,
                DTINFO(SS_UINT32,0),

                SSWRITE_VALUE_QSTR, "Operator",
                OPERATORS[V_PAR_LogicOp-1]

                                 ) ) {

        ssSetErrorStatus(S,"Error writing parameter data to .rtw file");

    }

} /* end mdlRTW */












/*============================================================
 *          UTILITY FUNCTIONS
 *
 *  These functions should be either static or inline
 *============================================================*/












/*----------------------------------------------
 * Write out the bit masks in hex in the correct
 * width for the input port data types.
 *
 * Parameters
 *  S           -       The SimStruct
 *  opStrPtr    -       Pointer to the result. This
 *                      must be freed after use.
 * ---------------------------------------------*/
static void generateMaskRtwString(SimStruct * S, char_T ** opStrPtr ){

    int_T            opWidth      = VI_PAR_BitMaskLength;
    int_T            opDType      = DTINFO(ssGetInputPortDataType(S,0), false);

/* 
     * allocate enough space for the operand #2 hex strings with 
     * quotes, commas and brackets.  '"FFFFFFFF", ' is 4+8 
     */

    int_T           opStrLen    = 3+(4+2*sizeof(uint32_T))*opWidth;
    int_T           sidx;
    char_T          *opStr;


    /*
     * make correct-length hex strings for second operand
     */

    if ( (opStr = (char_T *)calloc(opStrLen, sizeof(char_T))) == NULL ) {
        ssSetErrorStatus( S, "Could not allocate data cache memory");
        return;
    }
    *opStrPtr = opStr;

    sidx = sprintf(opStr, "[]") - 1;

    switch (ssGetInputPortDataType(S,0)) {
        int_T i;
        
      case SS_UINT8: {
          for ( i=0; i < opWidth; i++ ) {
              char_T *suffix = (i+1 == opWidth) ? "]": ", ";
              sidx += sprintf(opStr+sidx, "\"%02X\"%s", 
                      ((uint8_T )VI_PAR_BitMask(i)) & 0xFF,
                      suffix);
          }
      }
      break;
      case SS_UINT16: {
          for ( i=0; i < opWidth; i++ ) {
              char_T *suffix = (i+1 == opWidth) ? "]": ", ";
              sidx += sprintf(opStr+sidx, "\"%04X\"%s", 
                      ((uint16_T )VI_PAR_BitMask(i)) & 0xFFFF
                      , suffix);
          }
      }
      break;
      case SS_UINT32: {
          for ( i=0; i < opWidth; i++ ) {
              char_T *suffix = (i+1 == opWidth) ? "]": ", ";
              sidx += sprintf(opStr+sidx, "\"%08X\"%s", 
                      ((uint32_T )VI_PAR_BitMask(i)), suffix);
          }
      }
      break;
      default:
        ssSetErrorStatus(S, "Invalid data type in mdlRTW");
        return;
    }

}





/*-----------------------------------------------
 * Function
 *
 *    uPtr2uint32_T
 *
 * Purpose
 *
 *    Produce a uint32_T from an input signal which 
 *    can be of any type from uint8_T, uint16_T, uint32_T
 *
 * Parameters
 *    uPtr     -     Pointer to the input signals
 *    signal   -     signal number
 *    dataType -     SS_UINT8 | SS_UINT16 | SS_UINT32
 *
 *--------------------------------------------------*/
inline uint32_T uPtr2uint32_T(InputPtrsType uPtr,int signal,DTypeId dataType){

    switch (dataType){
        case SS_UINT8:
            {
                return (uint32_T) *(((uint8_T **)uPtr)[signal]); 
                break;
            }
        case SS_UINT16:
            {
                return (uint32_T) *(((uint16_T **)uPtr)[signal]);
                break;
            }
        case SS_UINT32:
            {
                return (uint32_T) *(((uint32_T **)uPtr)[signal]);
                break;
            }
    }
}


/*-----------------------------------------------
 * Function
 *    bitOperators
 *    
 *
 * Purpose
 *    Peform bit operation on the two inputs
 *
 * Parameters
 *    input1     -     Pointer to the input signals
 *    input2     -     Input port number
 *    logicOp   -     DO_AND  : ~ ( input1 & input2)
 *                    DO_OR   : ~ ( input1 | input2)
 *                    DO_NAND : ~ ( input1 & input2)
 *                    DO_NOR  : ~ ( input1 | input2)
 *                    DO_XOR  : input1 ^ input2
 *                    DO_NOT  : ~ input1
 *                    DO_SHIFT_LEFT : input1 << input2
 *                    DO_SHIFT_RIGHT: input1 >> input2
 *                    
 *
 *--------------------------------------------------*/
inline uint32_T bitOperators(SimStruct * S,uint32_T input1, uint32_T input2,int logicOP){
    switch ( logicOP ) {
        case DO_AND:
            input1 = input1 & input2;
            break;
        case DO_OR:
            input1 = input1 | input2;
            break;
        case DO_NAND:
            input1 = ~(input1 & input2);
            break;
        case DO_NOR:
            input1 = ~ ( input1 | input2 );
            break;
        case DO_XOR:
            input1 = input1 ^ input2;
            break;
        case DO_NOT:
            input1 = ~input1;
            break;
        case DO_SHIFT_LEFT:
            input1 = input1 << input2;
            break;
        case DO_SHIFT_RIGHT:
            input1 = input1 >> input2;
            break;
        case DO_BIT_SET:
            input1 = input1 | ( 0x1 << input2);
            break;
        case DO_BIT_CLEAR:
            input1 = input1 & ~(0x1 << input2);
            break;
        case DO_NOTA_AND_B:
            input1 = ~input1 & input2;
            break;
        case DO_A_AND_NOTB:
            input1 = input1 & ~input2;
            break;
        case DO_NOTA_OR_B:
            input1 = ~ input1 | input2;
            break;
        case DO_A_OR_NOTB:
            input1 = input1 | ~input2;
            break;
        default:
            ssSetErrorStatus(S,"Invalid operator used.");
            return 0;
    }

    switch (V_PAR_TestIfZero) {
       case NoZeroTest:
          break;
       case TestIfZero:
          input1 = input1 == 0;
          break;
       case TestIfNotZero:
          input1 = input1 != 0;
          break;
       default:
          ssSetErrorStatus(S,"V_PAR_LogicOp had an out of range value");
          return 0;
          break;
    }
    return input1;
}


/*------------------------------------------------------------
 * Function
 *      setPortDataType
 *
 * Purpose
 *      Logic for setting up the data type of the input
 *      and output ports
 *------------------------------------------------------------*/
static void setPortDataType(SimStruct *S, int portIndex, DTypeId portDataType, int wasInput )
{
    UserDataStruct *userData = (UserDataStruct *) ssGetUserData(S);
    switch (wasInput){
        case 1:
            // ==========
            // Input port
            // ==========

            // Ensure the input is of the correct datatype. Bit
            // operations are really only sensible on unsigned
            // datatypes. It is possible to do then in signed types
            // but the results are a lot more ambiguous.
            switch (portDataType){
                case SS_UINT8:
                case SS_UINT16:
                case SS_UINT32:
                    break;
                default:
                    ssSetErrorStatus(S,
                            "Only uint8, uint16, uint32 datatypes are accepted as input");
                    return;
            }

            // ============================================================
            // Ensure that all input ports are of the same datatype. We do this by
            // recording the type of the first input port to be registered and then
            // comparing subsequent ports with this.
            // ============================================================

            if ( userData->inputPortDataTypes == -1 ){
                userData->inputPortDataTypes = portDataType;
                ssSetOutputPortDataType(S,0,portDataType);
            }else if(userData->inputPortDataTypes != portDataType){
                ssSetErrorStatus(S,"All input ports must have the same datatype.");
                return;
            }
            ssSetInputPortDataType(S,portIndex,portDataType);
        default:
            // ============
            // Output port
            // ============

            // Is set implicity by knowing the input port data type
            break;
    }
}  /* setPortDataType */

/*=======================================*
 * Required closing for C MEX S-Function *
 *=======================================*/

#ifdef    MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
# include "simulink.c"     /* MEX-file interface mechanism               */
#else
# include "cg_sfun.h"      /* Code generation registration function      */
#endif


/* [EOF] s_fixpt_bitop.c */



#ifdef __cplusplus
} // end of extern "C" scope
#endif
