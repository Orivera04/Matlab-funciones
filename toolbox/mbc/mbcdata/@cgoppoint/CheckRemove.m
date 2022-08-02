function [inv_i,cause_i] = CheckRemove(P,ind,opt);
% ind = CheckRemove(P,indexlist) checks whether the removal of
%     factors in indexlist will invalidate any other factors.
%     (eg a subexpr depending on a value unique to the dataset,
%        factors linked to this one)
%     indices of invalidated factors are returned.
% ind = CheckRemove(P,ptrlist) checks the factors in ptrlist.
% [ind,cause] = CheckRemove(...) returns matching indices of factors
%     which cause invalidation.

% Further Notes: cause_i now to be a cell array of indices for each
% invalidated factor. An invalidated factor may depend on more than one 
% of the removed pointers

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 06:51:08 $

if nargin<3, opt = ''; end

if isa(ind,'xregpointer')
    ind = ind(find(isvalid(ind)));
    rem_i = ismember(double(P.ptrlist), double(ind));
    rem_i = find(rem_i ~= 0);
elseif isa(ind,'double')
    if any(~ismember(ind,1:length(P.ptrlist)))
        error('cgoppoint::removefactor: bad index into factors.');
    else
        rem_i = ind;
    end
end

inv_i = []; cause_i = [];
% Any other (created) factors dependant on these ptrs?
notind = setdiff(1:length(P.ptrlist),rem_i);
% don't check factors being removed anyway.
rem_ptrs = P.ptrlist(rem_i);
c_i = find(P.created_flag==1);
c_i = intersect(c_i,notind);
ptrs = P.ptrlist(c_i);
for i = 1:length(ptrs)
    if isvalid(ptrs(i))
        ch = ptrs(i).getptrs;
        if any(ismember(double(ch),double(rem_ptrs)))
            % this factor is dependant on a removed pointer
            inv_i= [inv_i c_i(i)];
            cause_i = [cause_i {[ rem_i(find(ismember(double(rem_ptrs),double(ch))))]}];
        end
    end
end

valid_i = find(isvalid(P.linkptrlist));
validlinks = P.linkptrlist(valid_i);
rem_ptrs = P.ptrlist(rem_i);
% Do any links depend on the ptrs being removed?
for i = 1:length(rem_ptrs)
    if isvalid(rem_ptrs(i))
        if ismember(double(rem_ptrs(i)),double(validlinks))
            f = find(rem_ptrs(i)==P.linkptrlist);
            % f may be length>1
            cause_cell = cell(1,length(f));
            for k = 1:length(cause_cell)
                cause_cell{k} = rem_i(i);
            end
            cause_i = [cause_i cause_cell];
            inv_i = [inv_i f];
        end
    end
end

% Anything else got the same ptr (eg feature) (exclude null ptrs)
f = find(ismember(double(P.ptrlist(notind)),setdiff(double(rem_ptrs),0)));
for i = 1:length(f)
    f1 = find(P.ptrlist(notind(f))==rem_ptrs);
    cause_i = [cause_i {rem_i(f1)}];
    inv_i = [inv_i notind(f)];
end

% Any symvalues depend on the removed factors - if they do then 
% offer to delete the symvalue or keep the removed factors
allPtrs = P.ptrlist;
% keepind = find(ismember(double(allPtrs),setdiff(double(allPtrs), 0)));
% allPtrs = allPtrs(keepind);
for i = 1:length(allPtrs)
    if isvalid(allPtrs(i))
        if isddvariable(allPtrs(i).info) 
            if issymvalue(allPtrs(i).info)
                currRhs = getrhsptrs(allPtrs(i).info);
                currInd = find(ismember(double(rem_ptrs), double(currRhs)));
                if ~isempty(currInd)
                    inv_i = [inv_i i];
                    cause_i = [cause_i {[rem_i(currInd)]}];
                end
            end
        end
    end
end

% Now want to enforce the condition that everything in a data set must be 
% evaluatable. This means that removing an input must also remove outputs
% it depends on
rem_inputs = [];
rem_inp_index = [];
for i= 1:length(rem_ptrs)
    if isvalid(rem_ptrs(i))
        if isddvariable(rem_ptrs(i).info)
            rem_inputs = [rem_inputs rem_ptrs(i)];
            rem_inp_index = [rem_inp_index, i];
        end
    end
end

[notused1, notused2, fac_deps] = check_eval(P);

if ~isempty(rem_inputs)
    for j = 1:length(fac_deps)
        probinp = [];
        probinp = find(ismember(double(rem_inputs),double(fac_deps{j})));
        if ~isempty(probinp)
            inv_i = [inv_i j];
            cause_i = [cause_i {[rem_i(rem_inp_index(probinp))]}];
        end
    end
end