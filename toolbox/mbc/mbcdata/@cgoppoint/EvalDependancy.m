function [dep_factors,evalind] = EvalDependancy(p,thing)
% [dep_factors] = EvalDependancy(p,ind)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.4 $  $Date: 2004/02/09 06:51:11 $

evalptr = [];
evalind = [];
AllOpPtrs = get(p,'ptrlist');
if isnumeric(thing)
    evalptr = p.ptrlist(thing);
    evalind = thing;
elseif isa(thing,'xregpointer')
    evalptr = thing;
    if ~isempty(AllOpPtrs)
        f = find(thing==AllOpPtrs);
        if length(f)==1
            evalind = f;
        end
    end
end
if ~isempty(evalptr)
    if isvalid(evalptr)
        thisparents = getAllInputs(evalptr.info);
    else
        thisparents = [];
    end
elseif isa(thing,'cgexpr')
    thisparents = getAllInputs(thing);
else
    error('mbc:cgoppoint:InvalidInput','unexpected input');
end

LinkPtrs = get(p,'linkptrlist');

% Outputs: assigned outputs are taken as inputs.
%     non-assignable outputs must be evaluated
overwrite = get(p,'iseditable');

use_i = find(overwrite);
% Checking an overwritten factor?  Does not depend on anything.
if ~isempty(evalind) && ismember(evalind,use_i)
    thisparents = [];
end

% Going to check the parents of each expression,
%  and allow evaluation if the dataset includes all
%  vector inputs, or replaces all vector inputs.
% Keep valid input (and assigned output) pointers.
if isempty(AllOpPtrs)
    OpPtrs = [];
else
    OpPtrs = AllOpPtrs(use_i);  %only keep inputs and assigned outputs
end

% Check whether any factors are included in parents list.
%  Do evaluation check on factor, if not already done,
%  and if ok, remove parents of this factor from ptr list.
% This section done with all factors (AllOpPtrs).

SpAllOpPtrs = AllOpPtrs;
sp = find(p.created_flag==-2);
SpAllOpPtrs(sp) = p.linkptrlist(sp);

Ptrs = thisparents;
if isempty(Ptrs)
    dep_factors = [];
else
    % checking a factor which is linked? Just check the link.
    if ~isempty(evalind) && isvalid(LinkPtrs(evalind)) && ...
            LinkPtrs(evalind)~=AllOpPtrs(evalind)
        [dep_factors,fact_i] = EvalDependancy(p,LinkPtrs(evalind));
        dep_factors = union(dep_factors,fact_i);
    else
        % don't need to check for links in this routine -
        %  factor replaces any parents regardless.
        rem_i = [];
        for i = 1:length(OpPtrs)
            if isvalid(OpPtrs(i))
                f = find(OpPtrs(i)== Ptrs);
                if ~isempty(f)  %matched something
                    rem = getAllInputs(OpPtrs(i).info);  %any parents to remove?
                    for j = 1:length(f) %may have several instances
                        rem_i = [ rem_i (f(j)+1:f(j)+length(rem)) ];  %relies on ptrs being returned the same by getptrs
                        % do not include the factor! Check for this
                    end
                end
            end
        end
        Ptrs(rem_i) = [];   %get rid of parents

        % find dependancies of links
        dep_factors = find(ismember(SpAllOpPtrs,Ptrs));
        %  Find also any specials which are in list.
    end
    % Check for a link on dependant factors.
    link_check = dep_factors;
    if ~isempty(link_check)
        f = find(isvalid(LinkPtrs(link_check)));
        for i = 1:length(f)
            [new_dep,fact_i] = EvalDependancy(p,LinkPtrs(link_check(f(i))));
            dep_factors = union(dep_factors,[new_dep fact_i]);
        end
    end
end

% any dependant factors in groups? Include all of group in list.
group = get(p,'group');
include = group(dep_factors);
include = setdiff(include,0); % ! Don't include everything.
dep_factors = union(dep_factors,find(ismember(group,include)));
