function obj = addLinearConstraint(obj, sLabel, a, b)
%ADDLINEARCONSTRAINT Add an linear constraint to the optimization.
%   OPTIONS = ADDLINEARCONSTRAINT(OPTIONS, LABEL, A, B) adds a placeholder
%   for a linear constraint to the optimization.  The string LABEL will be
%   used to refer to the constraint in the CAGE GUI.  Linear constraints
%   can be written in the form:
%  
%     A(1)X(1) + A(2)X(2) + ... + A(n)X(n) <= b 
%
%   where X(i) is the i-th free variable, A is a vector of coefficients and
%   b is a scalar bound. 
%  
%   Example:
%     % Add SPK and EGR variables to an optimization
%     opt = addFreeVariable(opt, 'SPK');
%     opt = addFreeVariable(opt, 'EGR');
%     % Add a linear constraint such that 3*SPK - 2*EGR <= 30
%     opt = addLinearConstraint(opt, 'newCon', [3 -2], 30);
%
%   See also CGOPTIMOPTIONS/GETLINEARCONSTRAINTS,
%            CGOPTIMOPTIONS/ADDMODELCONSTRAINT,
%            CGOPTIMOPTIONS/SETCONSTRAINTSMODE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:52:33 $ 

% Some sanity checks
if nargin < 4
    error('mbc:cgoptimoptions:InvalidArgument', 'ADDLINEARCONSTRAINT requires four inputs.');
end

% Check input types
[ok, msg] = i_CheckInputs(obj, {sLabel, a, b});
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
    cons(N+1).typestr = 'linear';
    cons(N+1).pars = {a, b};
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
elseif ~isnumeric(in{2}) || ~isnumeric(in{3})
    msg = 'A and b must be numeric.'; 
elseif ~isreal(in{2}) || ~isreal(in{3})
    msg = 'A and b must be real numbers.';
elseif ~all(size(in{2})==[1 nFree]) 
    msg = 'For linear constraints, A must be a (1-by-NFreeVar) vector.';
elseif  numel(in{3}) ~= 1
    msg = 'For linear constraints, b must be a scalar real number.';  
else
    ok = true;
end