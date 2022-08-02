function schema
% SCHEMA  Defines properties for EstimationLeaf class

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.9 $ $Date: 2004/04/11 00:38:53 $

% Get handles of associated packages and classes
hDeriveFromPackage = findpackage('explorer');
hDeriveFromClass   = findclass(hDeriveFromPackage, 'node');
hCreateInPackage   = findpackage('spenodes');

% Construct class
c = schema.class(hCreateInPackage, 'EstimationLeaf', hDeriveFromClass);

p = schema.prop(c, 'Estimation', 'handle');
p.Description = 'Estimation results in this object';

p = schema.prop(c, 'ExperimentList', 'MATLAB array');
p.FactoryValue = cell(3,1);
p.Description = 'Storage for estimation experiment selection info';

p = schema.prop(c, 'ExperimentType', 'double');
p.FactoryValue = 1;
p.Description = 'Experiment type';

p = schema.prop(c, 'Experiments', 'MATLAB array');
p.FactoryValue = cell(3,1);
p.Description = 'Storage for experiment forms';

p = schema.prop(c, 'Parameters', 'handle vector');
p.Description = 'Storage for parameter forms';

p = schema.prop(c, 'States', 'MATLAB array');
p.FactoryValue = cell(3,1);
p.Description = 'Storage for state forms';

p = schema.prop(c, 'OptimOptions', 'handle'); % @OptimOptionForm
p.Description = 'Optimizer settings (literal specs)';

p = schema.prop(c,'SimOptions', 'handle');    % @SimOptionForm
p.Description = 'Simulation settings (literal specs)';

p = schema.prop(c, 'OptionsDialog', 'MATLAB array');
p.Description = 'Handle to options dialog object';
p.AccessFlags.Serialize = 'off';
