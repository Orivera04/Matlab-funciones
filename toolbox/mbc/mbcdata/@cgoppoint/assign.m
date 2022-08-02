function op = assign(op,fact_inds,thing)
% Assign(op,fact_i,thing)
% eval_fill required after

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.2.4 $  $Date: 2004/04/04 03:25:58 $

ptrs = []; remove_i = [];
if isa(thing,'xregpointer')
    ptrs = thing;
elseif isnumeric(thing)
    if ~all(ismember(thing,1:length(op.ptrlist)))
        error('bad index into factors');
    end
    ptrs = op.ptrlist(thing);
    remove_i = thing;
else
    error('cgoppoint::assign: ptr or factor required.');
end
if ~all(ismember(fact_inds,1:length(op.ptrlist)))
    error('bad index into factors');
elseif length(fact_inds)~=length(thing)
    error('require matching factor index and assignment');
elseif ~all(isvalid(ptrs))
    error('invalid pointer');
end

for i = 1:length(fact_inds)
    ptr = ptrs(i);
    if isvalid(ptr) && any(ptr==op.ptrlist)
        remove_i = [remove_i find(ptr==op.ptrlist)];
    end
    fact_i = fact_inds(i);

    % swap ignored to match ptr type.
%     if op.factor_type(fact_i)==0
%         if ptr.isddvariable
%             op.factor_type(fact_i) = 1;
%         else
%             op.factor_type(fact_i) = 2;
%         end
%     end

    % If dataset unit assigned and none for ptr, keep dataset unit.
    punit = ptr.grabUnits;
    if ~isempty(punit)
        if ~isempty(op.units{fact_i}) && compatible(op.units{fact_i},punit)
            % Ensure data is of correct units - convert if necessary.
            op.data(:,fact_i) = convert(op.units{fact_i},punit,op.data(:,fact_i));
        end
        op.units{fact_i} = punit;
    end

    if isvalid(op.ptrlist(fact_i))
        % Factor already has a pointer; check if an internal one.
        % Check whether assigning this factor will invalidate some
        %  other factors (eg error eqns) - sort out internal pointers.
        [inv_i,cause_i] = CheckRemove(op,fact_i);
        createdPtrtofree = op.ptrlist(fact_i);
        if ~isempty(cause_i)
            % Search all the cause_i and ensure that all cells  
            % contain fact_i
            allfactfault = 1;
            for k = 1:length(cause_i)
                if ~all(cause_i{k} == fact_i)
                    allfactfault = 0;
                    break;
                end
            end
            if allfactfault
                maplist = {op.ptrlist(fact_i), ptr};
                old_cr = op.created_flag;
                op.created_flag(inv_i)=1;
                ws = warning;
                warning('off');
                op = mapptr(op,maplist);
                warning(ws);
                op.created_flag = old_cr;
            end
            % No longer have non-evaluatable factors in data set
            % So, remove all invalidated factors
            remove_i = [remove_i inv_i];
        end
        if op.created_flag(fact_i)==1
            freeptr(createdPtrtofree);
        end
    end
    
    op.ptrlist(fact_i) = ptr;
    op.overwrite(fact_i) = 1;  % May be assigning to an output.
    op.created_flag(fact_i) = 0;  % If assigning, must be data column.
    if ~isempty(remove_i)
        if op.group(remove_i) > 0
            % The assigned column was in a group - must reset group/grid flags
            groupind = find(op.group == op.group(remove_i));
            groupind = setdiff(groupind, remove_i);
            op.grid_flag(groupind) = 8; % The factor in the group that isn't assigned will be a dep
            op.group(fact_i) = op.group(remove_i); % Need to keep the group number
        end
    end
end

if ~isempty(remove_i)
    
    op = removefactor(op,remove_i);
end
% Tidy up any evaluation
% Do this later
%op = eval_fill(op);
