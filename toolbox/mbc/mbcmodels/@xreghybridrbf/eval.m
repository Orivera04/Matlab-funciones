function y= eval(m,X)
% RBF/EVAL evaluate rbf 
% 
% y= eval(m,X)
% This code expects a (number of datapoints) x (number of factors) matrix X 
%
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:48:04 $



coeffs = double(m);
% this will ensure the submodels coefficients are up to date with the xreghybridrbf
m = update(m,coeffs); 

if ~isempty(X)
    y = eval(m.linearmodpart,X) + eval(m.rbfpart,X);
else
    y = zeros(0,1);
end
