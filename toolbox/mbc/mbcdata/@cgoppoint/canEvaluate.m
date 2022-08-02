function ok = canEvaluate(op,fact_i)
%CANEVALUATE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:27 $

if isempty(fact_i)
    ok = [];
else
    %  flag currently 0, valid pointer, not a value, not linked, not in group
    ok = repmat(0,1,length(fact_i));
    val = find(isvalid(op.ptrlist(fact_i)));
    for i = 1:length(val)
        this_i = fact_i(val(i));
        % Not a cgvalue;
        %  not linked;
        %  not in a group;
        %  not a created variable (eg an error)
        if ~op.ptrlist(this_i).isddvariable & ...
                ~isvalid(op.linkptrlist(this_i)) & ...
                op.group(this_i)==0 & ...
                op.created_flag(this_i)~=1
            if op.overwrite(this_i)==1 
                % Not already set to evaluate. Should be a tick by Treat as Input
                ok(val(i)) = 1;
            else
                % Is already set to evaluate, so the menu item needs 
                % a tick by it
                ok(val(i)) = 2;
            end
        end
    end
end
