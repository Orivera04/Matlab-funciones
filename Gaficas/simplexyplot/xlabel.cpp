//
// MATLAB Compiler: 3.0
// Date: Sun Nov 28 21:51:42 2004
// Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
// "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
// "array_indexing:on" "-O" "optimize_conditionals:on" "-B" "sglcpp" "-p" "-W"
// "main" "-L" "Cpp" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "-W" "mainhg"
// "libmwsglm.mlib" "simplexyplot" 
//
#include "xlabel.hpp"
#include "mwservices.h"
#include "libmatlbm.hpp"
#include "libmmfile.hpp"

static mxChar _array1_[35] = { 'I', 'n', 'c', 'o', 'r', 'r', 'e', 'c', 't',
                               ' ', 'n', 'u', 'm', 'b', 'e', 'r', ' ', 'o',
                               'f', ' ', 'i', 'n', 'p', 'u', 't', ' ', 'a',
                               'r', 'g', 'u', 'm', 'e', 'n', 't', 's' };
static mwArray _mxarray0_ = mclInitializeString(35, _array1_);

static mxChar _array3_[15] = { 'M', 'W', 'B', 'Y', 'P', 'A', 'S', 'S',
                               '_', 'x', 'l', 'a', 'b', 'e', 'l' };
static mwArray _mxarray2_ = mclInitializeString(15, _array3_);

static mxChar _array5_[6] = { 'x', 'l', 'a', 'b', 'e', 'l' };
static mwArray _mxarray4_ = mclInitializeString(6, _array5_);

static mxChar _array7_[9] = { 'F', 'o', 'n', 't', 'A', 'n', 'g', 'l', 'e' };
static mwArray _mxarray6_ = mclInitializeString(9, _array7_);

static mxChar _array9_[8] = { 'F', 'o', 'n', 't', 'N', 'a', 'm', 'e' };
static mwArray _mxarray8_ = mclInitializeString(8, _array9_);

static mxChar _array11_[8] = { 'F', 'o', 'n', 't', 'S', 'i', 'z', 'e' };
static mwArray _mxarray10_ = mclInitializeString(8, _array11_);

static mxChar _array13_[10] = { 'F', 'o', 'n', 't', 'W',
                                'e', 'i', 'g', 'h', 't' };
static mwArray _mxarray12_ = mclInitializeString(10, _array13_);

static mxChar _array15_[6] = { 's', 't', 'r', 'i', 'n', 'g' };
static mwArray _mxarray14_ = mclInitializeString(6, _array15_);

void InitializeModule_xlabel() {
}

void TerminateModule_xlabel() {
}

static mwArray Mxlabel(int nargout_, mwArray string, mwArray varargin);

_mexLocalFunctionTable _local_function_table_xlabel
  = { 0, (mexFunctionTableEntry *)NULL };

//
// The function "Nxlabel" contains the nargout interface for the "xlabel"
// M-function from file "c:\matlab6p5\toolbox\matlab\graph2d\xlabel.m" (lines
// 1-41). This interface is only produced if the M-function uses the special
// variable "nargout". The nargout interface allows the number of requested
// outputs to be specified via the nargout argument, as opposed to the normal
// interface which dynamically calculates the number of outputs based on the
// number of non-NULL inputs it receives. This function processes any input
// arguments and passes them to the implementation version of the function,
// appearing above.
//
mwArray Nxlabel(int nargout, mwArray string, mwVarargin varargin) {
    mwArray hh = mwArray::UNDEFINED;
    hh = Mxlabel(nargout, string, varargin.ToArray());
    return hh;
}

//
// The function "xlabel" contains the normal interface for the "xlabel"
// M-function from file "c:\matlab6p5\toolbox\matlab\graph2d\xlabel.m" (lines
// 1-41). This function processes any input arguments and passes them to the
// implementation version of the function, appearing above.
//
mwArray xlabel(mwArray string, mwVarargin varargin) {
    int nargout = 1;
    mwArray hh = mwArray::UNDEFINED;
    hh = Mxlabel(nargout, string, varargin.ToArray());
    return hh;
}

//
// The function "Vxlabel" contains the void interface for the "xlabel"
// M-function from file "c:\matlab6p5\toolbox\matlab\graph2d\xlabel.m" (lines
// 1-41). The void interface is only produced if the M-function uses the
// special variable "nargout", and has at least one output. The void interface
// function specifies zero output arguments to the implementation version of
// the function, and in the event that the implementation version still returns
// an output (which, in MATLAB, would be assigned to the "ans" variable), it
// deallocates the output. This function processes any input arguments and
// passes them to the implementation version of the function, appearing above.
//
void Vxlabel(mwArray string, mwVarargin varargin) {
    mwArray hh = mwArray::UNDEFINED;
    hh = Mxlabel(0, string, varargin.ToArray());
}

//
// The function "mlxXlabel" contains the feval interface for the "xlabel"
// M-function from file "c:\matlab6p5\toolbox\matlab\graph2d\xlabel.m" (lines
// 1-41). The feval function calls the implementation version of xlabel through
// this function. This function processes any input arguments and passes them
// to the implementation version of the function, appearing above.
//
void mlxXlabel(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    MW_BEGIN_MLX();
    {
        mwArray mprhs[2];
        mwArray mplhs[1];
        int i;
        mclCppUndefineArrays(1, mplhs);
        if (nlhs > 1) {
            error(
              mwVarargin(
                mwArray(
                  "Run-time Error: File: xlabel Line: 1 Column: 1"
                  " The function \"xlabel\" was called with more "
                  "than the declared number of outputs (1).")));
        }
        for (i = 0; i < 1 && i < nrhs; ++i) {
            mprhs[i] = mwArray(prhs[i], 0);
        }
        for (; i < 1; ++i) {
            mprhs[i].MakeDIN();
        }
        mprhs[1] = mclCreateVararginCell(nrhs - 1, prhs + 1);
        mplhs[0] = Mxlabel(nlhs, mprhs[0], mprhs[1]);
        plhs[0] = mplhs[0].FreezeData();
    }
    MW_END_MLX();
}

//
// The function "Mxlabel" is the implementation version of the "xlabel"
// M-function from file "c:\matlab6p5\toolbox\matlab\graph2d\xlabel.m" (lines
// 1-41). It contains the actual compiled code for that M-function. It is a
// static function and must only be called from one of the interface functions,
// appearing below.
//
//
// function hh = xlabel(string,varargin)
//
static mwArray Mxlabel(int nargout_, mwArray string, mwArray varargin) {
    mwLocalFunctionTable save_local_function_table_
      = &_local_function_table_xlabel;
    int nargin_ = nargin(-2, mwVarargin(string, varargin));
    mwArray hh = mwArray::UNDEFINED;
    mwArray h = mwArray::UNDEFINED;
    mwArray ax = mwArray::UNDEFINED;
    mwArray ans = mwArray::UNDEFINED;
    //
    // %XLABEL X-axis label.
    // %   XLABEL('text') adds text beside the X-axis on the current axis.
    // %
    // %   XLABEL('text','Property1',PropertyValue1,'Property2',PropertyValue2,...)
    // %   sets the values of the specified properties of the xlabel.
    // %
    // %   H = XLABEL(...) returns the handle to the text object used as the label.
    // %
    // %   See also YLABEL, ZLABEL, TITLE, TEXT.
    // 
    // %   Copyright 1984-2002 The MathWorks, Inc. 
    // %   $Revision: 5.13 $  $Date: 2002/04/08 21:44:38 $
    // 
    // if nargin > 1 & (nargin-1)/2-fix((nargin-1)/2),
    //
    mwArray a_ = nargin_ > 1;
    if (tobool(a_)
        && tobool(
             a_
             & svDoubleScalarRdivide((double) (nargin_ - 1), 2.0)
               - fix(
                   mwArray(
                     svDoubleScalarRdivide((double) (nargin_ - 1), 2.0))))) {
        //
        // error('Incorrect number of input arguments')
        //
        error(mwVarargin(_mxarray0_));
    } else {
    }
    //
    // end
    // 
    // ax = gca;
    //
    ax = gca(mwArray::DIN);
    //
    // 
    // %---Check for bypass option
    // if isappdata(ax,'MWBYPASS_xlabel')
    //
    if (tobool(isappdata(mwVv(ax, "ax"), _mxarray2_))) {
        //
        // h = mwbypass(ax,'MWBYPASS_xlabel',string,varargin{:});
        //
        h
          = Ngraph2d_private_mwbypass(
              1,
              mwVv(ax, "ax"),
              _mxarray2_,
              mwVarargin(
                mwVa(string, "string"),
                mwVa(varargin, "varargin").cell(colon())));
    //
    // 
    // %---Standard behavior
    // else
    //
    } else {
        //
        // h = get(ax,'xlabel');
        //
        h = Nget(1, mwVarargin(mwVv(ax, "ax"), _mxarray4_));
        //
        // 
        // %Over-ride text objects default font attributes with
        // %the Axes' default font attributes.
        // set(h, 'FontAngle',  get(ax, 'FontAngle'), ...
        //
        ans.EqAns(
          Nset(
            0,
            mwVarargin(
              mwVv(h, "h"),
              _mxarray6_,
              Nget(1, mwVarargin(mwVv(ax, "ax"), _mxarray6_)),
              _mxarray8_,
              Nget(1, mwVarargin(mwVv(ax, "ax"), _mxarray8_)),
              _mxarray10_,
              Nget(1, mwVarargin(mwVv(ax, "ax"), _mxarray10_)),
              _mxarray12_,
              Nget(1, mwVarargin(mwVv(ax, "ax"), _mxarray12_)),
              _mxarray14_,
              mwVa(string, "string"),
              mwVa(varargin, "varargin").cell(colon()))));
    //
    // 'FontName',   get(ax, 'FontName'), ...
    // 'FontSize',   get(ax, 'FontSize'), ...
    // 'FontWeight', get(ax, 'FontWeight'), ...
    // 'string',     string,varargin{:});
    // end
    //
    }
    //
    // 
    // if nargout > 0
    //
    if (nargout_ > 0) {
        //
        // hh = h;
        //
        hh = mwVv(h, "h");
    //
    // end
    //
    }
    mwValidateOutput(hh, 1, nargout_, "hh", "xlabel");
    return hh;
}
