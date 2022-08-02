//
// MATLAB Compiler: 3.0
// Date: Sun Nov 28 21:51:42 2004
// Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
// "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
// "array_indexing:on" "-O" "optimize_conditionals:on" "-B" "sglcpp" "-p" "-W"
// "main" "-L" "Cpp" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "-W" "mainhg"
// "libmwsglm.mlib" "simplexyplot" 
//
#include "dataread_mex_interface.hpp"

void InitializeModule_dataread_mex_interface() {
}

void TerminateModule_dataread_mex_interface() {
}

static mwArray Mdataread(int nargout_, mwArray varargin);

_mexLocalFunctionTable _local_function_table_dataread
  = { 0, (mexFunctionTableEntry *)NULL };

//
// The function "Ndataread" contains the nargout interface for the "dataread"
// M-function from file "c:\matlab6p5\toolbox\matlab\iofun\dataread.dll" (lines
// 0-0). This interface is only produced if the M-function uses the special
// variable "nargout". The nargout interface allows the number of requested
// outputs to be specified via the nargout argument, as opposed to the normal
// interface which dynamically calculates the number of outputs based on the
// number of non-NULL inputs it receives. This function processes any input
// arguments and passes them to the implementation version of the function,
// appearing above.
//
mwArray Ndataread(int nargout, mwVarargout varargout, mwVarargin varargin) {
    nargout += varargout.Nargout();
    varargout.GetCell() = Mdataread(nargout, varargin.ToArray());
    return varargout.AssignOutputs();
}

//
// The function "dataread" contains the normal interface for the "dataread"
// M-function from file "c:\matlab6p5\toolbox\matlab\iofun\dataread.dll" (lines
// 0-0). This function processes any input arguments and passes them to the
// implementation version of the function, appearing above.
//
mwArray dataread(mwVarargout varargout, mwVarargin varargin) {
    int nargout = 0;
    nargout += varargout.Nargout();
    varargout.GetCell() = Mdataread(nargout, varargin.ToArray());
    return varargout.AssignOutputs();
}

//
// The function "Vdataread" contains the void interface for the "dataread"
// M-function from file "c:\matlab6p5\toolbox\matlab\iofun\dataread.dll" (lines
// 0-0). The void interface is only produced if the M-function uses the special
// variable "nargout", and has at least one output. The void interface function
// specifies zero output arguments to the implementation version of the
// function, and in the event that the implementation version still returns an
// output (which, in MATLAB, would be assigned to the "ans" variable), it
// deallocates the output. This function processes any input arguments and
// passes them to the implementation version of the function, appearing above.
//
void Vdataread(mwVarargin varargin) {
    mwArray varargout = mwArray::UNDEFINED;
    varargout = Mdataread(0, varargin.ToArray());
}

//
// The function "mlxDataread" contains the feval interface for the "dataread"
// M-function from file "c:\matlab6p5\toolbox\matlab\iofun\dataread.dll" (lines
// 0-0). The feval function calls the implementation version of dataread
// through this function. This function processes any input arguments and
// passes them to the implementation version of the function, appearing above.
//
void mlxDataread(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    MW_BEGIN_MLX();
    {
        mwArray mprhs[1];
        mwArray mplhs[1];
        mclCppUndefineArrays(1, mplhs);
        mprhs[0] = mclCreateVararginCell(nrhs, prhs);
        mplhs[0] = Mdataread(nlhs, mprhs[0]);
        mclAssignVarargoutCell(0, nlhs, plhs, mplhs[0].FreezeData());
    }
    MW_END_MLX();
}

//
// The function "Mdataread" is the implementation version of the "dataread"
// M-function from file "c:\matlab6p5\toolbox\matlab\iofun\dataread.dll" (lines
// 1-1). It contains the actual compiled code for that M-function. It is a
// static function and must only be called from one of the interface functions,
// appearing below.
//
static mwArray Mdataread(int nargout_, mwArray varargin) {
    mwLocalFunctionTable save_local_function_table_
      = &_local_function_table_dataread;
    return mclCppExecMexFile("dataread", nargout_, varargin);
}
