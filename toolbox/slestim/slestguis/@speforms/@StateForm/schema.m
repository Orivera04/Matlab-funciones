function schema
% SCHEMA Define class properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:38:21 $

% Get handles of associated packages and classes
hCreateInPackage = findpackage('speforms');

% Construct class
c = schema.class(hCreateInPackage, 'StateForm');

% Proxy to ParameterEstimator.State properties
schema.prop(c, 'Block',        'string');
schema.prop(c, 'Dimensions',   'MATLAB array');
schema.prop(c, 'Value',        'string');
schema.prop(c, 'Estimated',    'string');
schema.prop(c, 'InitialGuess', 'string');
schema.prop(c, 'Minimum',      'string');
schema.prop(c, 'Maximum',      'string');
schema.prop(c, 'TypicalValue', 'string');
schema.prop(c, 'Ts',           'string');
schema.prop(c, 'Domain',       'string');
schema.prop(c, 'Description',  'string');

p = schema.prop(c, 'Version', 'double');
p.AccessFlags.PublicSet = 'off';
p.FactoryValue = 1.0;
p.Visible = 'off';
