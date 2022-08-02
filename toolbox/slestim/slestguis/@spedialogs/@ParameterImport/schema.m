function schema
% SCHEMA Defines class properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:38:03 $

% Get handles of associated packages and classes
hCreateInPackage = findpackage('spedialogs');

% Construct class
c = schema.class( hCreateInPackage, 'ParameterImport' );

% Properties
p = schema.prop(c, 'TunableVars', 'MATLAB array');
p.Description = 'Tunable model parameters';

p = schema.prop(c, 'Node', 'handle');
p.AccessFlags.PublicSet = 'off';
p.Description = 'Handle of the UDD tree node';

cls = 'com.mathworks.toolbox.slestim.variables.ParameterImportDialog';
p = schema.prop( c, 'Dialog', cls );
p.AccessFlags.PublicSet = 'off';
p.Description = 'Handle of the Java Parameter Import dialog';

p = schema.prop(c, 'Handles', 'MATLAB array');
p.AccessFlags.PublicSet = 'off';

p = schema.prop( c, 'Listeners', 'handle vector' );
p.AccessFlags.PublicSet = 'off';
