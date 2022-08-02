function schema
% SCHEMA Defines class properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:42:55 $

% Get handles of associated packages and classes
hCreateInPackage = findpackage('ParameterEstimator');

% Construct class
c = schema.class(hCreateInPackage, 'StateData');

% Block name
p = schema.prop(c, 'Block', 'string');
p.AccessFlags.PublicSet = 'off';

% Data dimensions
p = schema.prop(c, 'Dimensions', 'MATLAB array');
p.AccessFlags.PublicSet = 'off';
p.SetFunction = @LocalSetDimensions;

% State data
p = schema.prop(c, 'Data', 'MATLAB array');
p.FactoryValue = [];
p.SetFunction  = @LocalSetData;

% Block sampling time
p = schema.prop(c, 'Ts', 'double');
p.SetFunction = @LocalSetTs;

% Physical domain (for physical modeling blocks)
p = schema.prop(c, 'Domain', 'string');
p.Visible = 'off';

% User defined description
p = schema.prop(c, 'Description', 'string');

% Object version number
p = schema.prop(c, 'Version', 'double');
p.AccessFlags.PublicSet = 'off';
p.FactoryValue = 1.0;
p.Visible = 'off';

% ---------------------------------------------------------------------------- %
function value = LocalSetDimensions(this, value)
if isnumeric(value) && isreal(value) && isvector(value) && (length(value) == 2)
  value = reshape( value, [1 numel(value)] );  % Make it a row vector.  
else
  error('Dimensions must be set to a vector of real numbers with two elements.');
end

% --------------------------------------------------------------------------- %
function value = LocalSetData(this, value)
if ~isscalar(value)
  % Number of samples
  p = round( prod(size(value)) / prod(this.Dimensions) );
else
  % Do scalar expansion
  p = 1;
end
dims = [this.Dimensions p];

if (length(size(value)) == 2) && length(this.Dimensions) == 2
  value = value';
end

util  = slcontrol.Utilities;
value = formatValueToSize( util, value, dims );

% ----------------------------------------------------------------------------- %
function value = LocalSetTs(this, value)
if ( value < 0 )
  error('The sample time must be a non-negative number.')
end
