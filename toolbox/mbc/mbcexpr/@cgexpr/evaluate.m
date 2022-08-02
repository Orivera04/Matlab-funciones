function Y = evaluate(obj, sQuant)
%EVALUATE Evaluate expression
%
%  Y = EVALUATE(OBJ, QUANTITY) evaluates the expression OBJ.  The inports
%  to OBJ will be checked to make sure that they all contain either vectors
%  of the same length or scalars.   QUANTITY is an optional paramater to
%  specify which aspect of the expression to evaluate and may be one of
%  'value', 'pev' or 'constraint'.  If it is not specified then 'value' is
%  assumed.
%
%  See also CGEXPR/EVALUATEGRID, CGEXPR/EVALUATESEQUENTIAL.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.1 $    $Date: 2004/02/09 07:08:32 $ 

% Get evaluation function flag
if nargin<2
    nQuant = 1;
else
    nQuant = strmatch(lower(sQuant), {'value', 'pev', 'constraint'});
    if isempty(nQuant)
        error('mbc:cgexpr:InvalidArgument', 'Quantity must be one of ''value'', ''pev'' or ''constraint''.');
    end
end

if isinport(obj)
    % Special case: inports don't have inputs
    nVectLength = numel(getvalue(obj));
else
    % Check all inports contain values with sizes that agree.
    pInputs = getinports(obj);
    nVectLength = 1;
    for n = 1:length(pInputs)
        dValue = pInputs(n).getvalue;
        nSize = size(dValue);
        nElements = numel(dValue);
        if (prod(nSize) ~= nElements)
            error('mbc:cgexpr:InvalidState', 'Inports must contain only vectors and scalars');
        elseif nElements>1
            if (nVectLength == 1)
                nVectLength = nElements;
            else
                if nVectLength ~= nElements
                    error('mbc:cgexpr:InvalidState', 'Inports must contain vectors that are the same length');
                end
            end
        end
    end
end
Y = zeros(nVectLength,1);
if nQuant==1
    Y(:) = i_eval(obj);
elseif nQuant==2
    Y(:) = peveval(obj);
else
    Y(:) = ceval(obj);
end