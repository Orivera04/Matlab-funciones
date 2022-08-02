function schema
% SCHEMA Define class properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:37:43 $

% Get handles of associated packages and classes
hCreateInPackage = findpackage('ParameterEstimatorData');

% Construct class
c = schema.class(hCreateInPackage, 'StateData');

% Proxy to ParameterEstimator.StateData properties
schema.prop(c, 'Block', 'string');
schema.prop(c, 'Dimensions', 'MATLAB array');

p = schema.prop(c, 'Data', 'string vector');
p.SetFunction = @LocalSetData;

schema.prop(c, 'DataSrc', 'string vector');
schema.prop(c, 'DataVal', 'MATLAB array');

schema.prop(c, 'Ts' ,         'string');
schema.prop(c, 'Domain',      'string');
schema.prop(c, 'Description', 'string');

schema.prop(c, 'Length', 'string vector');

p = schema.prop(c, 'Version', 'double');
p.AccessFlags.PublicSet = 'off';
p.FactoryValue = 1.0;
p.Visible = 'off';

% --------------------------------------------------------------------------
function value = LocalSetData(this, value)
value( cellfun('isempty', value) ) = {' '};

for k = 1:length(value)
  dataval = evalin( 'base', value{k}, '[]' );
  this.DataSrc{k} = '';
  this.DataVal{k} = dataval(:);
end
