/*
 * MATLAB Compiler: 3.0
 * Date: Mon Nov 15 22:13:40 2004
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-B" "sgl" "-m" "-W"
 * "main" "-L" "C" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "-W" "mainhg"
 * "libmwsglm.mlib" "simplexyplot" 
 */
#include "simplexyplot.h"
#include "dataread_mex_interface.h"
#include "libmatlbm.h"

static mxChar _array1_[4] = { 'f', 'i', 'l', 'e' };
static mxArray * _mxarray0_;

static mxChar _array3_[8] = { 'D', 'A', 'T', 'A', '.', 'o', 'u', 't' };
static mxArray * _mxarray2_;
static mxArray * _mxarray4_;
static mxArray * _mxarray5_;

void InitializeModule_simplexyplot(void) {
    _mxarray0_ = mclInitializeString(4, _array1_);
    _mxarray2_ = mclInitializeString(8, _array3_);
    _mxarray4_ = mclInitializeDouble(1.0);
    _mxarray5_ = mclInitializeDouble(2.0);
}

void TerminateModule_simplexyplot(void) {
    mxDestroyArray(_mxarray5_);
    mxDestroyArray(_mxarray4_);
    mxDestroyArray(_mxarray2_);
    mxDestroyArray(_mxarray0_);
}

static mxArray * Msimplexyplot(int nargout_, mxArray * mem);

_mexLocalFunctionTable _local_function_table_simplexyplot
  = { 0, (mexFunctionTableEntry *)NULL };

/*
 * The function "mlfSimplexyplot" contains the normal interface for the
 * "simplexyplot" M-function from file "c:\documents and
 * settings\administrator\desktop\opensees
 * processor\plotter\simplotxy\simplexyplot.m" (lines 1-27). This function
 * processes any input arguments and passes them to the implementation version
 * of the function, appearing above.
 */
mxArray * mlfSimplexyplot(mlfVarargoutList * varargout, mxArray * mem) {
    int nargout = 0;
    mlfEnterNewContext(0, 1, mem);
    nargout += mclNargout(varargout);
    *mlfGetVarargoutCellPtr(varargout) = Msimplexyplot(nargout, mem);
    mlfRestorePreviousContext(0, 1, mem);
    return mlfAssignOutputs(varargout);
}

/*
 * The function "mlxSimplexyplot" contains the feval interface for the
 * "simplexyplot" M-function from file "c:\documents and
 * settings\administrator\desktop\opensees
 * processor\plotter\simplotxy\simplexyplot.m" (lines 1-27). The feval function
 * calls the implementation version of simplexyplot through this function. This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
void mlxSimplexyplot(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[1];
    int i;
    if (nrhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: simplexyplot Line: 11 Colum"
            "n: 1 The function \"simplexyplot\" was called wit"
            "h more than the declared number of inputs (1)."),
          NULL);
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 1 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 1; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 1, mprhs[0]);
    mplhs[0] = Msimplexyplot(nlhs, mprhs[0]);
    mclAssignVarargoutCell(0, nlhs, plhs, mplhs[0]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
}

/*
 * The function "Msimplexyplot" is the implementation version of the
 * "simplexyplot" M-function from file "c:\documents and
 * settings\administrator\desktop\opensees
 * processor\plotter\simplotxy\simplexyplot.m" (lines 1-27). It contains the
 * actual compiled code for that M-function. It is a static function and must
 * only be called from one of the interface functions, appearing below.
 */
/*
 * % --------------------------------------------------------------
 * %  Written by: WaiChing Sun [stvsun@ucdavis.edu]
 * %     Purpose: generate the animation that visualize the motions
 * %              of the multistory building
 * %       Input: One input file that recorded the node coordinates
 * %              Files that recorded the motion of every nodes
 * %      Output: the movie on a new figure as well as a avi output
 * %              file.
 * % Last Update: 7/20/2004
 * %---------------------------------------------------------------
 * function varargout =simplexyplot(mem)
 */
static mxArray * Msimplexyplot(int nargout_, mxArray * mem) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_simplexyplot);
    mxArray * varargout = NULL;
    mxArray * ans = NULL;
    mxArray * y = NULL;
    mxArray * x = NULL;
    mxArray * col = NULL;
    mxArray * row = NULL;
    mclCopyArray(&mem);
    /*
     * %[filename, pathname] = uigetfile('*.out','Please Open the displacement file *.out',100,100);
     * 
     * 
     * 
     * % Put the data in the corresponding variables
     * %mem = load(['DATA.OUT']);
     * mem = dataread('file','DATA.out');
     */
    mlfAssign(
      &mem, mlfNDataread(0, mclValueVarargout(), _mxarray0_, _mxarray2_, NULL));
    /*
     * %mem=  load([filename])
     * % mem = importdata(filename,'') 
     * [row, col] = size(mem);
     */
    mlfSize(mlfVarargout(&row, &col, NULL), mclVa(mem, "mem"), NULL);
    /*
     * x=mem(1:row, 1);
     */
    mlfAssign(
      &x,
      mclArrayRef2(
        mclVa(mem, "mem"),
        mlfColon(_mxarray4_, mclVv(row, "row"), NULL),
        _mxarray4_));
    /*
     * y=mem(1:row, 2);
     */
    mlfAssign(
      &y,
      mclArrayRef2(
        mclVa(mem, "mem"),
        mlfColon(_mxarray4_, mclVv(row, "row"), NULL),
        _mxarray5_));
    /*
     * plot(x, y);
     */
    mclAssignAns(&ans, mlfNPlot(0, mclVv(x, "x"), mclVv(y, "y"), NULL));
    mxDestroyArray(row);
    mxDestroyArray(col);
    mxDestroyArray(x);
    mxDestroyArray(y);
    mxDestroyArray(ans);
    mxDestroyArray(mem);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return varargout;
    /*
     * 
     * 
     */
}
