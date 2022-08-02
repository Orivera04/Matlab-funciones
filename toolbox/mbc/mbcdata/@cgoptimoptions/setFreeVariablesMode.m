function obj = setFreeVariablesMode(obj, sMode)
%SETFREEVARIABLESMODE Set how the optimization free variables are used.
%   OPTIONS = SETFREEVARIABLESMODE(OPTIONS, MODESTR) sets the mode that
%   governs how the user will be allowed to set up free variables for the
%   optimization in the CAGE GUI.  When MODESTR = 'any', the user will be
%   allowed to add any number of free variables.   When MODESTR = 'fixed',
%   the user will only be allowed to use the number of free variables that
%   are added by the user-defined optimization function.
%
%   See also CGOPTIMOPTIONS/GETFREEVARIABLESMODE,
%            CGOPTIMOPTIONS/ADDFREEVARIABLE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.5.6.1 $    $Date: 2004/02/09 06:54:15 $

if nargin < 2
    error('mbc:cgoptimoptions:InvalidArgument', 'SETFREEVARIABLESMODE requires two inputs.');
end

% Check input types
[ok, msg] = i_CheckInputs(obj, {sMode});
if ~ok
    error('mbc:cgoptimoptions:InvalidArgument', msg);
end

% Linear constraints (LCs) assume a fixed number of free variables. If the user
% has set up any LCs then the user cannot be allowed to set the free
% variable status to 'any', as this changes the number of free variables.
mylincon = getLinearConstraints(obj);
if strcmp(sMode, 'any') && ~isempty(mylincon) 
    error('mbc:cgoptimoptions:InvalidState', ...
        'Cannot reset free variable mode while there are linear constraints already set up.');
end
    
if strcmp(sMode, 'any')
    % All existing free variables must be cleared
    obj.freevariables.labels = [];
elseif strcmp(sMode, 'fixed') && isempty(obj.freevariables.labels)
    % Optimization must have at least one free variable label
    obj.freevariables.labels{1} = 'FreeVariable1';
    obj.freevariables.firstcall = 1;
end
obj.freevariables.mode = sMode;




%----------------------------------------------------------------------
function [ok, msg] = i_CheckInputs(obj,in)
%----------------------------------------------------------------------

ok = false; msg = '';

if ~ischar(in{1}) || isempty(in{1}) || isempty(strmatch(in{1}, {'any', 'fixed'}, 'exact'))
    msg = 'The mode must be either ''any'' or ''fixed''.';
else
   ok = true;
end