function schema
% SCHEMA  Defines properties for @Variables class

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:40:32 $

% Get handles of associated packages and classes
hDeriveFromPackage = findpackage('explorer');
hDeriveFromClass   = findclass(hDeriveFromPackage, 'node');
hCreateInPackage   = findpackage('spenodes');

% Construct class
c = schema.class(hCreateInPackage, 'Variables', hDeriveFromClass);

p = schema.prop(c, 'Parameters', 'handle vector');
p.Description = 'Storage for parameter forms';

p = schema.prop(c, 'States', 'handle vector');
p.Description = 'Storage for state forms';

p = schema.prop(c, 'ParameterDialog', 'handle');
p.Description = 'Handle to parameter import dialog object';
p.AccessFlags.Serialize = 'off';

p = schema.prop(c, 'StateDialog', 'MATLAB array');
p.Description = 'Handle to state import dialog object';
p.AccessFlags.Serialize = 'off';
