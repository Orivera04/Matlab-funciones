function schema
% SCHEMA Defines properties of the @estimation class

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc. 
% $Revision: 1.1.6.9 $ $Date: 2004/04/16 22:21:52 $

% Get handles of associated packages and classes
hCreateInPackage   = findpackage('ParameterEstimator');

% Construct class
c = schema.class(hCreateInPackage, 'Estimation');

p = schema.prop(c, 'Model', 'string');
p.AccessFlags.PublicSet =  'off';
p.SetFunction = @LocalSetModel;
p.Description = 'Simulink model name';

p = schema.prop(c, 'Experiments', 'handle vector');
p.SetFunction = @LocalSetExperiments;
p.Description = 'Estimation data';

p = schema.prop(c, 'Parameters', 'handle vector');
p.SetFunction = @LocalSetParameters;
p.Description = 'Estimated parameters';

p = schema.prop(c, 'States', 'MATLAB array');
p.SetFunction = @LocalSetStates;
p.Description = 'Model states';

p = schema.prop(c, 'SimOptions', 'handle');
p.Description = 'Simulation settings';

p = schema.prop(c, 'OptimOptions', 'handle');
p.Description = 'Optimizer settings';

p = schema.prop(c, 'EstimInfo', 'MATLAB array');
p.FactoryValue = struct( 'Cost',       [], 'Covariance', [], ...
                         'FCount',     [], 'FirstOrd',   [], ...
                         'Gradient',   [], 'Iteration',  [], ...
                         'Procedure',  [], 'StepSize',   [], ...
                         'Values',     [] );
p.AccessFlags.PublicSet = 'off';
p.Description = 'Estimation results';

p = schema.prop(c, 'EstimStatus', 'string');
p.SetFunction = @LocalManageStatus;
p.FactoryValue = 'idle';
p.AccessFlags.Serialize = 'off';
p.Visible = 'off';
p.Description = 'Optimization status [{idle}|run|stop|error]';

p = schema.prop(c, 'Simulators', 'handle vector');
p.AccessFlags.PublicSet = 'off';
p.AccessFlags.Serialize = 'off';
p.Visible = 'off';
p.Description = 'Objects to run simulations during estimation';

p = schema.prop(c, 'DataLoggingSettings', 'MATLAB array');
p.AccessFlags.PublicGet = 'off';
p.AccessFlags.PublicSet = 'off';
p.AccessFlags.Serialize = 'off';
p.Description = 'Initial data logging settings';

p = schema.prop(c, 'Description', 'string');
p.Description = 'User defined description';

p = schema.prop(c, 'UserData', 'MATLAB array');
p.Description = 'User defined data';

p = schema.prop(c, 'Version', 'double');
p.FactoryValue = 1.0;
p.AccessFlags.PublicSet = 'off';
p.Visible = 'off';
p.Description = 'Object version number';

% Events
schema.event(c, 'EstimUpdate');

% ----------------------------------------------------------------------------- %
function value = LocalSetModel(this, value)
if ~( exist( value, 'file') == 4 )
  error('Unable to locate the block diagram names ''%s''.', value);
end

% --------------------------------------------------------------------------- %
function value = LocalSetExperiments(this, value)
cls = 'ParameterEstimator.Experiment';
isValid = isa(value, cls);

if ~isempty(value) && ~isValid
  error( 'Experiments must be set to a vector of objects of class %s %s.', ...
         cls, 'or to empty' )
end

% ---------------------------------------------------------------------------- %
function value = LocalSetParameters(this, value)
cls = 'ParameterEstimator.Parameter';
isValid = isa(value, cls);

if ~isempty(value) && ~isValid
  error( 'Parameters must be set to a vector of objects of class %s %s.', ...
         cls, 'or to empty' )
end

% ---------------------------------------------------------------------------- %
function value = LocalSetStates(this, value)
cls = 'ParameterEstimator.State';
isValid = isa(value, cls);

if ~isempty(value) && ~isValid
  error( 'Parameters must be set to a vector of objects of class %s %s.', ...
         cls, 'or to empty' )
end

% --------------------------------------------------------------------------- %
function value = LocalManageStatus(this, value)
% Manages state transitions
switch value
case 'run'
  % Save data logging settings
  logSave(this)
  
  % Initialization tasks
  for ct = 1:length(this.Simulators)
    estimSetup(this.Simulators(ct))
  end
  
case 'idle'
  if any( strcmp( this.EstimStatus, {'run','stop'} ) )
    % Normal termination tasks
    for ct = 1:length(this.Simulators)
      estimCleanup(this.Simulators(ct))
    end
    
    % Restore data logging settings
    logRestore(this)
  end
  
case 'error'
  % Clean up after error
  logRestore(this)
end
