function schema
% SCHEMA Abstract @estimator class

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.8 $ $Date: 2004/04/11 00:43:25 $

% Get handles of associated packages
hCreateInPackage = findpackage('estimator');

% Construct class
c = schema.class(hCreateInPackage, 'estimator');

% Estimation project
p = schema.prop(c, 'Estimation', 'handle');
p.AccessFlags.PublicSet = 'off';
p.SetFunction = @LocalSetEstimation;
      
% Gradient computation engine (@GradientModel)
p = schema.prop(c, 'Gradient',  'handle');
p.AccessFlags.PublicSet = 'off';

% Optimization info 
p = schema.prop(c, 'Info', 'MATLAB array');

% Optimization options (modified OPTIMSET structure)
p = schema.prop(c, 'Options', 'MATLAB array');

% ----------------------------------------------------------------------------- %
function value = LocalSetEstimation(this, value)
cls = 'ParameterEstimator.Estimation';

if ~isa(value, cls)
  error( 'Property must be set to an object of class %s.', cls )
end
