/* -|---------|-----|----------------------------------------------------------
 *  Program   :     sfun_lookupnd_stair_fit.c
 *  Author    :     Bora Eryilmaz
 *
 *  Time-stamp:     <2004-03-18 13:23:59 beryilma>
 *  Copyright :     1990-2001 The MathWorks, Inc.
 *  Licence   :     MathWorks License Agreement
 *  $Revision: 1.1.6.2 $
 *
 *  Purpose   :     For a table with M dimensions, returns the adapted value
 *                  of the cell location corresponding to the table inputs.
 *
 *                  If selected, the adapted table is also provided at an
 *                  output port.  But, this currently needs to be 1 or 2
 *                  dimensional due to Simulink's limitation to propagating
 *                  2 dimensional tables.
 *
 *                  The block accepts vectorized input for the abscissae and
 *                  scalar input for the ordinate.
 * ------------------------------------------------------------------------- */

#define S_FUNCTION_NAME  sfun_lookupnd_stair_fit
#define S_FUNCTION_LEVEL 2

#include <stdlib.h>    /* for malloc, free */
#include <math.h>
#include "simstruc.h"
#include "lookup_methods.h"

/* ----------------------------------------------------------------------------
 * Purpose:  Make sure parameter values are valid for the current context.
 * ------------------------------------------------------------------------- */
#define MDL_CHECK_PARAMETERS
static void mdlCheckParameters(SimStruct *S)
{
  int_T numDims;
  boolean_T tabIsInput;
  
  /*
   * Things to check even on a sizes-only call.
   * These affect the number of ports.
   */

  /* Check explicit number of table dimensions */
  if ( IS_OKREALSCALAR( TB_NUMDIM(S) ) ) {
    numDims = (int) mxGetScalar( TB_NUMDIM(S) );
    if ( numDims < 1 || numDims > MAX_NUM_DIMS ) {
      ssSetErrorStatus(S, numDimsMsg);
      return;
    }
  } else {
    ssSetErrorStatus(S, numDimsMsg);
    return;
  }
  
  /* Check mode selections */
  if ( IS_OKBOOL( TB_INPUT(S) ) ) {
    tabIsInput = (boolean_T) mxGetScalar( TB_INPUT(S) );
  } else {
    ssSetErrorStatus(S, makeTableInputMsg);
    return;
  }
  
  if ( !IS_OKBOOL( TB_OUTPUT(S) ) ) {
    ssSetErrorStatus(S, makeTableOutputMsg);
    return;
  }
  
  if ( !IS_OKBOOL( AD_ENABLE(S) ) ) {
    ssSetErrorStatus(S, addEnablePortMsg);
    return;
  }
  
  if ( !IS_OKBOOL( AD_LOCK(S) ) ) {
    ssSetErrorStatus(S, addCellLockPortMsg);
    return;
  }
  
  /*
   * Things to check just before or during an actual simulation.
   */
  
  if ( ssGetSimMode(S) != SS_SIMMODE_SIZES_CALL_ONLY ) {
    /* Check out-of-range method */
    if( IS_OKREALSCALAR( AD_RANGE(S) ) ) {
      switch ( (RangeMode) mxGetScalar( AD_RANGE(S) ) ) {
      case IGNORE:
      case ADAPT:
	break;
      default:
	ssSetErrorStatus(S, rangeModeMsg);
	return;
      }
    } else {
      ssSetErrorStatus(S, rangeModeMsg);
      return;
    }
    
    /* Check adaptation method */
    if( IS_OKREALSCALAR( AD_METHOD(S) ) ) {
      switch ( (AdaptMode) mxGetScalar( AD_METHOD(S) ) ) {
      case MEAN:
      case FORGET:
	/* Check adaptation gain */
	if ( IS_OKREALSCALAR( AD_FACTOR(S) ) ) {
	  const real_T factor = (real_T) mxGetScalar( AD_FACTOR(S) );
	  if (factor < 0 || factor > 1) {
	    ssSetErrorStatus(S, adaptFactorMsg);
	    return;
	  }
	} else {
	  ssSetErrorStatus(S, adaptFactorMsg);
	  return;
	}
      	break;
      default:
	ssSetErrorStatus(S, adaptMethodMsg);
	return;
      }
    } else {
      ssSetErrorStatus(S, adaptMethodMsg);
      return;
    }

    /* Table data must be provided if table is not an input and
     * its dimensions must match explicit number of dimensions */
    if ( IS_OKREAL( TB_DATA(S) ) && !tabIsInput ) {
      const int_T *tableDims = (int_T *) mxGetDimensions( TB_DATA(S) );
      const int_T N = (int_T) mxGetNumberOfDimensions( TB_DATA(S) );
      if ( numDims != getNumTableDims(tableDims, N) ) {
	ssSetErrorStatus(S, numDimsMatchMsg1);
	return;
      }
    } else {
      if ( !tabIsInput )
	ssSetErrorStatus(S, numDimsMatchMsg1);
    }
    
    /* Table numbering data must be provided and
     * its dimensions must match explicit number of dimensions */
    if ( IS_OKREAL( TB_NUMDATA(S) ) ) {
      const int_T *tableDims = (int_T *) mxGetDimensions( TB_NUMDATA(S) );
      const int_T N = (int_T) mxGetNumberOfDimensions( TB_NUMDATA(S) );
      if ( numDims != getNumTableDims(tableDims, N) ) {
	ssSetErrorStatus(S, numDimsMatchMsg2);
	return;
      }
    } else {
      ssSetErrorStatus(S, numDimsMatchMsg2);
      return;
    }
    
    /* Check breakpoints indices and data */
    if ( ! ( IS_OKREAL( BP_INDEX(S) ) && IS_OKREAL( BP_DATA(S) ) ) ) {
      ssSetErrorStatus(S, bpDataRealMsg);
      return;
    }
    
    /* Number of breakpoint sets must match explicit number of dimensions */
    if (IS_OKREAL(BP_INDEX(S)) && IS_OKREAL(BP_DATA(S))) {
      const real_T *bpIndex = (real_T *) mxGetData(BP_INDEX(S));
      const real_T *bpData  = (real_T *) mxGetData(BP_DATA(S));
      int_T i, j, L, index;
      
      if ( numDims != mxGetNumberOfElements( BP_INDEX(S) ) ) {
	ssSetErrorStatus(S, bpDimMatchTableDim);
	return;
      }
          
      /* Enforce that each dimension has at least two breakpoints
       * and that breakpoints are strictly increasing. */
      for (L = 0, i = 0; i < numDims; i++ ) {
	index = (int_T) bpIndex[i];

	/* At least two elements for each breakpoint set */
	if ( index < 2 ) {
	  ssSetErrorStatus(S, bpLengthMsg);
	  return;
	}
      
	/* Breakpoint data must be increasing */
	for ( j = L + 1; j < index; j++ ) {
	  if ( (bpData[j] - bpData[j-1]) <= 0.0 ) {
	    ssSetErrorStatus(S, bpDataIncreasing);
	    return;
	  }
	}
	
	/* Table data dimensions must match breakpoint length */
	if ( IS_OKREAL( TB_DATA(S) ) && !tabIsInput ) {
	  const int_T *tableDims = (int_T *) mxGetDimensions( TB_DATA(S) );
	  const int_T N = (int_T) mxGetNumberOfElements( TB_DATA(S) );
	  /* bpIndex[i] = tabDims + 1 since table is cell-based */
	  if ( ( (numDims > 1) && (index != 1 + tableDims[i]) ) ||
	       ( (numDims ==1) && (index != 1 + N ) ) ) {
	    ssSetErrorStatus(S, bpLengthMatchTableDim1);
	    return;
	  }
	}
	
	/* Table numbering data dimensions must breakpoint length */
	if (IS_OKREAL(TB_NUMDATA(S))) {
	  const int_T *tableDims = (int_T *) mxGetDimensions( TB_NUMDATA(S) );
	  const int_T N = (int_T) mxGetNumberOfElements( TB_NUMDATA(S) );
	  /* bpIndex[i] = tabDims + 1 since table is cell based */
	  if ( ( (numDims > 1) && (index != 1 + tableDims[i]) ) ||
	       ( (numDims ==1) && (index != 1 + N ) ) ) {
	    ssSetErrorStatus(S, bpLengthMatchTableDim2);
	    return;
	  }
	}
	
	L += index;
      }
    }
  }
}

/* ----------------------------------------------------------------------------
 * purpose:  Assist with propagating input and output port sizes
 *           based on parameter sizes and number of inputs.
 * ------------------------------------------------------------------------- */
static void mdlInitializeSizes(SimStruct *S)
{
  const int_T numDims       = (int_T) mxGetScalar( TB_NUMDIM(S) );
  const int_T tabIsInput    = (int_T) mxGetScalar( TB_INPUT(S) );
  const int_T tabIsOutput   = (int_T) mxGetScalar( TB_OUTPUT(S) );
  const int_T enableIsInput = (int_T) mxGetScalar( AD_ENABLE(S) );
  const int_T lockIsInput   = (int_T) mxGetScalar( AD_LOCK(S) );
  const int_T numInputs     = 2 + tabIsInput + enableIsInput + lockIsInput;
  const int_T numOutputs    = 2 + tabIsOutput;
  const boolean_T simOnly   = !(ssGetSimMode(S) == SS_SIMMODE_EXTERNAL ||
				ssGetSimMode(S) == SS_SIMMODE_RTWGEN);
  int_T i;
  
  /* Check the number of expected parameters */
  ssSetNumSFcnParams(S, NUM_PARAMS);
#if defined(MATLAB_MEX_FILE)
  if (ssGetNumSFcnParams(S) == ssGetSFcnParamsCount(S)) {
    mdlCheckParameters(S);
    if (ssGetErrorStatus(S) != NULL) return;
  } else {
    ssSetErrorStatus(S, wrongNumParams);
    return;
  }
#endif
  
  /* Lock certain tunability options OFF during code generation
   * and external mode, and only ON for simulation.  */
  ssSetSFcnParamTunable(S, Tb_NumDim_Idx,  false);
  ssSetSFcnParamTunable(S, Bp_Data_Idx,    false);
  ssSetSFcnParamTunable(S, Bp_Index_Idx,   false);
  ssSetSFcnParamTunable(S, Tb_Input_Idx,   false);
  ssSetSFcnParamTunable(S, Tb_Data_Idx,    false);
  ssSetSFcnParamTunable(S, Tb_NumData_Idx, false);
  ssSetSFcnParamTunable(S, Ad_Method_Idx,  false);
  ssSetSFcnParamTunable(S, Ad_Factor_Idx,  false);
  ssSetSFcnParamTunable(S, Tb_Output_Idx,  false);
  ssSetSFcnParamTunable(S, Ad_Enable_Idx,  false);
  ssSetSFcnParamTunable(S, Ad_Lock_Idx,    false);
  ssSetSFcnParamTunable(S, Ad_Range_Idx,   false);
  
  /* Number of INPUT ports is determined by dialog selections */
  ssSetNumInputPorts(S, numInputs);  /* always >= 2 */
  for ( i = 0; i < numInputs; i++ ) {
    ssSetInputPortComplexSignal(S, i, COMPLEX_NO);
    ssSetInputPortDataType(S, i, DYNAMICALLY_TYPED);
    ssSetInputPortDirectFeedThrough(S, i, 1);
    ssSetInputPortOverWritable(S, i, 1);
    ssSetInputPortRequiredContiguous(S, i, 1);
    ssSetInputPortReusable(S, i, 1);
    ssSetInputPortWidth(S, i, 1);
  }
  
  /* Size of abscissa data vector */
  ssSetInputPortWidth(S, 0, numDims);
  
  /* Initial table is an input port (multi-dimensional array) */
  if ( tabIsInput ) {
    int portIdx = 1 + tabIsInput;
    ssSetInputPortDimensionInfo(S, portIdx, DYNAMIC_DIMENSION);
    ssSetInputPortOverWritable(S, portIdx, 0);
  }
  
  /* Number of OUTPUT ports is determined by dialog selections */
  ssSetNumOutputPorts(S, numOutputs);  /* always >= 2 */
  for ( i = 0; i < numOutputs; i++ ) {
    ssSetOutputPortComplexSignal(S, i, COMPLEX_NO);
    ssSetOutputPortDataType(S, i, DYNAMICALLY_TYPED);
    ssSetOutputPortReusable(S, i, 1);
    ssSetOutputPortWidth(S, i, 1);
  }
  
  /* Adapted table is an output port (multi-dimensional array) */
  if ( tabIsOutput ) {
    const int portIdx = 1 + tabIsOutput;
    if ( !tabIsInput ) {
      const int_T *tableDims = (int_T *) mxGetDimensions(TB_DATA(S));   
      switch(numDims) {
      case 1:
	/* matlab mxArrays have a minimum of 2 dimensions */
	ssSetOutputPortVectorDimension(S, portIdx, tableDims[0]*tableDims[1]);
	break;
      case 2:
	ssSetOutputPortMatrixDimensions(S, portIdx, tableDims[0],tableDims[1]);
	break;
      default:
	ssSetErrorStatus(S, "Illegal output shape specified. Only scalar, "
			 "vector and 2-D matrix supported");
	return;
      }
    } else {
      /* Output shape is a function of the data at the table input port */
      ssSetOutputPortDimensionInfo(S, portIdx, DYNAMIC_DIMENSION);
    }
  }
  
  /* Take care when specifying exception free code */
  if ( tabIsInput ) {
    ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE |
		 SS_OPTION_CALL_TERMINATE_ON_EXIT | 
		 SS_OPTION_CAN_BE_CALLED_CONDITIONALLY  |
		 SS_OPTION_NONSTANDARD_PORT_WIDTHS);
  } else {
    ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE |
		 SS_OPTION_CALL_TERMINATE_ON_EXIT |
		 SS_OPTION_CAN_BE_CALLED_CONDITIONALLY |
		 SS_OPTION_ALLOW_INPUT_SCALAR_EXPANSION);
  }
  ssSetNumSampleTimes(S, 1);
  
  /* Preemptively clear user data pointer so we don't try to free it */
  ssSetUserData(S, NULL);
}

/* ----------------------------------------------------------------------------
 * Purpose:  This routine is called with the candidate dimension for an INPUT
 *           port with unknown dimensions.  The only port where this does
 *           anything is the table input port, if it exists.  When the table
 *           comes in on an input instead of as a parameter, the OUTPUT port
 *           properties are functions of the table input port's properties.
 * ------------------------------------------------------------------------- */
#define MDL_SET_INPUT_PORT_DIMENSION_INFO
void mdlSetInputPortDimensionInfo(SimStruct *S,
				  int_T portIndex,
                                  const DimsInfo_T *dimsInfo)
{
  const int_T numDims     = (int_T) mxGetScalar( TB_NUMDIM(S) );
  const int_T tabIsInput  = (int_T) mxGetScalar( TB_INPUT(S) );
  const int_T tabIsOutput = (int_T) mxGetScalar( TB_OUTPUT(S) );
  const int_T portIdx = 1 + tabIsInput;
  int_T i;
  
  /* Diagnostics */
/*   { */
/*     ssPrintf("\n::mdlSetInputPortDimensionInfo.\n"); */
/*     ssPrintf("Input Port:  num:%d\t dims:%d\t width:%d\n", */
/* 	     portIndex, dimsInfo->numDims, dimsInfo->width); */
/*     for (i = 0; i < dimsInfo->numDims; i++) { */
/*       ssPrintf("Input Port:  dimension[%d]: %d\n", i, dimsInfo->dims[i]); */
/*     } */
/*   } */
  
  /* Should only set the dimensions of the table input port */  
  if ( tabIsInput && (portIndex == 1 + tabIsInput) ) {
    ssSetInputPortDimensionInfo(S, portIndex, dimsInfo);
  } else {
    ssSetErrorStatus(S, "Wrong assignment of input port dimensions");
    return;
  }
  
  /* This is the table input port.  Check that table port setting is
   * compatible with user specified dimensions. */
  if ( tabIsInput ) {
    const int_T *tableDims = (int_T *)  ssGetInputPortDimensions(S, portIndex);
    const real_T *bpIndex  = (real_T *) mxGetData( BP_INDEX(S) );
    int_T index;

    if (numDims != ssGetInputPortNumDimensions(S, portIndex)) {
      ssSetErrorStatus(S, numDimsMatchMsg3);
      return;
    }
    
    /* Table data dimensions must match breakpoint length */
    for ( i = 0; i < numDims; i++ ) {
      index = (int_T) bpIndex[i];
      
      /* bpIndex[i] = tabDims + 1 since table is cell-based */
      if ( ( (numDims > 1) && (index != 1 + tableDims[i]) ) ||
	   ( (numDims ==1) && (index != 1 + mxGetNumberOfElements( TB_DATA(S) ) ) ) ) {
	ssSetErrorStatus(S, bpLengthMatchTableDim3);
	return;
      }
    }
  }

  /* If the table is an input and all the input ports are known,
   * it is now time to set the output port size. */
  if ( tabIsOutput ) {
    const int outPortIdx = 1 + tabIsOutput;
    /* output port not set - set the output port dimension info. */
    switch(numDims) {
    case 1:
    case 2:
      if ( ssGetOutputPortWidth(S, outPortIdx) == DYNAMICALLY_SIZED ) {
	ssSetOutputPortDimensionInfo(S, outPortIdx, dimsInfo);
      } else {
	/* output port already set - check if compatible */
	int_T  oPortNumDims = ssGetOutputPortNumDimensions(S, portIndex);
	int_T *oPortDims    = ssGetOutputPortDimensions(S, portIndex);
	int_T  oPortWidth   = ssGetOutputPortWidth(S, portIndex);
	if (oPortNumDims != dimsInfo->numDims ||
	    oPortWidth   != dimsInfo->width) {
	  ssSetErrorStatus(S, "Output port not compatible with "
			   "specified shape and/or table input "
			   "port shape");
	  return;
	}
      }
      break;
    default:
      ssSetErrorStatus(S, "Unrealizable shape specified for "
		       "block output port dimensions");
      return;
    }
  }
}

/* ----------------------------------------------------------------------------
 * Purpose:  This routine is called with the candidate dimension for an OUTPUT
 *           port with unknown dimensions.  The only port where this may do
 *           anything is the table output port, if it exists.  The OUTPUT port
 *           properties are function of the table data properties.
 * ------------------------------------------------------------------------- */
#define MDL_SET_OUTPUT_PORT_DIMENSION_INFO
void mdlSetOutputPortDimensionInfo(SimStruct *S,
				   int_T portIndex,
				   const DimsInfo_T *dimsInfo)
{
  const int_T numDims     = (int_T) mxGetScalar( TB_NUMDIM(S) );
  const int_T tabIsInput  = (int_T) mxGetScalar( TB_INPUT(S) );
  const int_T tabIsOutput = (int_T) mxGetScalar( TB_OUTPUT(S) );
  const int_T portIdx = 1 + tabIsInput;
  
  /* Diagnostics */
/*   { */
/*     int_T i; */
/*     ssPrintf("\n::mdlSetOutputPortDimensionInfo.\n"); */
/*     ssPrintf("Output Port:   num:%d\t dims:%d\t width:%d\n", */
/* 	     portIndex, dimsInfo->numDims, dimsInfo->width); */
/*     for (i = 0; i < dimsInfo->numDims; i++) { */
/*       ssPrintf("Output Port:  dimension[%d]: %d\n", i, dimsInfo->dims[i]); */
/*     } */
/*   } */

  /* Should only set the dimensions of the table output port */  
  if ( tabIsOutput && (portIndex == 1 + tabIsOutput) ) {
    ssSetOutputPortDimensionInfo(S, portIndex, dimsInfo);
  } else {
    ssSetErrorStatus(S, "Wrong assignment of output port dimensions");
    return;
  }
}

/* ----------------------------------------------------------------------------
 * Purpose:  Specifiy that we inherit our sample time from the driving blocks.
 * ------------------------------------------------------------------------- */
static void mdlInitializeSampleTimes(SimStruct *S)
{
  ssSetSampleTime(S, 0, INHERITED_SAMPLE_TIME);
  ssSetOffsetTime(S, 0, FIXED_IN_MINOR_STEP_OFFSET); /* no minor step outputs */
}

/* ----------------------------------------------------------------------------
 * Only double data allowed at input ports.
 * ------------------------------------------------------------------------- */
#define MDL_SET_INPUT_PORT_DATA_TYPE
static void mdlSetInputPortDataType(SimStruct *S, int_T portIdx, DTypeId dType)
{
  switch (dType) {
  case SS_DOUBLE:
    ssSetInputPortDataType(S, portIdx, dType);
    break;
  default:
    ssSetErrorStatus(S, doubleOnlyMsg);
    return;
  }
}

/* ----------------------------------------------------------------------------
 * Only double data allowed at output ports.
 * ------------------------------------------------------------------------- */
#define MDL_SET_OUTPUT_PORT_DATA_TYPE
static void mdlSetOutputPortDataType(SimStruct *S, int_T portIdx, DTypeId dType)
{
  switch (dType) {
  case SS_DOUBLE:
    ssSetOutputPortDataType(S, portIdx, dType);
    break;
  default:
    ssSetErrorStatus(S, doubleOnlyMsg);
    return;
  }
}

/* ----------------------------------------------------------------------------
 * Handle complex input settings.
 * ------------------------------------------------------------------------- */
#define MDL_SET_INPUT_PORT_COMPLEX_SIGNAL
static void mdlSetInputPortComplexSignal(SimStruct *S, int_T portIdx,
                                         CSignal_T iPortComplexSignal)
{
  if (iPortComplexSignal == COMPLEX_NO) {
    ssSetInputPortComplexSignal(S, portIdx, iPortComplexSignal);
  } else {
    ssSetErrorStatus(S, "Input ports cannot be complex.");
  }
}

/* ----------------------------------------------------------------------------
 * Handle complex input settings.
 * ------------------------------------------------------------------------- */
#define MDL_SET_OUTPUT_PORT_COMPLEX_SIGNAL
static void mdlSetOutputPortComplexSignal(SimStruct *S, int_T portIdx,
					  CSignal_T oPortComplexSignal)
{
  if (oPortComplexSignal == COMPLEX_NO) {
    ssSetOutputPortComplexSignal(S, portIdx, oPortComplexSignal);
  } else {
    ssSetErrorStatus(S, "Output ports cannot be complex.");
  }
}

/* ----------------------------------------------------------------------------
 * Purpose:  Register run-time parameters
 * ------------------------------------------------------------------------- */
#define MDL_SET_WORK_WIDTHS
static void mdlSetWorkWidths(SimStruct *S)
{
/*   const int_T numDims = (int_T) mxGetScalar( TB_NUMDIM(S) ); */
/*   DTypeId     ioType  = ssGetOutputPortDataType(S,0); */
/*   int_T k; */
/*   void *data;        */
/*   ssParamRec rtpRec; */

/*   static char *names[] = { */
/*     "bp01Data", "bp02Data", "bp03Data", "bp04Data", "bp05Data", */
/*     "bp06Data", "bp07Data", "bp08Data", "bp09Data", "bp10Data", */
/*     "bp11Data", "bp12Data", "bp13Data", "bp14Data", "bp15Data", */
/*     "bp16Data", "bp17Data", "bp18Data", "bp19Data", "bp20Data", */
/*     "bp21Data", "bp22Data", "bp23Data", "bp24Data", "bp25Data", */
/*     "bp26Data", "bp27Data", "bp28Data", "bp29Data", "bp30Data" }; */

/*   ssSetNumRunTimeParams(S, numDims); */
  ssSetNumRunTimeParams(S, 0);

/*   /\*  */
/*    * Set up the first N breakpoint data arrays as run time parameters. */
/*    * Breakpoint data could be transformed and/or could be tunable. */
/*    *\/ */
/*   for ( k = 0; k < numDims; k++ ) { */
/*     const mxArray *bpCell = BP_CELL(S); */
/*     const mxArray *bpDataParam = mxGetCell(bpCell,k); */
/*     int_T rtparamDims = mxGetNumberOfElements(bpDataParam); */
/*     int_T kDlg = 0; */
/*         data = mxGetData(bpDataParam); */
    
/*     rtpRec.name             = names[k]; */
/*     rtpRec.nDimensions      = 1; */
/*     rtpRec.dimensions       = &rtparamDims; */
/*     rtpRec.dataTypeId       = ioType; */
/*     rtpRec.complexSignal    = COMPLEX_NO; */
/*     rtpRec.data             = data; */
/*     rtpRec.dataAttributes   = NULL; */
/*     rtpRec.nDlgParamIndices = 1; */
/*     rtpRec.dlgParamIndices  = &kDlg; */
/*     rtpRec.transformed      = RTPARAM_TRANSFORMED; */
/*     rtpRec.outputAsMatrix   = false; */
      
/*     if( !ssSetRunTimeParamInfo(S, k, &rtpRec) ) return; */
/*   } */
}

/* ----------------------------------------------------------------------------
 * Purpose:  Store tunable parameters in a pre-digested state.
 * ------------------------------------------------------------------------- */
#define MDL_PROCESS_PARAMETERS
static void mdlProcessParameters(SimStruct *S)
{
  /* 
     ssPrintf("In mdlProcessParameters.\n");
     ssPrintf("New adaptation gain is %f\n", tbStruct->gain);
  */
}

/* ----------------------------------------------------------------------------
 * Purpose:  Allocate work data and initialize non-tunable items.
 * ------------------------------------------------------------------------- */
#define MDL_START
static void mdlStart(SimStruct *S)
{
  const real_T *bpIndex = (real_T *) mxGetData( BP_INDEX(S) );
        real_T *bpData  = (real_T *) mxGetData( BP_DATA(S) );
  const int_T   numDims = (int_T) mxGetScalar( TB_NUMDIM(S) );
  boolean_T tabIsInput  = (boolean_T) mxGetScalar( TB_INPUT(S) );
  const int_T numElements = (!tabIsInput) ? mxGetNumberOfElements(TB_DATA(S)) :
                                        ssGetInputPortWidth(S, 1 + tabIsInput);
  int_T i, L, index;

  /* Allocate memory blocks for data structures */
  TbStruct *tbStruct = malloc(sizeof *tbStruct);
  MdStruct *mdStruct = malloc(sizeof *mdStruct);
  BpStruct **bpStructArray = malloc(numDims * sizeof **bpStructArray);
  real_T *tabData = malloc(numElements * sizeof *tabData);
  real_T *weights = malloc(numElements * sizeof *weights);
  
  if (bpStructArray != NULL) {
    for ( i = 0; i < numDims; i++ ) {
      bpStructArray[i] = malloc(sizeof *bpStructArray[i]);
    }
  }
  
  if ((tbStruct == NULL) || (mdStruct == NULL) || (bpStructArray == NULL) ||
      (weights == NULL) || (tabData == NULL)) {
    free(tabData);
    free(weights);
    free(mdStruct);
    for(i = 0; i < numDims; i++ ) {
      free(bpStructArray[i]);
    }
    free(bpStructArray);
    free(tbStruct);
    ssSetErrorStatus(S, "Could not allocate data cache memory.");
    return;
  }

  /* Initialize table structure data */
  tbStruct->numDims  = numDims;
  tbStruct->tabData  = tabData;
  tbStruct->weights  = weights;
  tbStruct->mdStruct = mdStruct;
  tbStruct->bpStruct = bpStructArray;
  tbStruct->numData  = (real_T *) mxGetData( TB_NUMDATA(S) );
  tbStruct->gain     = (real_T)   mxGetScalar( AD_FACTOR(S) );
  tbStruct->index    = 0;
  tbStruct->value    = 0.0;
  
  /* Assign mode structure data */
  mdStruct->enableMode  = (boolean_T) mxGetScalar( AD_ENABLE(S) );
  mdStruct->lockMode    = (boolean_T) mxGetScalar( AD_LOCK(S) );
  mdStruct->tabIsInput  = (boolean_T) mxGetScalar( TB_INPUT(S) );
  mdStruct->tabIsOutput = (boolean_T) mxGetScalar( TB_OUTPUT(S) );
  mdStruct->rangeMode   = (RangeMode) mxGetScalar( AD_RANGE(S) );
  mdStruct->adaptMode   = (AdaptMode) mxGetScalar( AD_METHOD(S) );
  
  /* Initialize the table and the weights */
  if (mdStruct->tabIsInput) {
    int_T portIdx = 1 + mdStruct->tabIsInput;
    tbStruct->initData = (real_T *) ssGetInputPortSignal(S, portIdx);
  } else {
    tbStruct->initData = (real_T *) mxGetData( TB_DATA(S) );
  }
  memcpy(tbStruct->tabData, tbStruct->initData,
	 numElements * sizeof *tbStruct->tabData);
  for (i = 0; i < numElements; i++) {
    tbStruct->weights[i] = 0.0;
  }
  
  /* Initialize breakpoint structures */
  for ( L = 0, i = 0; i < numDims; i++ ) {
    index = (int_T) bpIndex[i];

    tbStruct->bpStruct[i]->data     = &bpData[L];
    tbStruct->bpStruct[i]->fraction = 0.0;
    tbStruct->bpStruct[i]->index    = 0;
    tbStruct->bpStruct[i]->length   = (uint_T) index;
    tbStruct->bpStruct[i]->range    = false;
    L += index;
  }
  
  /* Set the cached data into the user data area for 'this' block. */
  ssSetUserData(S, tbStruct);
  
  /* and finish the initialization */
  mdlProcessParameters(S);
}

/* ----------------------------------------------------------------------------
 * Purpose:  Output the cell matrix and current cell number.
 * ------------------------------------------------------------------------- */
static void mdlOutputs(SimStruct *S, int_T tid)
{
  TbStruct  *tbStruct = ssGetUserData(S);
  MdStruct  *mdStruct = tbStruct->mdStruct;

  const real_T *u = (real_T *) ssGetInputPortSignal(S, 0);
  const real_T *z = (real_T *) ssGetInputPortSignal(S, 1);
  /* Make number of elements calculations simpler: tbStruct->numElements? */
  const int_T numElements = (!mdStruct->tabIsInput) ?
    mxGetNumberOfElements(TB_DATA(S)) :
    ssGetInputPortWidth(S, 1 + mdStruct->tabIsInput);
  real_T *value   = (real_T *) ssGetOutputPortSignal(S, 0);
  real_T *cellnum = (real_T *) ssGetOutputPortSignal(S, 1);

  /* Adaptation enable port (scalar) */
  EnableSignal enable = (mdStruct->enableMode == 0) ? ALT_ENABLE :
    (EnableSignal) ((real_T *) ssGetInputPortSignal(S, 1 + mdStruct->tabIsInput
						    + mdStruct->enableMode))[0];

  /* Cell lock port (scalar) */
  LockSignal lock = (mdStruct->lockMode == 0) ? UNLOCK :
    (LockSignal) ((real_T *) ssGetInputPortSignal(S, 1 + mdStruct->tabIsInput
	 	              + mdStruct->enableMode + mdStruct->lockMode))[0];

  tbOutput(tbStruct, u, z, enable, lock, numElements);
  value[0]   = tbStruct->value;
  cellnum[0] = tbStruct->numData[tbStruct->index];

  /* Copy adapted table to output port */
  if (mdStruct->tabIsOutput) {
    const int portIdx = 1 + mdStruct->tabIsOutput;
    real_T *table = (real_T *) ssGetOutputPortSignal(S, portIdx);
    memcpy(table, tbStruct->tabData, numElements * sizeof *table);
  }
}

/* ----------------------------------------------------------------------------
 * Purpose:  Delete memory allocated for adaptation weights.
 * ------------------------------------------------------------------------- */
static void mdlTerminate(SimStruct *S)
{
  TbStruct *tbStruct = ssGetUserData(S);
  uint_T i;

  if(tbStruct != NULL) {
    free(tbStruct->weights);
    free(tbStruct->tabData);
    free(tbStruct->mdStruct);
    
    for(i = 0; i < tbStruct->numDims; i++ ) {
      free(tbStruct->bpStruct[i]);
    }
    free(tbStruct->bpStruct);
    free(tbStruct);
  }
  ssSetUserData(S, NULL);

  /*
  ssPrintf("In mdlTerminate.\n");
  */
}

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
