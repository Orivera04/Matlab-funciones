function op = Unassign(op,fact_i)
% Unassign(op,fact_i)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.3 $  $Date: 2004/02/09 06:51:23 $

if ~isempty(fact_i)
    f = find(isvalid(op.linkptrlist(fact_i)));
    if ~isempty(f)
        op = BreakLink(op,fact_i(f));
    end
    oldptrlist = op.ptrlist;
    % Checked unassigned factor for groups
    % If factor in a group - disband group.
    unGroupNo = op.group(fact_i);
    if unGroupNo
        % Two cases - it's the symvalue, or an input
        thing = op.ptrlist(fact_i);
        if issymvalue(thing.info)
            % Symvalue - disband the group
            ind = find(op.group == unGroupNo);
            op.group(ind) = 0;
        else
            % Input - add a copy of the input
            % The original input should be overwritten
            % in the rest of the method
            op = addfactor(op, thing, op.data(:,fact_i));
            % Reset the group flags 
            addind = size(op.data, 2);
            op.group(addind) = op.group(fact_i);
            op.group(fact_i) = 0;
            op.ptrlist(fact_i) = xregpointer;
            return;
        end
    end
    [inv_i,cause_i] = CheckRemove(op,fact_i);        
    op.ptrlist(fact_i) = xregpointer;
    if ~isempty(cause_i)
        done = []; mapfrom = []; mapto = [];
        cause_i = [cause_i{:}];
        for i = 1:length(cause_i)
            if ~ismember(cause_i(i),done)
                [op,f,ptr] = AddCage(op,cause_i(i));
                mapfrom = [mapfrom oldptrlist(cause_i(i))];
                mapto = [mapto ptr];
                op.ptrlist(cause_i(i)) = ptr;
                done = [done cause_i(i)];
            end
        end
        % Ensure invalid ptrs get mapped.
        old_cr = op.created_flag;
        op.created_flag(inv_i)=1;
        ws = warning;
        warning('off');
        op = mapptr(op,{mapfrom mapto});
        warning(ws);
        op.created_flag = old_cr;
    end
    f = find(op.created_flag(fact_i)==-1);
    if ~isempty(f) | ~isempty(inv_i)
        op = removefactor(op,[fact_i(f) inv_i]);
    end
end
