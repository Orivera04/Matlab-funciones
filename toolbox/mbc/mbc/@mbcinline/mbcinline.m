function obj = mbcinline(varargin)
% MBCINLINE
%
% Faster inline object for function calls otherwise pass up to ordinary
% inline object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.1 $ 

% Construct default object
obj.funcHandle = [];
obj.version    = 1.0;

if nargin > 0
    % Check if expression could be treated as a function handle
    [OK, func] = i_isSingleFunction(varargin{1});
    if OK
        try
            obj.funcHandle = str2func(func);
        end
    end
end

% Construct inline object
inlineObj = inline(varargin{:});

obj = class(obj, 'mbcinline', inlineObj);
        
    
% -------------------------------------------------------------------------
% Internal function to determine if expr is a call of the form
% myFunction(var1, var2, var3, ...) which could be feval'ed rather than
% eval'ed
% -------------------------------------------------------------------------
function [OK, func] = i_isSingleFunction(expr)

% Initialse the outputs
OK = 0;
func = '';

return

% 5/2/03 JLM
% The code below doesn't currently pick out appropriate inline forms to
% speed up. It thinks functions of the form myfunc(var1, var1) and
% myfunc(var1, 1) can be evaluated as function handles when then cannot. To
% deal with these types adequately we need either more checks or more info
% in the mbcinline code. This cannot be done just before release so there
% is an active geck to upgrade this object. In the meantime the early
% return above will ensure that mbcinline works in all cases, if a lottle
% slower than expected.

% Strip off everything up to the first left parenthesis
leftParenIndex = find(expr == '(');
% Only continue if one left parenthesis is found
if length(leftParenIndex) ~= 1
    return
end

% Is everything to the left of the parenthesis a function name?
func = xregdeblank(expr(1:leftParenIndex-1));
if isempty(func) || ~isvarname(func)
    return
end

% Finally check that everything left in the expr is
% alpha-numeric, underscore, comma or whitespace
c = expr(leftParenIndex+1:end);
OK = isletter(c) | isspace(c) | (c >= '0' & c <= '9') | c == '_' | c == ')' | c == ',';