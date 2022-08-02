//
// MATLAB Compiler: 3.0
// Date: Sun Nov 28 21:51:42 2004
// Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
// "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
// "array_indexing:on" "-O" "optimize_conditionals:on" "-B" "sglcpp" "-p" "-W"
// "main" "-L" "Cpp" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "-W" "mainhg"
// "libmwsglm.mlib" "simplexyplot" 
//
#ifndef __ylabel_hpp
#define __ylabel_hpp 1

#include "libmatlb.hpp"

extern void InitializeModule_ylabel();
extern void TerminateModule_ylabel();
extern _mexLocalFunctionTable _local_function_table_ylabel;

extern mwArray Nylabel(int nargout,
                       mwArray string = mwArray::DIN,
                       mwVarargin varargin = mwVarargin::DIN);
extern mwArray ylabel(mwArray string = mwArray::DIN,
                      mwVarargin varargin = mwVarargin::DIN);
extern void Vylabel(mwArray string = mwArray::DIN,
                    mwVarargin varargin = mwVarargin::DIN);
#ifdef __cplusplus
extern "C"
#endif
void mlxYlabel(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
