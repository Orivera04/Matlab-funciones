function Jac = numjacobian(this, x)
% NUMJACOBIAN Jacobian of output errors wrt. parameter variations.  For N
% parameters and M output data points, the size of the jacobian matrix is MxN
% with J = [df_m/dx_n].  Usually M >> N, so J is a tall matrix.
%
% X Vector of tunable parameter values at this iteration.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:43:23 $

% Perturbation size
xMin   = this.Info.xMin;
xMax   = this.Info.xMax;
xScale = this.Info.xScale;
xScale(xScale == 0) = 1;

% Perturbations for central difference gradients.  Dennis & Schnabel, p.105.
dx = 100 * eps^(1/3) * sign(x+eps) .* max( abs(x), abs(xScale) );

% Loop through the tunable parameters
for j = 1:length(x)
  % Perturbations
  xjL = min( xMax(j), x(j)+dx(j) );
  xjR = max( xMin(j), x(j)-dx(j) );
  
  % Perturbed parameters
  xL = x; xL(j) = xjL;
  xR = x; xR(j) = xjR;
  
  % Evaluate residuals at x+dx
  if strcmp(this.Estimation.EstimStatus, 'run')
    FL = this.error(xL, j);
  else
    % Interrupted or error
    Jac = []; return
  end

  % Evaluate residuals at x-dx
  if strcmp(this.Estimation.EstimStatus, 'run')
    FR = this.error(xR, -j);
  else
    % Interrupted or error
    Jac = []; return
  end
  
  % Estimate the jacobian wrt the j^th parameter
  dF = FL - FR;
  dF(imag(FL)~=0 | imag(FR)~=0) = 0; % complex -> sim failure
  
  Jac(:,j) = dF ./ (xjL - xjR);
end
