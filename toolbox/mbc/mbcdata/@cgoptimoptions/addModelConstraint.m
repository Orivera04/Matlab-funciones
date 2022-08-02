function obj = addModelConstraint(obj, sLabel, boundtype, bound)
%ADDMODELCONSTRAINT Add a model constraint to the optimization.
%   OPTIONS = ADDMODELCONSTRAINT(OPTIONS, LABEL, BOUNDTYPE, BOUND) adds a
%   placeholder for a model constraint to the optimization.  The string
%   LABEL will be used to refer to the constraint in the CAGE GUI.
%   BOUNDTYPE can either be set to the strings 'greaterthan' or 'lessthan'.
%   BOUND must be a scalar real.  If BOUNDTYPE = 'greaterthan', the model
%   constraint takes the following form:
%              
%   CAGE model >= BOUND
%              
%   Similarily, if BOUNDTYPE = 'lessthan', the model constraint takes the
%   form:
%
%   CAGE model <= BOUND
%
%   Example:
%     An optimization requires a constraint where a user-defined function
%     must be less than 500. The following code line adds a placeholder for
%     this constraint that is labelled 'mycon':
%
%     opt = addModelConstraint(opt, 'mycon', 'lessthan', 500);
%
%   See also CGOPTIMOPTIONS/GETMODELCONSTRAINTS,
%            CGOPTIMOPTIONS/ADDLINEARCONSTRAINT,
%            CGOPTIMOPTIONS/SETCONSTRAINTSMODE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:52:34 $ 

% Some sanity checks
if nargin < 4
    error('mbc:cgoptimoptions:InvalidArgument', 'ADDMODELCONSTRAINT requires four inputs.');
end

% Check input types
[ok, msg] = i_CheckInputs(obj, {sLabel, boundtype, bound});
if ~ok
    error('mbc:cgoptimoptions:InvalidArgument', msg);
end

% Check that the label is unique to other constraints
ok = checklabel(obj, sLabel);
if ~ok
    error('mbc:cgoptimoptions:NonUniqueLabel', 'Constraint labels must be unique.');
end

conmode = getConstraintsMode(obj);  
if ~strcmp(conmode, 'any')
    cons = obj.constraints.details;
    N = length(cons);
    cons(N+1).label = sLabel;
    cons(N+1).typestr = 'model';
    switch boundtype
        case {'gthan', 'greaterthan'}
            flag = 1;
        case {'lthan', 'lessthan'}
            flag = 0;
    end
    cons(N+1).pars = {bound, flag};
    obj.constraints.details = cons;
else
    warning('mbc:cgoptimoptions:InvalidState', ...
        'Cannot add a constraint when constraint mode is set to ''any''.');
end



%----------------------------------------------------------------------
function [ok, msg] = i_CheckInputs(obj,in)
%----------------------------------------------------------------------
ok = false; msg = '';
nFree = length(obj.freevariables.labels);

if ~ischar(in{1}) || isempty(in{1})
    msg = 'The label must be a non-empty string.';
elseif ~ischar(in{2})
    msg = 'The bound type must be a string.';
elseif isempty(strmatch(in{2}, {'gthan', 'lthan', 'greaterthan', 'lessthan'}, 'exact'))
    msg = 'The bound type must be ''greaterthan'' or ''lessthan''.';    
elseif  numel(in{3}) ~= 1
    msg = 'The model bound must be a scalar real number.';
else
    ok = true;
end