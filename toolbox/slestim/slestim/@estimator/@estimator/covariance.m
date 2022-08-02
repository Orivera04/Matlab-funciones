function VAR = covariance(this, x)
% COVARIANCE Covariance of parameter estimates

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:43:19 $

OptimOptions  = this.Estimation.OptimOptions;
needGradModel = strcmp( OptimOptions.GradientType, 'refined' ) && ...
    any( strcmp( OptimOptions.Algorithm, {'fmincon','lsqnonlin'}) );
if ~needGradModel
  VAR = [];
  return
end

R = this.error(x,0);
F = this.cost(R);

if strcmp(this.Estimation.OptimOptions.GradientType, 'refined')
  % Compute jacobian by simulation of gradient model
  J = this.simjacobian(x);
else
  % Compute jacobian by finite differencing
  J = this.numjacobian(x);
end

[m,n] = size(J);
sigma = F / (m - n);
VAR = sigma^2 * pinv(J'*J); % Pseudo-inverse for rank deficient case.
