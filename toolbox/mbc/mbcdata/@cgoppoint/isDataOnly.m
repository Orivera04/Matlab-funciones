function out = isDataOnly(op,fact_i)
%out = isDataOnly(op,fact_i)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:57 $

if nargin<2
    fact_i = 1:length(op.ptrlist);
end
out = (op.grid_flag(fact_i)==7);
