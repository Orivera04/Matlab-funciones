//
// MATLAB Compiler: 3.0
// Date: Sun Nov 28 21:51:42 2004
// Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
// "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
// "array_indexing:on" "-O" "optimize_conditionals:on" "-B" "sglcpp" "-p" "-W"
// "main" "-L" "Cpp" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "-W" "mainhg"
// "libmwsglm.mlib" "simplexyplot" 
//
#ifndef __xlabel_hpp
#define __xlabel_hpp 1

#include "libmatlb.hpp"

extern void InitializeModule_xlabel();
extern void TerminateModule_xlabel();
extern _mexLocalFunctionTable _local_function_table_xlabel;

extern mwArray Nxlabel(int nargout,
                       mwArray string = mwArray::DIN,
                       mwVarargin varargin = mwVarargin::DIN);
extern mwArray xlabel(mwArray string = mwArray::DIN,
                      mwVarargin varargin = mwVarargin::DIN);
extern void Vxlabel(mwArray string = mwArray::DIN,
                    mwVarargin varargin = mwVarargin::DIN);
#ifdef __cplusplus
extern "C"
#endif
void mlxXlabel(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
