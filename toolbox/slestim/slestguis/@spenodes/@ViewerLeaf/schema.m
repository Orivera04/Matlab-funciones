function schema
% SCHEMA Defines class properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:40:48 $

% Get handles of associated packages and classes
hDeriveFromPackage = findpackage('explorer');
hDeriveFromClass   = findclass(hDeriveFromPackage, 'node');
hCreateInPackage   = findpackage('spenodes');

% Construct class
c = schema.class(hCreateInPackage, 'ViewerLeaf', hDeriveFromClass);

p = schema.prop(c, 'Views', 'MATLAB array');
p.FactoryValue = repmat( handle(NaN), 6, 1 );
p.AccessFlags.Serialize = 'off';
p.Description = 'Vector of figure handles';
