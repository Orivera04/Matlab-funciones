function out=qcdfvar(obj,X)
%QCDFVAR  Direct access to cdf variance function
%
% VAL=QCDFVAR(OBJ,X)  provides direct access to the
% cdf variation  mex function.
%
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:56:45 $

out=mx_cdfcalc(X);