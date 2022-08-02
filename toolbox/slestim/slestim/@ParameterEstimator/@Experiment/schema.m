function schema
% SCHEMA Defines class properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:42:26 $

% Get handles of associated packages and classes
hCreateInPackage = findpackage('ParameterEstimator');

% Construct class
c = schema.class(hCreateInPackage, 'Experiment');

% Model name
p = schema.prop(c, 'Model', 'string');
p.AccessFlags.PublicSet = 'off';
p.SetFunction = @LocalSetModel;

% Initialization function
p = schema.prop(c, 'InitFcn', 'MATLAB array');

% User defined description
p = schema.prop(c, 'Description', 'string');

% User defined data
p = schema.prop(c, 'UserData', 'MATLAB array');

% Object version number
p = schema.prop(c, 'Version', 'double');
p.AccessFlags.PublicSet = 'off';
p.FactoryValue = 1.0;
p.Visible = 'off';

% ----------------------------------------------------------------------------- %
function value = LocalSetModel(this, value)
if ~( exist(value, 'file') == 4 )
  error( 'Unable to locate the block diagram named ''%s''.', value );
end
