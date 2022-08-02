function out = isLink(op,fact_i)
%out = islink(op) returns 0 or 1 for each factor, if linked.
%out = islink(op,fact_i) returns link status for given factors

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 06:52:00 $

if nargin<2
    fact_i = 1:length(op.ptrlist);
end
if isempty(fact_i)
    out = [];
else
    out = isvalid(op.linkptrlist(fact_i)) & ...
        (op.created_flag(fact_i)~=-2);
end