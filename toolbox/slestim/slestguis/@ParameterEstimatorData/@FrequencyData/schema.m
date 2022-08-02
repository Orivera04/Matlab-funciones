function schema
% SCHEMA Define class properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:37:35 $

% Get handles of associated packages and classes
hCreateInPackage = findpackage('ParameterEstimatorData');

% Construct class
c = schema.class(hCreateInPackage, 'FrequencyData');

% Proxy to ParameterEstimator.FrequencyData properties
schema.prop(c, 'Block', 'string');
schema.prop(c, 'Dimensions', 'MATLAB array');

p = schema.prop(c, 'Data', 'string vector');
p.SetFunction = @LocalSetData;

schema.prop(c, 'DataSrc', 'string vector');
schema.prop(c, 'DataVal', 'MATLAB array');

p = schema.prop(c, 'Frequency' , 'string');
p.SetFunction = @LocalSetFrequency;

schema.prop(c, 'FrequencySrc', 'string');
schema.prop(c, 'FrequencyVal', 'MATLAB array');

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
function value = LocalSetFrequency(this, value)
value( isempty(value) ) = ' ';

freqval = evalin( 'base', value, '[]' );
this.FrequencySrc = '';
this.FrequencyVal = freqval(:);

% --------------------------------------------------------------------------
function value = LocalGetLength(this, value)
for k = 1:length(value)
  str1 = '-'; str2 = '-';
  
  if ~isempty( this.DataVal{k} )
    str1 = sprintf( '%d', length(this.DataVal{k}) );
  end
  
  if ~isempty( this.FrequencyVal )
    str2 = sprintf( '%d', length(this.FrequencyVal) );
  end
  
  value{k} = sprintf('%s/%s', str1, str2);
end
