function out = i_eval(P,thing,opt)
% out = i_eval(P,ptr)
% out = i_eval(P,index)
%   Use i_eval to evaluate a single expression or factor.
%   Note: no validity checking is performed in i_eval.  Use check_eval 
%         to find whether the expression may be evaluated using this dataset.
%
% out = i_eval(P,modptr,'pev') evaluate predicted error of model
%
%  See also: check_eval, eval_fill

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.4.3 $  $Date: 2004/02/09 06:51:55 $

if nargin<3
    opt = '';
end
if ~length(P.ptrlist) || size(P.data,1)==0
    out = [];
    return
end

thisptr = xregpointer;
fact_i = [];
if isnumeric(thing)
    if length(thing)~=1 || thing>length(P.ptrlist)
        error('mbc:cgoppoint:InvalidArgument', 'Index exceeds length of factor list.');
    end
    if (strcmp(opt,'eval_fill') || strcmp(opt,'trueeval')) && isvalid(P.ptrlist(thing))
        fact_i = thing;
        thisptr = P.ptrlist(fact_i);
        thing = thisptr.info;
    else
        out = P.data(:,thing);
        return
    end
end

if ~isempty(fact_i)
    % this is ok.
elseif isa(thing,'xregpointer') && isvalid(thing) && isa(thing.info,'cgexpr')
    thisptr = thing;
elseif isa(thing,'cgexpr')
    error('mbc:cgoppoint:InvalidArgument', 'Need an xregpointer to an expression.');
else
    error('mbc:cgoppoint:InvalidArgument', 'Need an xregpointer to an expression or a factor index.');
end

use_i = find(P.factor_type);

% Overwrite: inputs and outputs if overwrite flag is set.
overwrite = get(P,'overwrite');
overwrite(P.factor_type==0) = 0;

val_check_i = false(1,length(use_i));

OpPtrs = get(P,'ptrlist');
LinkPtrs = get(P,'linkptrlist');
OpPtrs = OpPtrs(use_i);
FactorType = get(P, 'factor_type');
FactorType = FactorType(use_i);

% If we're doing an eval_fill, do not replace
%  the expression being evaluated if it is in the dataset.
% (Need the original equation/model to re-evaluate)
% If not in eval_fill, just replace all expressions with the
%  relevant column of data.
if (strcmp(opt,'eval_fill') || strcmp(opt,'trueeval') || strcmp(opt,'pev')) && ...
        ~isempty(fact_i) && ismember(fact_i,use_i)
    f = (fact_i==use_i);
    % subtlety: if the factor is a value, replace regardless.
    val_check_i(f) = true;
    % If overwrite flag not set, may be able to replace
    if ~strcmp(opt,'trueeval') && ~strcmp(opt,'pev')
        val_check_i(f) = ~overwrite(use_i(f));
        % Is this factor linked? Replace its pointer with the link and evaluate that.
        if isvalid(LinkPtrs(use_i(f)))
            thisptr = LinkPtrs(use_i(f));
        end
    end
end

Replace_Values = isvalid(OpPtrs);
Values_OLD = cell(size(OpPtrs));
Values_NEW = Values_OLD;
Values_OLD(Replace_Values) = infoarray(OpPtrs(Replace_Values));

if any(Replace_Values)
    v = cgvalue;
    for n = 1:length(OpPtrs)    %replace all factors, regardless of whether a value
        % assume we've checked we can evaluate this object.
        if Replace_Values(n)
            if (~val_check_i(n) || isa(Values_OLD{n},'cgvariable')) && FactorType(n) ~= 3
                % Addition - No longer set the value of ptrs of hidden columns
                % (factor_type = 3)
                Values_NEW{n} = setvalue(v, P.data(:, n));
            else
                Replace_Values(n) = false;
            end
        end
    end
end

if any(Replace_Values)
    passign(OpPtrs(Replace_Values), Values_NEW(Replace_Values));
end

% Now, we should finally be able to eval thing. Do it inside a try catch just in case
try
    if strcmp(opt,'pev')
        out = i_eval(thisptr.info, 'pev');        
    else
        out = i_eval(thisptr.info);
    end
catch
    % Something has gone wrong, we'll return zeros as the result.
    out = repmat(nan,size(P.data,1),1);
end   

%Now, we need to set the old value objects back.
if any(Replace_Values)
    passign(OpPtrs(Replace_Values), Values_OLD(Replace_Values));
end

% Catch anything that hasn't been evaluated properly and return correct
% size output to avoid errors in other routines
if size(out,1)~=size(P.data,1)
    out = zeros(size(P.data,1),1);
end
