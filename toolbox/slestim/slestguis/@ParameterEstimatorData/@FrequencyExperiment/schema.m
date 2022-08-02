function schema
% SCHEMA Define class properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:37:39 $

% Get handles of associated packages and classes
hCreateInPackage = findpackage('ParameterEstimatorData');

% Construct class
c = schema.class(hCreateInPackage, 'FrequencyExperiment');

% Proxy to ParameterEstimator.FrequencyExperiment properties
schema.prop(c, 'Model',      'string');
schema.prop(c, 'InputData',  'handle vector');
schema.prop(c, 'OutputData', 'handle vector');
schema.prop(c, 'StateData',  'handle vector');
schema.prop(c, 'OperatingPoint', 'handle');
schema.prop(c, 'InitFcn',        'MATLAB array');
schema.prop(c, 'Description',    'string');

p = schema.prop(c, 'Version', 'double');
p.AccessFlags.PublicSet = 'off';
p.FactoryValue = 1.0;
p.Visible = 'off';
