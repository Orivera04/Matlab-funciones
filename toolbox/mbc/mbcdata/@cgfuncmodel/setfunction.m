function [obj, ok, msg] = setfunction(obj, sFunc)
%SETFUNCTION Set a new function string into the model
%
%  [OBJ, OK, MSG] = SETFUNCTION(OBJ, STR) sets a new string as the function
%  in OBJ.  The function is tested and only accepted if it can be correctly
%  evaluated using vectors.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.8.4 $    $Date: 2004/04/04 03:25:52 $ 

%First of all, check to see if the new_value is a scalar double.
if ~ischar(sFunc)
    error('mbc:cgfuncmodel:InvalidArgument', 'Function must be a function string.');
end

ok = true;
msg = '';

% Create the inline function
try
    hFunc = inline(sFunc);
catch
    ok = false;
    msg = 'Unable to parse function string';
    return    
end
hFuncV = vectorize(hFunc);

if isempty(hFunc)
    n = 0;s='';units={};
else
    s = argnames(hFunc);
    n = length(s);
    u = cell(n+1,1); % first element is output units
    r = repmat([0;100],1,n);
end

% Test the function to see if it works ok
if n==0
    ok = false;
    msg = 'Unable to parse function string: it appears to have no inputs.';
    return
end

evalIn = (1:10)';
evtest = repmat({evalIn}, 1, n);
try
    evalOut = hFuncV(evtest{:});    
catch
    ok = false;
    msg = ['Unable to evaluate function.  Function strings must use valid MATLAB ', ...
            'syntax and be capable of being evaluated using vectors as inputs.']; 
    return
end

% we must return an nx1 vector
if (length(evalOut)~=length(evalIn) | size(evalOut, 2) ~= 1)
    ok = false;
    msg = ['Function must return a column vector with the same number of elements as the input vector.'];
    return;
end


% Set data into model object
obj.func = hFunc;
obj.funcv = hFuncV;
obj = setsymbols(obj,s);
obj = setunits(obj,u);
obj = setranges(obj,r);
