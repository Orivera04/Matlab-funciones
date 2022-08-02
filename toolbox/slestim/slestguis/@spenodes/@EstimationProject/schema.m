function schema
% SCHEMA Defines class attributes for @EstimationProject class

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:39:04 $

% Get handles of associated packages and classes
hDeriveFromPackage = findpackage('explorer');
hDeriveFromClass   = findclass(hDeriveFromPackage, 'tasknode');
hCreateInPackage   = findpackage('spenodes');

% Construct class
c = schema.class(hCreateInPackage, 'EstimationProject', hDeriveFromClass);

% Define class properties
% Name of Simulink model used in the project.
p = schema.prop(c, 'Model', 'string');
p.AccessFlags.PublicSet = 'off';
p.FactoryValue = '';
