function [ok,all_need_ptrs,OpParents,order] = check_eval(p,things,parents,vectors);
%CHECK_EVAL Pre-evaluation checking for dataset
%
%  ok = check_eval(P) checks evaluation for each factor
%  ok = check_eval(P,ptrlist)
%  ok = check_eval(P,indexlist)
%  ok = check_eval(P,{expressions})
%  [ok, need_ptrs] = check_eval(...) returns value pointers required
%
%  check_eval(p,exprs,getptrs,vectors) passes in the getptrs for each of exprs
%  and the ptrs to all vectors required.  This is faster, if these are known.
%
%  [ok, need_ptrs, order] = check_eval(p) returns evaluation order for factors
%  [ok, need_ptrs, order] = check_eval(p,oldorder) starts with old order
%
%  Use check_eval prior to calling i_eval.
%
%  See also: i_eval, eval_fill

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.3 $  $Date: 2004/02/09 06:51:36 $

order = []; OpParents = [];
ok = []; all_need_ptrs = [];

if nargout>2 & (nargin~=1 & nargin~=2)
    error('check_eval: syntax: [ch,need,parents,order] = check_eval(p).');
elseif nargout>2
    if nargin<2
        things = 1:length(p.ptrlist);
    end
    order = 1:length(p.ptrlist);
elseif nargin<2
    things = 1:length(p.ptrlist);
elseif nargin<1
    error('check_eval: syntax: ch = check_eval(p,things).');
end

if isnumeric(things)
    if ~all(ismember(things,1:length(p.ptrlist)))
        error('check_eval: bad index into factor list');
    end
    if ~isempty(order)
        order = [things setdiff(1:length(p.ptrlist),things)]; 
    end
    if isempty(things)
        if ~isempty(p.ptrlist) & any(isvalid(p.ptrlist))
            % things is left unaltered in the case of a data set purely consisting
            % of imported data. Nothing to evaluate.
            things = 1:length(p.ptrlist);
        end
    end
elseif isa(things,'xregpointer')
    for i = 1:length(things)
        if ~isvalid(things(i)) | ~things(i).isa('cgexpr')
            error('check_eval: require vector of valid xregpointers to expressions.');
        end
    end
elseif iscell(things)
    for i = 1:length(things)
        if ~isa(things{i},'cgexpr')
            error('check_eval: require cell array of expressions.');
        end
    end
elseif isa(things,'expression')
    things = {things};
else
    error('check_eval: require indices, pointers or expressions.');
end

if nargin<3
    parents = [];
elseif length(parents)~=length(things)
    error('check_eval: parents must match expressions.');
end

if nargin<4
    vectors = [];
end

factors = get(p,'factors');
if isempty(p.factor_type)
    ig_i = []; 
else
    ig_i = find(p.factor_type==0);
end
AllOpPtrs = p.ptrlist;

% Outputs: assigned outputs are taken as inputs.
%     non-assignable outputs must be evaluated
overwrite = get(p,'iseditable');

use_i = find(overwrite);
if ~isempty(order)
    % bring overwrites to front of order
    % also bring group members together (may be reshuffled later if necessary)
    order = [order(ismember(order,use_i)) order(~ismember(order,use_i))];
end

% record which factors we've checked for evaluation 
%  and found parents for.
done_factor = zeros(1,length(factors));
% inputs and assigned outputs can be evaluated - set flag
%  (unless they are linked)
done_factor(use_i) = 1;
check = done_factor;

% Going to check the parents of each expression,
%  and allow evaluation if the dataset includes all
%  vector inputs, or replaces all vector inputs.
% Keep valid input (and assigned output) pointers.
LinkPtrs = get(p,'linkptrlist');
if isempty(AllOpPtrs)
    use_i = []; OpPtrs = [];
else
    valid = isvalid(AllOpPtrs);  % ensure all ptrs are valid
    use_i = use_i(find(valid(use_i)));
    OpPtrs = AllOpPtrs(use_i);  %only keep inputs and assigned outputs
end

if isempty(OpPtrs)
    % make sure OpPtrs is an xregpointer
    OpPtrs= null(xregpointer,[1,0]);
end


% Specials - eg feature; linkptr is actually the one we want to check against
%  (original ptr is used to generate correct icon)
if ~isempty(p.ptrlist)
    sp = find(p.created_flag==-2);
    AllOpPtrs(sp) = p.linkptrlist(sp);
end

OpParents = cell(1,length(factors));
OpParents(use_i)= pveceval( OpPtrs,@getAllInputs);

OpNeed = cell(1,length(factors));

for j = 1:length(things)
    evalptr = [];
    evalfactor = [];
    evalexpr = [];
    out = [];
    need_ptrs = [];
    if isnumeric(things)
        evalfactor = things(j);
    elseif isa(things,'xregpointer')
        if isempty(AllOpPtrs)
            evalptr = things(j);
        else
            f = find(things(j)==AllOpPtrs);
            if length(f)==1
                evalfactor = f;
            else
                evalptr = things(j);
            end
        end
    elseif iscell(things)
        name = getname(things{j});
        f = strcmp(name,factors);
        if length(f)==1
            evalfactor = f;
        else
            evalexpr = things{j};
        end
    else
        error('should not get here');
    end
    
    thisparents = [];
    if ~isempty(evalfactor)
        evalptr = [];
        if ~isvalid(AllOpPtrs(evalfactor))
            % unassigned factor - can be evaluated providing data is present
            out = 1;
        elseif ~done_factor(evalfactor)
            [done_factor,check,OpParents,OpNeed,order] = ...
                i_DoFactor(evalfactor,OpPtrs,AllOpPtrs,LinkPtrs,done_factor,check,OpParents,OpNeed,order,ig_i,vectors);
        end
        out = check(evalfactor);
        need_ptrs = OpNeed{evalfactor};
    end
    
    if ~isempty(parents)
        thisparents = parents{j};
    else
        if ~isempty(evalptr)
            thisparents = getAllInputs(info(evalptr));
        elseif ~isempty(evalexpr)
            thisparents = getAllInputs(evalexpr);
        end
    end
    
    if isempty(thisparents) & isempty(out)
        % values do not have parents.
        %  Cannot evaluate a value if it is not in dataset.
        %  Values which are in dataset are picked out as evalfactor.
        out = 0;
        % Return the needed pointer.  This fails if trying to evaluate
        %  an expression (eg a value) - no way round this one.
        need_ptrs = evalptr;    
        % check for special case of subfeature with no model or equation
        if ~isempty(evalptr) & isvalid(evalptr)
            if evalptr.isa('cgfeature')
                out = 1;
                need_ptrs = [];
            end
        end
    end
    
    if isempty(out)
        % haven't yet decided if ok
        % So - an expression (but not a value) not in the dataset.
        [out,need_ptrs,done_factor,check,OpParents,OpNeed,order] = ...
            i_CheckPtr(thisparents,OpPtrs,AllOpPtrs,LinkPtrs,done_factor,check,OpParents,OpNeed,order,ig_i,vectors);
    end
    ok = [ok out];
    all_need_ptrs = [all_need_ptrs {need_ptrs}];
end


%-------------------------------------------------------------------
function [done_factor,check,OpParents,OpNeed,order] = ...
    i_DoFactor(i,OpPtrs,AllOpPtrs,LinkPtrs,done_factor,check,OpParents,OpNeed,order,ig_i,vectors)
%-------------------------------------------------------------------
 
% get parents for this factor
OpParents{i} =  getAllInputs(AllOpPtrs(i).info);
% Is this factor linked? Continue using the link and its parents.
%  For ignored factors, use parents as normal.
if isvalid(LinkPtrs(i)) & ~ismember(i,ig_i)
    % pass link parents on to next routine.
    thisparents = [LinkPtrs(i)  getAllInputs(LinkPtrs(i).info)];
else
    thisparents = OpParents{i};
end
done_factor(i) = 1;

% No parents -> a value (prob. set to ignore)
% Cannot evaluate unless linked
if isempty(OpParents{i}) & isempty(thisparents)
    check(i) = 0;
else
    
    % check evaluation of this factor
    %  This bit may go recursive if this factor depends on another.
    %  Recursion ends when an input factor is found (done_factor and check
    %   are already set for certain factors).
    [out, need, done_factor, check, OpParents, OpNeed, order,dep_factor] = ...
        i_CheckPtr(thisparents,OpPtrs,AllOpPtrs,LinkPtrs,done_factor,check,OpParents,OpNeed,order,ig_i,vectors);
    check(i) = out; 
    OpNeed{i} = need;
    
    % working out evaluation order?
    % check dependant factors
    if ~isempty(order)
        % find current position of this factor
        f = find(i==order);
        if ~isempty(f)
            mx = f;
            % find highest position of a dependant factor
            for j = 1:length(dep_factor)
                mx = max(mx,find(dep_factor(j)==order));
            end
            % place current factor after highest dependent
            order = order([1:f-1 f+1:mx f mx+1:end]);
        end
    end
end

%-------------------------------------------------------------------
function [out,need_ptrs,done_factor,check,OpParents,OpNeed,order,dep_factor] = ...
    i_CheckPtr(thisparents,OpPtrs,AllOpPtrs,LinkPtrs,done_factor,check,OpParents,OpNeed,order,ig_i,vectors)
%-------------------------------------------------------------------
% dep_factor is only used in i_DoFactor, to work out evaluation order.
% If the thing is a factor, we must get to this routine through i_DoFactor.
rem_i = [];
need_ptrs = [];
dep_factor = [];
% Check whether any factors are included in parents list.
%  Do evaluation check on factor, if not already done,
%  and if ok, remove parents of this factor from ptr list.

% This section done with all factors (AllOpPtrs) which are part of
% thisparents
NeedChecking= ismember(AllOpPtrs,thisparents);

for i = find(NeedChecking);
    % find all instances of AllOpPtrs(i) in thisparents
    f = findindex(AllOpPtrs ,thisparents,i);
    if ~isempty(f) %matched something
        dep_factor = [dep_factor i];
        if ~done_factor(i)
            % work out if this factor can be evaluated
            [done_factor,check,OpParents,OpNeed,order] = ...
                i_DoFactor(i,OpPtrs,AllOpPtrs,LinkPtrs,done_factor,check,OpParents,OpNeed,order,ig_i,vectors);
        end
        if check(i)
            % only remove parents if we can evaluate the thing
            rem = OpParents{i};  %any parents to remove?
            for j = 1:length(f) %may have several instances
                rem_i = [ rem_i [f(j):f(j)+length(rem)] ];  %relies on ptrs being returned the same by getptrs
            end
        end
    end
end
thisparents(rem_i) = [];   %get rid of parents

% Check whether remaining parent list contains any vectors
%  which are not dataset inputs.
% Compare against dataset inputs only (OpPtrs).
if ~isempty(vectors)
    vecs_reqd = intersect(thisparents,vectors);
    need_ptrs = setdiff(vecs_reqd,OpPtrs);
    out = isempty(need_ptrs);
else
    Got = []; 
    out = 1;
    thisparents= unique(thisparents);
    in = false(1,length(thisparents));
    for i = 1:length(thisparents)
         in(i)= isinport( thisparents(i).info );
    end
    need_ptrs= thisparents(in);
    out= ~any(in);
    
end
