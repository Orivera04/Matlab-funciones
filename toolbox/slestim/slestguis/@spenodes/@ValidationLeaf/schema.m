function schema
% SCHEMA Defines class properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:40:21 $

% Get handles of associated packages and classes
hDeriveFromPackage = findpackage('explorer');
hDeriveFromClass   = findclass(hDeriveFromPackage, 'node');
hCreateInPackage   = findpackage('spenodes');

% Construct class
c = schema.class(hCreateInPackage, 'ValidationLeaf', hDeriveFromClass);

p = schema.prop(c, 'Views', 'MATLAB array');
p.FactoryValue = repmat( handle(NaN), 6, 1 );
p.AccessFlags.Serialize = 'off';
p.Description = 'Vector of figure handles';

p = schema.prop(c, 'ExperimentList', 'MATLAB array');
p.FactoryValue = cell(3,1);
p.Description = 'Storage for validation experiment selection info';

p = schema.prop(c, 'ExperimentType', 'double');
p.FactoryValue = 1;
p.Description = 'Experiment type';

p = schema.prop(c, 'Experiment', 'handle');
p.Description = 'Numerical experiment object';
