//
// MATLAB Compiler: 3.0
// Date: Sun Nov 28 21:51:42 2004
// Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
// "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
// "array_indexing:on" "-O" "optimize_conditionals:on" "-B" "sglcpp" "-p" "-W"
// "main" "-L" "Cpp" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "-W" "mainhg"
// "libmwsglm.mlib" "simplexyplot" 
//
#include "simplexyplot.hpp"
#include "dataread_mex_interface.hpp"
#include "libmatlbm.hpp"
#include "libmwsglm.hpp"
#include "title.hpp"
#include "xlabel.hpp"
#include "ylabel.hpp"

static mxChar _array1_[5] = { '*', '.', 'o', 'u', 't' };
static mwArray _mxarray0_ = mclInitializeString(5, _array1_);

static mxChar _array3_[39] = { 'P', 'l', 'e', 'a', 's', 'e', ' ', 'O', 'p', 'e',
                               'n', ' ', 't', 'h', 'e', ' ', 'd', 'i', 's', 'p',
                               'l', 'a', 'c', 'e', 'm', 'e', 'n', 't', ' ', 'f',
                               'i', 'l', 'e', ' ', '*', '.', 'o', 'u', 't' };
static mwArray _mxarray2_ = mclInitializeString(39, _array3_);
static mwArray _mxarray4_ = mclInitializeDouble(100.0);

static mxChar _array8_[22] = { 'P', 'l', 'e', 'a', 's', 'e', ' ', 'e',
                               'n', 't', 'e', 'r', ' ', 't', 'h', 'e',
                               ' ', 't', 'i', 't', 'l', 'e' };
static mxArray * _mxarray7_ = mclInitializeString(22, _array8_);

static mxChar _array10_[35] = { 'P', 'l', 'e', 'a', 's', 'e', ' ', 'e', 'n',
                                't', 'e', 'r', ' ', 't', 'h', 'e', ' ', 'n',
                                'a', 'm', 'e', ' ', 'o', 'f', ' ', 't', 'h',
                                'e', ' ', 'x', ' ', 'a', 'x', 'i', 's' };
static mxArray * _mxarray9_ = mclInitializeString(35, _array10_);

static mxChar _array12_[31] = { 'P', 'l', 'e', 'a', 's', 'e', ' ', 'e',
                                'n', 't', 'e', 'r', ' ', 't', 'h', 'e',
                                ' ', 'n', 'a', 'm', 'e', ' ', 'o', 'f',
                                ' ', 'y', ' ', 'a', 'x', 'i', 's' };
static mxArray * _mxarray11_ = mclInitializeString(31, _array12_);

static mxArray * _array6_[3] = { _mxarray7_, _mxarray9_, _mxarray11_ };
static mwArray _mxarray5_ = mclInitializeCellVector(1, 3, _array6_);

static mxChar _array14_[26] = { 'E', 'N', 'T', 'E', 'R', ' ', 'T', 'I', 'T',
                                'L', 'E', ' ', 'A', 'N', 'D', ' ', 'A', 'X',
                                'I', 'S', ' ', 'N', 'A', 'M', 'E', 'S' };
static mwArray _mxarray13_ = mclInitializeString(26, _array14_);

static double _array16_[3] = { 1.0, 1.0, 1.0 };
static mwArray _mxarray15_ = mclInitializeDoubleVector(1, 3, _array16_);

static mxChar _array20_[5] = { 't', 'i', 't', 'l', 'e' };
static mxArray * _mxarray19_ = mclInitializeString(5, _array20_);

static mxChar _array22_[1] = { 'x' };
static mxArray * _mxarray21_ = mclInitializeString(1, _array22_);

static mxChar _array24_[1] = { 'y' };
static mxArray * _mxarray23_ = mclInitializeString(1, _array24_);

static mxArray * _array18_[3] = { _mxarray19_, _mxarray21_, _mxarray23_ };
static mwArray _mxarray17_ = mclInitializeCellVector(1, 3, _array18_);

static mxChar _array26_[4] = { 'f', 'i', 'l', 'e' };
static mwArray _mxarray25_ = mclInitializeString(4, _array26_);
static mwArray _mxarray27_ = mclInitializeDouble(1.0);
static mwArray _mxarray28_ = mclInitializeDouble(2.0);

void InitializeModule_simplexyplot() {
}

void TerminateModule_simplexyplot() {
    mxDestroyArray(_mxarray23_);
    mxDestroyArray(_mxarray21_);
    mxDestroyArray(_mxarray19_);
    mxDestroyArray(_mxarray11_);
    mxDestroyArray(_mxarray9_);
    mxDestroyArray(_mxarray7_);
}

static mwArray Msimplexyplot(int nargout_, mwArray mem);

_mexLocalFunctionTable _local_function_table_simplexyplot
  = { 0, (mexFunctionTableEntry *)NULL };

//
// The function "simplexyplot" contains the normal interface for the
// "simplexyplot" M-function from file "c:\documents and
// settings\administrator\desktop\opensees
// processor\plotter\simplotxy\simplexyplot.m" (lines 1-32). This function
// processes any input arguments and passes them to the implementation version
// of the function, appearing above.
//
mwArray simplexyplot(mwVarargout varargout, mwArray mem) {
    int nargout = 0;
    nargout += varargout.Nargout();
    varargout.GetCell() = Msimplexyplot(nargout, mem);
    return varargout.AssignOutputs();
}

//
// The function "mlxSimplexyplot" contains the feval interface for the
// "simplexyplot" M-function from file "c:\documents and
// settings\administrator\desktop\opensees
// processor\plotter\simplotxy\simplexyplot.m" (lines 1-32). The feval function
// calls the implementation version of simplexyplot through this function. This
// function processes any input arguments and passes them to the implementation
// version of the function, appearing above.
//
void mlxSimplexyplot(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    MW_BEGIN_MLX();
    {
        mwArray mprhs[1];
        mwArray mplhs[1];
        int i;
        mclCppUndefineArrays(1, mplhs);
        if (nrhs > 1) {
            error(
              mwVarargin(
                mwArray(
                  "Run-time Error: File: simplexyplot Line: 11 Column"
                  ": 1 The function \"simplexyplot\" was called with "
                  "more than the declared number of inputs (1).")));
        }
        for (i = 0; i < 1 && i < nrhs; ++i) {
            mprhs[i] = mwArray(prhs[i], 0);
        }
        for (; i < 1; ++i) {
            mprhs[i].MakeDIN();
        }
        mplhs[0] = Msimplexyplot(nlhs, mprhs[0]);
        mclAssignVarargoutCell(0, nlhs, plhs, mplhs[0].FreezeData());
    }
    MW_END_MLX();
}

//
// The function "Msimplexyplot" is the implementation version of the
// "simplexyplot" M-function from file "c:\documents and
// settings\administrator\desktop\opensees
// processor\plotter\simplotxy\simplexyplot.m" (lines 1-32). It contains the
// actual compiled code for that M-function. It is a static function and must
// only be called from one of the interface functions, appearing below.
//
//
// % --------------------------------------------------------------
// %  Written by: WaiChing Sun [stvsun@ucdavis.edu]
// %     Purpose: generate the animation that visualize the motions
// %              of the multistory building
// %       Input: One input file that recorded the node coordinates
// %              Files that recorded the motion of every nodes
// %      Output: the movie on a new figure as well as a avi output
// %              file.
// % Last Update: 7/20/2004
// %---------------------------------------------------------------
// function varargout =simplexyplot(mem)
//
static mwArray Msimplexyplot(int nargout_, mwArray mem) {
    mwLocalFunctionTable save_local_function_table_
      = &_local_function_table_simplexyplot;
    mwArray varargout = mwArray::UNDEFINED;
    mwArray ans = mwArray::UNDEFINED;
    mwArray y = mwArray::UNDEFINED;
    mwArray x = mwArray::UNDEFINED;
    mwArray col = mwArray::UNDEFINED;
    mwArray row = mwArray::UNDEFINED;
    mwArray plotnames = mwArray::UNDEFINED;
    mwArray prompt = mwArray::UNDEFINED;
    mwArray pathname = mwArray::UNDEFINED;
    mwArray filename = mwArray::UNDEFINED;
    //
    // [filename, pathname] = uigetfile('*.out','Please Open the displacement file *.out',100,100);
    //
    filename
    = uigetfile(&pathname, _mxarray0_, _mxarray2_, _mxarray4_, _mxarray4_);
    //
    // 
    // prompt = {'Please enter the title','Please enter the name of the x axis',...
    //
    prompt = _mxarray5_;
    //
    // 'Please enter the name of y axis'};
    // plotnames = inputdlg(prompt,'ENTER TITLE AND AXIS NAMES',[1 1 1],{'title','x','y'});
    //
    plotnames
      = Ninputdlg(
          1, mwVv(prompt, "prompt"), _mxarray13_, _mxarray15_, _mxarray17_);
    //
    // 
    // 
    // % Put the data in the corresponding variables
    // mem = dataread('file',filename);
    //
    mem
      = Ndataread(
          0,
          mwValueVarargout(),
          mwVarargin(_mxarray25_, mwVv(filename, "filename")));
    //
    // %mem = load(['DATA.OUT']);
    // %mem = dataread('file','DATA.out');
    // %mem=  load([filename])
    // % mem = importdata(filename,'') 
    // [row, col] = size(mem);
    //
    size(mwVarargout(row, col), mwVa(mem, "mem"));
    //
    // x=mem(1:row, 1);
    //
    x
      = mclArrayRef(
          mwVa(mem, "mem"), colon(_mxarray27_, mwVv(row, "row")), _mxarray27_);
    //
    // y=mem(1:row, 2);
    //
    y
      = mclArrayRef(
          mwVa(mem, "mem"), colon(_mxarray27_, mwVv(row, "row")), _mxarray28_);
    //
    // plot(x, y);
    //
    ans.EqAns(Nplot(0, mwVarargin(mwVv(x, "x"), mwVv(y, "y"))));
    //
    // title(plotnames(1));
    //
    ans.EqAns(
      Ntitle(0, mclIntArrayRef(mwVv(plotnames, "plotnames"), 1), mwVarargin()));
    //
    // xlabel(plotnames(2));
    //
    ans.EqAns(
      Nxlabel(
        0, mclIntArrayRef(mwVv(plotnames, "plotnames"), 2), mwVarargin()));
    //
    // ylabel(plotnames(3));
    //
    ans.EqAns(
      Nylabel(
        0, mclIntArrayRef(mwVv(plotnames, "plotnames"), 3), mwVarargin()));
    return varargout;
}
