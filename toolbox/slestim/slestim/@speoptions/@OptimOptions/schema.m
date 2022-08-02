function schema
% SCHEMA Optimization options for SPE projects.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/19 01:33:34 $

% Get handles of associated packages
hCreateInPackage = findpackage('speoptions');

% Construct class
c = schema.class(hCreateInPackage, 'OptimOptions');

% Add new enumeration type
if isempty( findtype('speoptions_Algorithm') )
  schema.EnumType( 'speoptions_Algorithm', ...
                   {'fmincon', 'lsqnonlin', 'patternsearch', 'fminsearch'} );
end
if isempty( findtype('speoptions_Display') )
  schema.EnumType( 'speoptions_Display', {'off', 'iter', 'notify', 'final'} );
end
if isempty( findtype('speoptions_Gradient') )
  schema.EnumType( 'speoptions_Gradient', {'basic', 'refined'} );
end
if isempty( findtype('speoptions_CostType') )
  schema.EnumType( 'speoptions_CostType', {'SSE', 'SAE'} );
end

% Algorithm
p = schema.prop(c, 'Algorithm', 'speoptions_Algorithm');
p.FactoryValue = 'lsqnonlin';

% Cost type
p = schema.prop(c, 'CostType', 'speoptions_CostType');
p.FactoryValue = 'SSE';

% Display
p = schema.prop(c, 'Display', 'speoptions_Display');
p.FactoryValue = 'off';

% Maximum gradient step size
p = schema.prop(c, 'DiffMaxChange', 'double');
p.FactoryValue = 1.0e-1;
p.SetFunction = @LocalSetDiffChange;

% Minimum gradient step size
p = schema.prop(c, 'DiffMinChange', 'double');
p.FactoryValue = 1.0e-8;
p.SetFunction = @LocalSetDiffChange;

% Gradient type
p = schema.prop(c, 'GradientType', 'speoptions_Gradient');
p.FactoryValue = 'basic';

% Large scale
p = schema.prop(c, 'LargeScale', 'on/off');
p.FactoryValue = 'on';

% Max function evaluations
p = schema.prop(c, 'MaxFunEvals', 'double');
p.FactoryValue = 400;
p.SetFunction = @LocalSetMaxFunEvals;

% Max iterations
p = schema.prop(c, 'MaxIter', 'double');
p.FactoryValue = 100;
p.SetFunction = @LocalSetMaxIter;

% Robust cost flag
p = schema.prop(c, 'RobustCost', 'on/off');
p.FactoryValue = 'off';

% Search Method (GADS only)
p = schema.prop(c, 'SearchMethod', 'MATLAB array');

% Constraint tolerance
p = schema.prop(c, 'TolCon', 'double');
p.FactoryValue = 1.0e-06;
p.SetFunction = @LocalSetTol;

% Objective tolerance
p = schema.prop(c, 'TolFun', 'double');
p.FactoryValue = 1.0e-06;
p.SetFunction = @LocalSetTol;

% Optimal X tolerance
p = schema.prop(c, 'TolX', 'double');
p.FactoryValue = 1.0e-06;
p.SetFunction = @LocalSetTol;

% Version
p = schema.prop(c, 'Version', 'double');
p.FactoryValue = 1;
p.AccessFlags.PublicGet = 'off';
p.AccessFlags.PublicSet = 'off';

% --------------------------------------------------------------------------
function value = LocalSetMaxIter(this, value)
if ~isreal(value) || value<1 || value~=round(value)
  error('MaxIter must be set to a positive integer.')
end

function value = LocalSetMaxFunEvals(this, value)
if ~isreal(value) || value<1 || value~=round(value)
  error('MaxFunEvals must be set to a positive integer.')
end

function value = LocalSetTol(this, value)
if ~isreal(value) || value<0
  error('Tolerance must be set to a positive real number.')
end

function value = LocalSetDiffChange(this, value)
if ~isreal(value) || value<0
  error('Change in variable must be set to a positive real number.')
end
