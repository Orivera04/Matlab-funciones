function P = RemoveFactor(P,ind,opt,doEval);
% P = RemoveFactor(P,indexlist) removes the factors in indexlist from P.
% P = RemoveFactor(P,ptrlist) removes the factors in ptrlist from P.
%       Only the unique remaining rows are returned, so P may be shorter than the original.
% P = RemoveFactor(...,'hold') returns all rows, regarless of any repeated rows.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 06:52:12 $

if nargin<3, opt = ''; end
if nargin<4, doEval=true; end
    
if isa(ind,'xregpointer')
    ind = ind(find(isvalid(ind)));
    rem_i = ismember(double(P.ptrlist),double(ind));
elseif isa(ind,'double')
    if any(~ismember(ind,1:length(P.ptrlist)))
        error('cgoppoint::removefactor: bad index into factors.');
    else
        rem_i = ind;
    end
end

if isempty(rem_i)
    return
end

% Find any group members being removed
groupno = P.group(rem_i);
groupno = setdiff(groupno,0);

% check created_flag - do we need to clear up this column?
f = find(P.created_flag(rem_i)==1);
if ~isempty(f)
    % any factors linked to these ptrs?
    f2 = find(ismember(double(P.linkptrlist),double(P.ptrlist(rem_i(f)))));
    P.linkptrlist(f2) = xregpointer;
    % free ptrs
    freeptr(P.ptrlist(rem_i(f)));
end

% Check rules - remove any rules applying to factors which no longer exist
if ~isempty(P.rules)
%   f = find(ismember([P.rules.fact_i],rem_i));
f = [];
else
   f = [];
end
if ~isempty(f)
    P.rules(f) = [];
end


% remove column
if ~isempty(P.data)
    P.data(:,rem_i) = [];
end
P.ptrlist(rem_i) = [];
P.units(rem_i) = [];
P.orig_name(rem_i) = [];
P.factor_type(rem_i) = [];
P.linkptrlist(rem_i) = [];
P.overwrite(rem_i) = [];
P.group(rem_i) = [];
P.grid_flag(rem_i) = [];
P.range(rem_i) = [];
P.constant(rem_i) = [];
P.tolerance(rem_i) = [];
P.created_flag(rem_i) = [];

% Check removed groups for number of members.
%  Less than 2 members - disband group.
for i = 1:length(groupno)
    f = find(P.group==groupno(i));
    if length(f)<2
        f2 = find(P.group>groupno(i));
        P.group(f2) = P.group(f2) - 1;
        P.group(f) = 0;
    end
end

if ~strcmp(opt,'hold')
    P = i_GetNewBlocklen(P);    
    [Pdata,i] = unique(P.data,'rows');
    i = sort(i);
    P.data = P.data(i,:);
end

% Addition - 3/x/01. 
% We should perform a regridding and evaluating at this point. 
% This will take longer, but ensures that the dataset is obvious 
P = range_grid(P);
if doEval
    P = eval_fill(P);
end

%------------------------------------------------------------------------
function P = i_GetNewBlocklen(P)
%------------------------------------------------------------------------

thisgrid = get(P, 'grid_flag');
if ~isempty(thisgrid)
    ind = find(thisgrid == 7);
    if any(ind)
        data = P.data(1:P.blocklen, ind);
        data = unique(data, 'rows');
        P.blocklen = size(data, 1);
    end
end