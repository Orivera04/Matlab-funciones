function schema
% SCHEMA Defines class properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:43:14 $

% Get handles of associated packages and classes
hDeriveFromPackage = findpackage('ParameterEstimator');
hDeriveFromClass   = findclass(hDeriveFromPackage, 'Experiment');
hCreateInPackage   = findpackage('ParameterEstimator');

% Construct class
c = schema.class(hCreateInPackage, 'TransientExperiment', hDeriveFromClass);

% Input data
p = schema.prop(c, 'InputData', 'handle vector');
p.SetFunction = @LocalSetInputData;

% Output data
p = schema.prop(c, 'OutputData', 'handle vector');
p.SetFunction = @LocalSetOutputData;

% Initial state data
p = schema.prop(c, 'InitialStates', 'handle vector');
p.SetFunction = @LocalSetInitialStates;

% ----------------------------------------------------------------------------- %
function value = LocalSetInputData(this, value)
cls = 'ParameterEstimator.TransientData';
isValid = isa(value, cls);

if ~isempty(value) && ~isValid
  error( 'InputData must be set to a vector of objects of class %s %s.', ...
         cls, 'or be empty' )
end

isType  = all( strcmp( get(value, {'PortType'}), 'Inport' ) );

if isValid && ~isType
  error('InputData must be set to a vector of objects created for input ports.')
end

% ---------------------------------------------------------------------------- %
function value = LocalSetOutputData(this, value)
cls = 'ParameterEstimator.TransientData';
isValid = isa(value, cls);

if ~isempty(value) && ~isValid
  error( 'OutputData must be set to a vector of objects of class %s.', cls )
end

isType  = all( strcmp( get(value, {'PortType'}), 'Outport' ) | ...
               strcmp( get(value, {'PortType'}), 'Signal' ) );

if isValid && ~isType
  error('OutputData must be set to a vector of objects created for output ports.')
end

% ---------------------------------------------------------------------------- %
function value = LocalSetInitialStates(this, value)
cls = 'ParameterEstimator.StateData';
isValid = isa(value, cls);

if ~isempty(value) && ~isValid
  error( 'InitialStates must be set to a vector of objects of class %s %s.', ...
         cls, 'or be empty' )
end
