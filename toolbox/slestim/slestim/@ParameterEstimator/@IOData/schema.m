function schema
% SCHEMA Defines class properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:42:40 $

% Get handles of associated packages and classes
hCreateInPackage = findpackage('ParameterEstimator');

% Construct class
c = schema.class(hCreateInPackage, 'IOData');

% Block name
p = schema.prop(c, 'Block', 'string');
p.AccessFlags.PublicSet = 'off';

% Port type: 'Inport', 'Outport', or 'Signal'
p = schema.prop(c, 'PortType', 'PortType');
p.AccessFlags.PublicSet = 'off';
p.Visible = 'off';

% Port number of the block
p = schema.prop(c, 'PortNumber', 'double');
p.AccessFlags.PublicSet = 'off';
p.FactoryValue = 1;
p.SetFunction  = @LocalSetPortNumber;

% Data dimensions
p = schema.prop(c, 'Dimensions', 'MATLAB array');
p.AccessFlags.PublicSet = 'off';
p.SetFunction = @LocalSetDimensions;

% Experimental data
p = schema.prop(c, 'Data', 'MATLAB array');
p.FactoryValue = NaN;
p.SetFunction  = @LocalSetData;

% Scalar weight on each channel
p = schema.prop(c, 'Weight', 'MATLAB array');
p.SetFunction = @LocalSetWeight;

% User defined description
p = schema.prop(c, 'Description', 'string');

% Object version number
p = schema.prop(c, 'Version', 'double');
p.AccessFlags.PublicSet = 'off';
p.FactoryValue = 1.0;
p.Visible = 'off';

% ---------------------------------------------------------------------------- %
function value = LocalSetPortNumber(this, value)
if ( value <= 0 ) || ( round(value) ~= value )
  error('PortNumber must be set to a positive integer.')
end

% ---------------------------------------------------------------------------- %
function value = LocalSetDimensions(this, value)
if isnumeric(value) && isreal(value) && isvector(value)
  value = reshape( value, [1 numel(value)] );  % Make it a row vector.
else
  error('Dimensions must be set to a row vector of real numbers.');
end

% ----------------------------------------------------------------------------- %
function value = LocalSetData(this, value)
if ~isscalar(value)
  % Number of samples
  p = round( prod(size(value)) / prod(this.Dimensions) );
else
  % Do scalar expansion
  p = 1;
end

if length(this.Dimensions) == 1
  dims = [p this.Dimensions];
else
  dims = [this.Dimensions p];
end

if (length(size(value)) == 2) && length(this.Dimensions) == 2
  value = value';
end

util  = slcontrol.Utilities;
value = formatValueToSize( util, value, dims );

% --------------------------------------------------------------------------- %
function value = LocalSetWeight(this, value)
h = slcontrol.Utilities;
value = formatValueToSize( h, value, [this.Dimensions 1] );
