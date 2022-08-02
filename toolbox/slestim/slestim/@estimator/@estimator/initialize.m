function initialize(this, Estimation)
% INITIALIZE Initialize the @estimator object

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.9 $ $Date: 2004/04/11 00:43:22 $

% Initialize properties
this.Estimation = Estimation;

% Create gradient model object.
OptimOptions  = Estimation.OptimOptions;
needGradModel = strcmp( OptimOptions.GradientType, 'refined' ) && ...
    any( strcmp( OptimOptions.Algorithm, {'fmincon','lsqnonlin'}) );
if needGradModel
  % Create gradient model
  this.Gradient = makeGradient(Estimation);
end
