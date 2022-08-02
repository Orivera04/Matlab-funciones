function [op,fact_i,mess] = AddExpr(op,ptrs,doEval)
%ADDEXPR Add a new cgexpr object to the oppoint
% op = AddExpr(op,ptrs) adds expressions given by ptrs.
%    Checking performed on ptr and expression types; special cases
%    (eg subfeatures) handled.
% [op,index,mess] returns indices of added factors.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 06:51:01 $

mess = '';
fact_i = [];

if nargin<3
    doEval= true;
end

% check for subfeatures etc.
[ptrs,linkptrs,names,units,cr_flag,value_ind] = ExpandPtrs(op,ptrs);
orig_names = names;
orig_names(~isvalid(linkptrs)) = {[]};

% filter out any ptrs already in dataset
% also filter out any invalid ptrs.
keep = find(~ismember(double(ptrs),double(op.ptrlist)) & reshape(isvalid(ptrs),size(ptrs)));
ptrs = ptrs(keep);
linkptrs = linkptrs(keep);
orig_names = orig_names(keep);
cr_flag = cr_flag(keep);
value_ind = value_ind(keep);
units = units(keep);

% values become inputs, and overwrite.
overwrite = value_ind;
ftype = 2-(value_ind);
% default to constant.
grid_flag = zeros(1,length(ptrs));

nptrs= length(ptrs);
evalptrs= null(xregpointer, 1, length(ptrs));
% Get some data for each new ptr
for i = 1:nptrs
    % For linked ptrs (ie features) work out correct evalptr
    if isvalid(linkptrs(i))
        evalptr = linkptrs(i);
    else
        evalptr = ptrs(i);
    end
    evalptrs(i)= evalptr;
    % Check evaluation
end

if nptrs>0
    % Do all checks at once
    ch = check_eval(op,evalptrs(~value_ind) );
    ch = logical(ch);
    ToEvalIdx = find(~value_ind & ch);
    npts = get(op ,'numpoints');
    data = zeros(npts, nptrs);
    constant = zeros(1,  nptrs);
    if ~isempty(ToEvalIdx) && (npts~=0)
        for n = ToEvalIdx
            data(:, n) = i_eval(op,ptrs(n));
        end
    end
    
    % Try to set values to set point
    ToValInd = find(value_ind);
    if ~isempty(ToValInd)
        for n = ToValInd
            constant(n) = ptrs(n).getnomvalue;
            data(:, n) = constant(n);
        end
    end
    

    % now add the factors and set various flags
    of = length(op.ptrlist);
    op = addfactor(op,ptrs,...
        'factor_type',ftype,'tolerance',0,'data',data,...
        'grid_flag',grid_flag,'overwrite',overwrite,...
        'linkptr',linkptrs,'orig_name',orig_names,...
        'created_flag',cr_flag,'units',units, ...
        'constant', constant);
    nf = length(op.ptrlist);
    fact_i = of+1:nf;
    % Sort out groups
    op = CheckGroup(op,doEval);

end
