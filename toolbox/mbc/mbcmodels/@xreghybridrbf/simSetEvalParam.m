function simSetEvalParam(m,sys)
%SIMSETEVALPARAM

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:48:23 $

coeffs = double(m);
% this will ensure the submodels coefficients are up to date with the xreghybridrbf
m = update(m,coeffs); 

simSetEvalParam(m.linearmodpart, sys);
simSetEvalParam(m.rbfpart, sys);
