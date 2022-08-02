function out = getUnits(op,fact_i)
% un = getUnits(op)
% un = getUnits(op,fact_i)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:53 $

if nargin<2, fact_i = 1:length(op.ptrlist); end

out = op.units(fact_i);
if length(out)==1
    out = out{1};
end