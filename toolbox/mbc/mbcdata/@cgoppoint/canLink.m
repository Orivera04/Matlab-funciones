function ok = canLink(op,fact_i)
% ok = canLink(op,fact_i)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:28 $

if nargin<2
    fact_i = 1:length(op.ptrlist);
end

ok = op.created_flag(fact_i)==-1 | ...
    (op.created_flag(fact_i)==0 & isvalid(op.ptrlist(fact_i)));

ok(find(op.factor_type==3)) = 0;
