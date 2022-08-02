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

#include "libmatlb.h"
#include "libsgl.h"
#include "simplexyplot.h"
#include "dataread_mex_interface.h"

extern _mex_information _main_info;

static mexFunctionTableEntry function_table[2]
  = { { "simplexyplot", mlxSimplexyplot, 1, -1,
        &_local_function_table_simplexyplot },
      { "dataread", mlxDataread, -1, -1, &_local_function_table_dataread } };

static const char * path_list_[1] = { "c:\\matlab6p5\\toolbox\\matlab\\iofun" };

static _mexInitTermTableEntry init_term_table[2]
  = { { InitializeModule_simplexyplot, TerminateModule_simplexyplot },
      { InitializeModule_dataread_mex_interface,
        TerminateModule_dataread_mex_interface } };

_mex_information _main_info
  = { 1, 2, function_table, 0, NULL, 1, path_list_, 2, init_term_table };

/*
 * The function "main" is a Compiler-generated main wrapper, suitable for
 * building a stand-alone application.  It calls a library function to perform
 * initialization, call the main function, and perform library termination.
 */
int main(int argc, const char * * argv) {
    return mclMainhg(argc, argv, mlxSimplexyplot, 1, &_main_info);
}
