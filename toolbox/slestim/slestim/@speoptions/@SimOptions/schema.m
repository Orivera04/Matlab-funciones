function schema
% SCHEMA Simulation options for SPE projects.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:43:56 $

% Get handles of associated packages
hCreateInPackage = findpackage('speoptions');

% Construct class
c = schema.class(hCreateInPackage, 'SimOptions');

% Add new enumeration type
if isempty( findtype('speoptions_ODESolver') )
  schema.EnumType( 'speoptions_ODESolver', ...
                   { 'VariableStepDiscrete', 'ode45', 'ode23', ...
                     'ode113', 'ode15s', 'ode23s', 'ode23t', 'ode23tb', ...
                     'FixedStepDiscrete', 'ode5', 'ode4', 'ode3', ...
                     'ode2', 'ode1' } );
end
          
p = schema.prop(c, 'AbsTol', 'MATLAB array');
p.FactoryValue = 'auto';
p.SetFunction = @LocalSetValue;

p = schema.prop(c, 'FixedStep', 'MATLAB array');
p.FactoryValue = 'auto';
p.SetFunction = @LocalSetValue;

p = schema.prop(c, 'InitialStep', 'MATLAB array');
p.FactoryValue = 'auto';
p.SetFunction = @LocalSetValue;

p = schema.prop(c, 'MaxStep', 'MATLAB array');
p.FactoryValue = 'auto';
p.SetFunction = @LocalSetValue;

p = schema.prop(c, 'MinStep', 'MATLAB array');
p.FactoryValue = 'auto';
p.SetFunction = @LocalSetValue;

p = schema.prop(c, 'RelTol', 'MATLAB array');
p.FactoryValue = 1e-3;
p.SetFunction = @LocalSetValue;

p = schema.prop(c, 'Solver', 'speoptions_ODESolver');
p.FactoryValue = 'ode45';

p = schema.prop(c, 'ZeroCross', 'on/off');
p.FactoryValue = 'on';

p = schema.prop(c, 'StartTime', 'MATLAB array');
p.FactoryValue = 'auto';  % inherited from model
p.SetFunction = @LocalSetTime;
p.Description = 'Start time for simulation';

p = schema.prop(c, 'StopTime', 'MATLAB array');
p.FactoryValue = 'auto';  % inherited from model
p.SetFunction = @LocalSetTime;
p.Description = 'Stop time for simulation';

% Version
p = schema.prop(c, 'Version', 'double');
p.FactoryValue = 1;
p.AccessFlags.PublicGet = 'off';
p.AccessFlags.PublicSet = 'off';

% --------------------------------------------------------------------------
function value = LocalSetValue(this, value)
isAuto = ischar(value) && strcmp(value, 'auto');
isReal = isnumeric(value) && isreal(value) && (value>0);
if ~isAuto && ~isReal
  error('Value must be set to a positive real number or to ''auto''.')
end

% --------------------------------------------------------------------------
function value = LocalSetTime(this, value)
isAuto = ischar(value) && strcmp(value, 'auto');
isReal = isnumeric(value) && isreal(value) && (value>=0);
if ~isAuto && ~isReal
  error('Time must be set to a non-negative real number or to ''auto''.')
end
