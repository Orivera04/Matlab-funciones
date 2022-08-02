function schema
% SCHEMA Defines class properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:38:09 $

% Get handles of associated packages and classes
hCreateInPackage = findpackage('spedialogs');

% Construct class
c = schema.class( hCreateInPackage, 'StateImport' );

% Properties
p = schema.prop(c, 'TunableStates', 'MATLAB array');
p.Description = 'Tunable model states';

p = schema.prop(c, 'Node', 'handle');
p.AccessFlags.PublicSet = 'off';
p.Description = 'Handle of the UDD tree node';

cls = 'com.mathworks.toolbox.slestim.variables.StateImportDialog';
p = schema.prop( c, 'Dialog', cls );
p.AccessFlags.PublicSet = 'off';
p.Description = 'Handle of the Java State Import dialog';

p = schema.prop(c, 'Handles', 'MATLAB array');
p.AccessFlags.PublicSet = 'off';

p = schema.prop( c, 'Listeners', 'handle vector' );
p.AccessFlags.PublicSet = 'off';
