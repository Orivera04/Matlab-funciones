function op = Link(op,fact_i,ptr)
% op = Link(op,fact_i,ptr)
%  eval_fill required afterwards.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 06:51:17 $

op.linkptrlist(fact_i) = ptr;
%op.factor_type(fact_i) = 2;
if op.factor_type(fact_i)==1
%if op.created_flag(fact_i)==0 & isvalid(op.ptrlist(fact_i))
    % Store original data as a hidden column
    if isempty(op.data)
        % Ensure that empty oppoints can be handled
        storedata = [];
    else
        storedata = op.data(:,fact_i);
    end
    op = addfactor(op,op.ptrlist(fact_i),storedata);
    if ~isvalid(op.ptrlist(fact_i))
        % Obscure case of linking to an unassigned input 
        % Example: Fill a trade off table with cst and
        % try to link to that cst
        % This change should avoid a subsequent error in findName
        op.orig_name(end) = op.orig_name(fact_i);
    end
    op.factor_type(end) = 3; % hidden
    op.factor_type(fact_i) = 1;
    %op.grid_flag(end) = op.grid_flag(fact_i);
end

% Need to do this - but do it outside (eg when OK pressed)
% Slows things down otherwise
%op = eval_fill(op);
