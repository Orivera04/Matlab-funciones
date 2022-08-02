function schema
% SCHEMA Abstract @estimator class

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:43:52 $

% Get handles of associated packages
hCreateInPackage = findpackage('simulator');

% Construct class
c = schema.class(hCreateInPackage, 'simulator');

p = schema.prop(c, 'Experiment', 'handle');
p.AccessFlags.PublicSet = 'off';
p.AccessFlags.Serialize = 'off';
p.Description = 'Experiment associated with this simulation';

p = schema.prop(c, 'States', 'MATLAB array');
p.AccessFlags.PublicSet = 'off';
p.AccessFlags.Serialize = 'off';
p.Description = 'Estimated states associated with this simulation';

p = schema.prop(c, 'SimOptions', 'handle');
p.AccessFlags.PublicSet = 'off';
p.AccessFlags.Serialize = 'off';
p.Description = 'Simulation settings';

p = schema.prop(c, 'DataLog', 'MATLAB array');
p.FactoryValue = struct('X', [], 'Data', []);
p.AccessFlags.Serialize = 'off';
p.Description = 'Simulation data log';

p = schema.prop(c, 'GradLog', 'MATLAB array');
% length(X)-by-1 struct array w/ fields X and Data
p.AccessFlags.Serialize = 'off';
p.Description = 'Data log for gradient model';

% Version
p = schema.prop(c, 'Version', 'double');
p.FactoryValue = 1.0;
p.AccessFlags.PublicGet = 'off';
p.AccessFlags.PublicSet = 'off';

% Events
schema.event(c,'EstimStop');
schema.event(c,'EstimStart');
schema.event(c,'EstimUpdate');
