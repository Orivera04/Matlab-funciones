function schema
% SCHEMA Defines properties for @TransientData class

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.7 $ $Date: 2004/04/11 00:39:50 $

% Get handles of associated packages and classes
hDeriveFromPackage = findpackage('explorer');
hDeriveFromClass   = findclass(hDeriveFromPackage, 'node');
hCreateInPackage   = findpackage('spenodes');

% Construct class
c = schema.class(hCreateInPackage, 'TransientData', hDeriveFromClass);

% Storage for prototypical experiments
p = schema.prop(c, 'Experiment', 'handle');
p.AccessFlags.PublicSet = 'off';
