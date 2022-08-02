function schema
% SCHEMA Defines class properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:42:49 $

% Get handles of associated packages and classes
hCreateInPackage = findpackage('ParameterEstimator');

% Construct class
c = schema.class(hCreateInPackage, 'State');

% Block name
p = schema.prop(c, 'Block', 'string');
p.AccessFlags.PublicSet = 'off';

% Data dimensions
p = schema.prop(c, 'Dimensions', 'MATLAB array');
p.AccessFlags.PublicSet = 'off';
p.SetFunction = @LocalSetDimensions;

% State values
p = schema.prop(c, 'Value', 'MATLAB array');
p.SetFunction = @LocalSetValue;

% Estimated elements
p = schema.prop(c, 'Estimated', 'MATLAB array');
p.SetFunction = @LocalSetEstimated;

% Initial guess
p = schema.prop(c, 'InitialGuess', 'MATLAB array');
p.SetFunction = @LocalSetValue;

% Minimum values
p = schema.prop(c, 'Minimum', 'MATLAB array');
p.SetFunction = @LocalSetValue;

% Maximum value
p = schema.prop(c, 'Maximum', 'MATLAB array');
p.SetFunction = @LocalSetValue;

% State scaling
p = schema.prop(c, 'TypicalValue', 'MATLAB array');
p.SetFunction = @LocalSetValue;

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
function value = LocalSetValue(this, value)
h = slcontrol.Utilities;
value = formatValueToSize(h, value, this.Dimensions);

% ----------------------------------------------------------------------------- %
function value = LocalSetTs(this, value)
if ( value < 0 )
  error('The sample time must be a non-negative number.')
end

% --------------------------------------------------------------------------- %
function value = LocalSetEstimated(this, value)
try
  value = logical(value);
catch
  error('Cannot convert assigned value to logical.')
end

h = slcontrol.Utilities;
value = formatValueToSize(h, value, this.Dimensions, true);
