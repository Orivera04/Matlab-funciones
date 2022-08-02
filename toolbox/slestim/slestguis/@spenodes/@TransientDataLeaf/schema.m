function schema
% SCHEMA  Defines properties for the TransientDataLeaf class

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:40:03 $

% Get handles of associated packages and classes
hDeriveFromPackage = findpackage('explorer');
hDeriveFromClass   = findclass(hDeriveFromPackage, 'node');
hCreateInPackage   = findpackage('spenodes');

% Construct class
c = schema.class(hCreateInPackage, 'TransientDataLeaf', hDeriveFromClass);

p = schema.prop(c, 'Experiment', 'handle');
p.Description = 'Storage for transient experiment forms';
