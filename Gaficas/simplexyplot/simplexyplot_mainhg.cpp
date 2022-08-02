//
// MATLAB Compiler: 3.0
// Date: Sun Nov 28 21:51:42 2004
// Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
// "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
// "array_indexing:on" "-O" "optimize_conditionals:on" "-B" "sglcpp" "-p" "-W"
// "main" "-L" "Cpp" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "-W" "mainhg"
// "libmwsglm.mlib" "simplexyplot" 
//
#include "libmatlb.hpp"
#include "libsglinit.hpp"
#include "simplexyplot.hpp"
#include "dataread_mex_interface.hpp"
#include "title.hpp"
#include "xlabel.hpp"
#include "ylabel.hpp"
#include "libmmfile.hpp"
#include "libmwsglm.hpp"

extern _mexcpp_information _main_info;

static mexFunctionTableEntry function_table[5]
  = { { "simplexyplot", mlxSimplexyplot, 1, -1,
        &_local_function_table_simplexyplot },
      { "dataread", mlxDataread, -1, -1, &_local_function_table_dataread },
      { "title", mlxTitle, -2, 1, &_local_function_table_title },
      { "xlabel", mlxXlabel, -2, 1, &_local_function_table_xlabel },
      { "ylabel", mlxYlabel, -2, 1, &_local_function_table_ylabel } };

static const char * path_list_[1] = { "c:\\matlab6p5\\toolbox\\matlab\\iofun" };

static _mexcppInitTermTableEntry init_term_table[7]
  = { { libmmfileInitialize, libmmfileTerminate },
      { libmwsglmInitialize, libmwsglmTerminate },
      { InitializeModule_simplexyplot, TerminateModule_simplexyplot },
      { InitializeModule_dataread_mex_interface,
        TerminateModule_dataread_mex_interface },
      { InitializeModule_title, TerminateModule_title },
      { InitializeModule_xlabel, TerminateModule_xlabel },
      { InitializeModule_ylabel, TerminateModule_ylabel } };

_mexcpp_information _main_info
  = { 1, 5, function_table, 0, NULL, 1, path_list_, 7, init_term_table };

//
// The function "main" is a Compiler-generated main wrapper, suitable for
// building a stand-alone application.  It calls a library function to perform
// initialization, call the main function, and perform library termination.
//
int main(int argc, const char * * argv) {
    return mwMainhg(argc, argv, mlxSimplexyplot, 1, &_main_info);
}
