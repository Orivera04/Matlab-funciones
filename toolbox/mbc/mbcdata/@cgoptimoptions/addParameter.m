function obj = addParameter(obj, sLabel, sType, Value)
%ADDPARAMETER Add a parameter to the optimization.
%   OPTIONS = ADDPARAMETER(OPTIONS, LABEL, TYPESTR, VALUE) adds a parameter
%   to the optimization.  The string LABEL will be used to refer to the
%   parameter. The string TYPESTR takes one of 'number', 'list' or
%   'boolean'.  A default value for the parameter must be supplied in
%   VALUE.  The form of VALUE must be one of the following:
% 
%       TYPESTR  |                        VALUE
%     -----------+------------------------------------------------------
%     'number'   |  Scalar, real number
%     'list'     |  Cell array of strings, one for each list member
%     'boolean'  |  true or false        
%      
%   See also CGOPTIMOPTIONS/GETPARAMETERS, CGOPTIMSTORE/GETPARAM.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.2 $    $Date: 2004/02/09 06:52:37 $

% Allow the hidden OM mode 
if nargin == 2 & isa(sLabel, 'xregoptmgr')
    obj.parameters = sLabel;
    return
end

if nargin < 4
    error('mbc:cgoptimoptions:InvalidArgument', 'ADDPARAMETER requires four inputs.');
end

% Check input types
[ok, msg] = i_CheckInputs(obj, {sLabel, sType, Value});
if ~ok
    error('mbc:cgoptimoptions:InvalidArgument', msg);
end

% Check that the label is unique to other constraints
ok = checklabel(obj, sLabel);
if ~ok
    error('mbc:cgoptimoptions:NonUniqueLabel', 'Parameter labels must be unique.');
end


pars = obj.parameters;
N = length(pars);
pars(N+1).label = sLabel;
pars(N+1).typestr = sType;
pars(N+1).value = Value;
obj.parameters = pars;


%----------------------------------------------------------------------
function [ok, msg] = i_CheckInputs(obj,in)
%----------------------------------------------------------------------

ok = false; msg = '';

if ~ischar(in{1}) || isempty(in{1})
    msg = 'The label must be a non-empty string.';
elseif ~isvarname( in{1} )
    msg = 'The label must be a valid MATLAB variable name.'; 
elseif ~ischar(in{2}) || isempty(strmatch(in{2}, {'number', 'list', 'boolean'}, 'exact'))
    msg = 'The parameter type must be ''number'', ''list'' or ''boolean''.'; 
elseif strcmp(in{2}, 'number') && (~isnumeric(in{3}) || ~isreal(in{3}) || numel(in{3}) ~= 1)
    msg = 'For parameters of type ''number'', VALUE must be a real scalar.';
elseif strcmp(in{2}, 'list') && (~iscell(in{3}) || ~all(cellfun('isclass', in{3}, 'char')))
    msg = 'For parameters of type ''list'', VALUE must be a cell array of strings.';
elseif strcmp(in{2}, 'boolean') && ~islogical(in{3})
    msg = 'For parameters of type ''boolean'', VALUE must be true or false.';   
else
   ok = true;
end