function [in_i,out_i,ig_i] = getFactorTypes(op,fact_i)
% CGOPPOINT/GETFACTORTYPES
%  [in_i,out_i,ig_i] = getFactorTypes(op) returns indices of input, 
%    output, and ignored factors.
%  [in_i,out_i,ig_i] = getFactorTypes(op,fact_i) returns indices for indexed 
%     factors only.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:43 $

if nargin<2
    fact_i = 1:length(op.ptrlist);
end

in_i = find(op.factor_type(fact_i)==1);
out_i = find(op.factor_type(fact_i)==2);
ig_i = find(op.factor_type(fact_i)==0);