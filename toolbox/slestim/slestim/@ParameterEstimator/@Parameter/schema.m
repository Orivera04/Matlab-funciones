function schema
% SCHEMA Defines class properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:42:44 $

% Get handles of associated packages and classes
hDeriveFromPackage = findpackage('slcontrol');
hDeriveFromClass   = findclass(hDeriveFromPackage, 'Parameter');
hCreateInPackage   = findpackage('ParameterEstimator');

% Construct class
c = schema.class(hCreateInPackage, 'Parameter', hDeriveFromClass);

% Estimated elements
p = schema.prop(c, 'Estimated', 'MATLAB array');
p.SetFunction = @LocalSetEstimated;

% ----------------------------------------------------------------------------- %
function value = LocalSetEstimated(this, value)
try
  value = logical(value);
catch
  error('Cannot convert assigned value to logical.')
end

h = slcontrol.Utilities;
value = formatValueToSize(h, value, this.Dimensions, true);
