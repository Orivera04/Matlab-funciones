function [ok,order] = canAssign(op,fact_i,ptr)
% ok = canAssign(op,fact_i,ptr) check ptr can be assigned to fact_i
% [ok,order] = canAssign(op,fact_i) where fact_i length 2, check one 
%       can be assigned to other.  Order gives index into fact_i, where
%       element 1 is the unassigned factor and element 2 the cage factor.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:26 $

order = [];
if nargin==2 & length(fact_i)==2
    % One factor unassigned or with an internal ptr; 
    %  other factor valid ptr, created from cage.
    val = isvalid(op.ptrlist(fact_i));
    cr = (op.created_flag(fact_i)==1);
    if sum(val)==1
        order = [find(~val) find(val)];
    elseif sum(cr)==1
        order = [find(cr) find(~cr)];
    else
        order = [];
    end
    if isempty(order)
        ok = 0;
    else
        fact = fact_i(order(1)); expr = fact_i(order(2));
        ok = op.created_flag(expr)==-1 & ...
            ~any(isvalid(op.linkptrlist(fact_i)));
    end
elseif nargin==3 & length(fact_i)==1
    % factor currently unassigned or has an internal ptr;
    % valid ptr, not currently in dataset
    ok = (~isvalid(op.ptrlist(fact_i)) | op.created_flag(fact_i)==1) & ...
        isvalid(ptr) & ...
        ~ismember(double(ptr),double(op.ptrlist));
else
    ok = 0;
end
