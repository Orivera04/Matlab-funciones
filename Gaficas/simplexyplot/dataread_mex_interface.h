/*
 * MATLAB Compiler: 3.0
 * Date: Mon Nov 15 22:13:40 2004
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-B" "sgl" "-m" "-W"
 * "main" "-L" "C" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "-W" "mainhg"
 * "libmwsglm.mlib" "simplexyplot" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __dataread_mex_interface_h
#define __dataread_mex_interface_h 1

#ifdef __cplusplus
extern "C" {
#endif

#include "libmatlb.h"

extern void InitializeModule_dataread_mex_interface(void);
extern void TerminateModule_dataread_mex_interface(void);
extern _mexLocalFunctionTable _local_function_table_dataread;

extern mxArray * mlfNDataread(int nargout, mlfVarargoutList * varargout, ...);
extern mxArray * mlfDataread(mlfVarargoutList * varargout, ...);
extern void mlfVDataread(mxArray * synthetic_varargin_argument, ...);
extern void mlxDataread(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#ifdef __cplusplus
}
#endif

#endif
