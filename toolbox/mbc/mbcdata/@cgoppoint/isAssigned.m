function out = isAssigned(op,fact_i)
%out = isAssigned(op,fact_i)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:56 $

if nargin<2
    fact_i = 1:length(op.ptrlist);
end
if isempty(fact_i)
    out = [];
elseif isnumeric(fact_i)
    out = isvalid(op.ptrlist(fact_i)) & ...
        op.created_flag(fact_i)==0;
elseif isa(fact_i,'xregpointer')
    out = [];
    for i = 1:length(fact_i)
        ptr = fact_i(i);
        f = find(ptr==op.ptrlist & op.created_flag>=0);
        if length(f)
            out = [out 1];
        else
            out = [out 0];
        end
    end
    %out = ismember(double(fact_i),double(op.ptrlist));
end