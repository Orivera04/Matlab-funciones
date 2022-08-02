function out = isUniqueToDataset(op,fact_i)
%out = isUniqueToDataset(op,fact_i)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 06:52:01 $

if nargin<2
    fact_i = 1:length(op.ptrlist);
end
out = (op.created_flag(fact_i)==1);