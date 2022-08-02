function schema
% SCHEMA Define class properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:37:47 $

% Get handles of associated packages and classes
hCreateInPackage = findpackage('ParameterEstimatorData');

% Construct class
c = schema.class(hCreateInPackage, 'SteadyStateData');

% Proxy to ParameterEstimator.SteadyStateData properties
schema.prop(c, 'Block', 'string');
schema.prop(c, 'Dimensions', 'MATLAB array');

p = schema.prop(c, 'Data', 'string vector');
p.SetFunction = @LocalSetData;

schema.prop(c, 'DataSrc', 'string vector');
schema.prop(c, 'DataVal', 'MATLAB array');

schema.prop(c, 'Weight', 'string vector');
schema.prop(c, 'Description', 'string');

p = schema.prop(c, 'Length', 'string vector');
p.GetFunction = @LocalGetLength;

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

% --------------------------------------------------------------------------
function value = LocalGetLength(this, value)
for k = 1:length(value)
  str1 = '-';
  
  if ~isempty( this.DataVal{k} )
    str1 = sprintf( '%d', length(this.DataVal{k}) );
  end
  
  value{k} = str1;
end
