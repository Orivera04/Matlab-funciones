/* ----------------------------------------------------------------------------
 *  Program   :     lookup_methods.h
 *  Author    :     Bora Eryilmaz
 *
 *  Time-stamp:     <2004-03-18 13:22:24 beryilma>
 *  Copyright :     1990-2001 The MathWorks, Inc.
 *  Licence   :     MathWorks License Agreement
 *  $Revision: 1.1.6.3 $
 *
 *  Purpose   :     Function declarations and type definitions for
 *                  Adaptive Lookup Tables.
 * ------------------------------------------------------------------------- */

#ifndef __LOOKUP_METHODS_H__
#define __LOOKUP_METHODS_H__

#define MAX_NUM_DIMS  (30) /* Maximum number of table dimensions */

/* This order corresponds to the order of input arguments to S-function */
enum { Tb_NumDim_Idx,  Bp_Data_Idx,    Bp_Index_Idx,  Tb_Input_Idx,
       Tb_Data_Idx,    Tb_NumData_Idx, Ad_Method_Idx, Ad_Factor_Idx,
       Tb_Output_Idx,  Ad_Enable_Idx,  Ad_Lock_Idx,   Ad_Range_Idx,
       NUM_PARAMS };

/* Breakpoint parameters */
#define BP_DATA(S)    ssGetSFcnParam(S, Bp_Data_Idx)
#define BP_INDEX(S)   ssGetSFcnParam(S, Bp_Index_Idx)
/* Table parameters */
#define TB_NUMDIM(S)  ssGetSFcnParam(S, Tb_NumDim_Idx)
#define TB_DATA(S)    ssGetSFcnParam(S, Tb_Data_Idx)
#define TB_NUMDATA(S) ssGetSFcnParam(S, Tb_NumData_Idx)
#define TB_INPUT(S)   ssGetSFcnParam(S, Tb_Input_Idx)
#define TB_OUTPUT(S)  ssGetSFcnParam(S, Tb_Output_Idx)
/* Adaptation parameters */
#define AD_METHOD(S)  ssGetSFcnParam(S, Ad_Method_Idx)
#define AD_FACTOR(S)  ssGetSFcnParam(S, Ad_Factor_Idx)
#define AD_ENABLE(S)  ssGetSFcnParam(S, Ad_Enable_Idx)
#define AD_LOCK(S)    ssGetSFcnParam(S, Ad_Lock_Idx)
#define AD_RANGE(S)   ssGetSFcnParam(S, Ad_Range_Idx)

/* Parameter checks */
#define IS_OKCELL(p)  ( !mxIsEmpty(p) && mxIsCell(p) )
#define IS_OKREAL(p)  ( !mxIsEmpty(p) && mxIsNumeric(p) && !mxIsComplex(p) )
#define IS_OKREALSCALAR(p)  ( IS_OKREAL(p) && (mxGetNumberOfElements(p) == 1) )
#define IS_OKBOOL(p)  ( IS_OKREALSCALAR(p) && ( (0 == (int) mxGetScalar(p)) || (1 == (int) mxGetScalar(p)) ) )

/* Type definitions (enumerations and structures) */
typedef enum {ALT_DISABLE, ALT_ENABLE, ALT_RESET} EnableSignal; /* adaptation on/off/reset */
typedef enum {UNLOCK,   LOCK}   LockSignal;          /* cell location lock/unlock */
typedef enum {IGNORE=1, ADAPT}  RangeMode;  /* adapt to out-of-range data */
typedef enum {MEAN=1,   FORGET} AdaptMode;  /* adaptation method */

/* Structure to store mode information */
typedef struct MdStruct_tag {
  boolean_T enableMode;  /* adaptation enable mode */
  boolean_T lockMode;    /* cell locking mode */
  boolean_T tabIsInput;  /* true if table is at the input port */
  boolean_T tabIsOutput; /* true if table is at the output port */
  AdaptMode adaptMode;   /* adaptation mode */
  RangeMode rangeMode;   /* out of breakpoint range adaptation mode */
} MdStruct;

/* Structure to store information for each breakpoints set */
typedef struct BpStruct_tag {
  real_T    fraction; /* fraction for the current interval */
  real_T    *data;    /* pointer to array of breakpoints data */
  uint_T    index;    /* index for the current interval */
  uint_T    length;   /* number of breakpoints */
  boolean_T range;    /* range flag for the current data */
} BpStruct;

/* Structure to store information for the table */
typedef struct TbStruct_tag {
  BpStruct **bpStruct; /* array of pointers to breakpoint data structures */
  MdStruct *mdStruct;  /* pointer to mode data structure */
  real_T   *weights;   /* pointer to current array of adaptation weights */
  real_T   *tabData;   /* pointer to current array of adapted table data */
  real_T   *initData;  /* pointer to initial array of table data */
  real_T   *numData;   /* pointer to array of table numbering data */
  uint_T   index;      /* index of the updated table element */
  uint_T   numDims;    /* number of table dimensions */
  real_T   value;      /* value of table output */
  real_T   gain;       /* adaptation gain (forgetting factor) */
} TbStruct;

/* Function declarations */
int_T getNumTableDims( const int_T *tableDims, int_T numDims );
void bpUpdate( BpStruct *bpStruct, real_T x );
void tbUpdate( TbStruct *tpStruct, real_T z, EnableSignal enable );
void tbOutput( TbStruct *tbStruct, const real_T *u, const real_T *z,
	       EnableSignal enable, LockSignal lock, int_T numElements );

/* Error & Warning messages */
static char *makeTableInputMsg = "Value must be 'on' or 'off' (1 or 0) "
"for 'Make initial table an input' parameter";

static char *makeTableOutputMsg = "Value must be 'on' or 'off' (1 or 0) "
"for 'Make adapted table an output' parameter";

static char *addEnablePortMsg = "Value must be 'on' or 'off' (1 or 0) "
"for 'Add adaptation enable/disable/reset port' parameter";

static char *addCellLockPortMsg = "Value must be 'on' or 'off' (1 or 0) "
"for 'Add cell lock enable/disable port' parameter";

static char *rangeModeMsg = "'Action for out of range input' must be "
"Ignore (1) or Adapt (2)";

static char *adaptMethodMsg = "'Adaptation method' must be Sample mean (1) "
"or Sample mean (with forgetting) (2)";

static char *adaptFactorMsg = "Value must be between 0 and 1 for "
"'Adaptation gain' parameter";

static char *numDimsMsg = "'Number of table dimensions' must be at least 1 "
"and not more than 30 due to internal 32 bit array indexing limit";

static char *numDimsMatchMsg1 = "If defined, the number of dimensions of the "
"'Table data (initial)' parameter must match the 'Number of table dimensions' "
"indicated";

static char *numDimsMatchMsg2 = "If defined, the number of dimensions of the "
"'Table numbering data' parameter must match the 'Number of table dimensions' "
"indicated";

static char *numDimsMatchMsg3 = "If defined, the number of dimensions at the "
"Initial table port must match the 'Number of table dimensions' indicated";

static char *bpLengthMatchTableDim1 = "Length of breakpoint sets must match "
"the dimensions of the 'Table data (initial)' parameter";

static char *bpLengthMatchTableDim2 = "Length of breakpoint sets must match "
"the dimensions of the 'Table numbering data' parameter";

static char *bpLengthMatchTableDim3 = "Length of breakpoint sets must match "
"the dimensions of the Initial table input port data";

static char *bpDimMatchTableDim = "Number of table dimensions must match "
"dimensions indicated by the breakpoints";

static char *bpDataRealMsg = "Breakpoint data must be a real, non-empty array";

static char *bpLengthMsg = "Breakpoints must have at least 2 points "
"per dimension";

static char *bpDataIncreasing = "Breakpoint data must be strictly increasing";

static char *doubleOnlyMsg = "Only double datatype is supported at the I/O ports";

static char *wrongNumParams = "Incorrect number of parameters specified. "
"Need to supply 11: TB_NUMDIM, BP_CELL, TB_INPUT, TB_DATA, TB_NUMDATA, "
"AD_METHOD, AD_FACTOR, TB_OUTPUT, AD_ENABLE, AD_LOCK, AD_RANGE";

#endif /* __LOOKUP_METHODS_H__ */
