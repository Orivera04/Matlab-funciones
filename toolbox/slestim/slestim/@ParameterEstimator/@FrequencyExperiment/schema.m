function schema
% SCHEMA Defines class properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:42:34 $

% Get handles of associated packages and classes
hDeriveFromPackage = findpackage('ParameterEstimator');
hDeriveFromClass   = findclass(hDeriveFromPackage, 'Experiment');
hCreateInPackage   = findpackage('ParameterEstimator');

% Construct class
c = schema.class(hCreateInPackage, 'FrequencyExperiment', hDeriveFromClass);

% Input data
p = schema.prop(c, 'InputData', 'handle vector');
p.SetFunction = @LocalSetInputData;

% Output data
p = schema.prop(c, 'OutputData', 'handle vector');
p.SetFunction = @LocalSetOutputData;

% State data
p = schema.prop(c, 'StateData', 'handle vector');
p.SetFunction = @LocalSetStateData;

% Operating point
p = schema.prop(c, 'OperatingPoint', 'handle');
p.SetFunction = @LocalSetOperatingPoint;

% ----------------------------------------------------------------------------- %
function value = LocalSetInputData(this, value)
cls = 'ParameterEstimator.FrequencyData';
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
cls = 'ParameterEstimator.FrequencyData';
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
function value = LocalSetStateData(this, value)
cls = 'ParameterEstimator.StateData';
isValid = isa(value, cls);

if ~isempty(value) && ~isValid
  error( 'StateData must be set to a vector of objects of class %s %s.', ...
         cls, 'or be empty' )
end

% ---------------------------------------------------------------------------- %
function value = LocalSetOperatingPoint(this, value)
cls = 'opcond.OperatingPoint';
isValid = isa(value, cls);

if ~isempty(value) && ~isValid
  error( 'OperatingPoint must be set to an object of class %s %s.', ...
         cls, 'or be empty' )
end
