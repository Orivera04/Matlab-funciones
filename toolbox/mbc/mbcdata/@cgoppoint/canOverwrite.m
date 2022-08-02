function ok = canOverwrite(op,fact_i)
%CANOVERWRITE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:29 $

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
        %  not a created variable (ie an error)
        if ~op.ptrlist(this_i).isddvariable & ...
                ~isvalid(op.linkptrlist(this_i)) & ...
                op.group(this_i)==0 & ...
                op.created_flag(this_i)~=1
            if op.overwrite(this_i)==0 
                %  not already set to overwrite.
                ok(val(i)) = 1;
            else
                % Already set to overwrite, but can be toggled - menu item must be enabled.
                ok(val(i)) = 2;
            end
        end
    end
end
