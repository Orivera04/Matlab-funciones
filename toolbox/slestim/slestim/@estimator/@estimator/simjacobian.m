function Jac = simjacobian(this, x)
% SIMJACOBIAN Jacobian of output errors wrt. parameter variations.  For N
% parameters and M output data points, the size of the jacobian matrix is MxN
% with J = [df_m/dx_n].  Usually M >> N, so J is a tall matrix.
%
% X Vector of tunable parameter values at this iteration.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:43:26 $

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
  
  % Simulate gradient model to evaluate F(xL) - F(xR) for the j^th parameter
  if strcmp(this.Estimation.EstimStatus, 'run')
    dF = LocalEvalJacobian(this, x, xL, xR, j);
  else
    % Interrupted
    Jac = []; return
  end
  
  % Compute the jacobian wrt the j^th parameter
  Jac(:,j) = dF ./ (xjL - xjR);
end

% --------------------------------------------------------------------------
function dF = LocalEvalJacobian(this, x, xL, xR, j)
Estimation = this.Estimation;
Simulators = Estimation.Simulators;
GradModel  = this.Gradient.GradModel;

% Set L/R parameter values in gradient model. Does NOT set states.
var2parG(this,xL,xR)

% Evaluate jacobian for each experiment (simulation)
dF = [];
for ct = 1:length( Simulators )
  % xL,xR -> sL,sR (Initial state values for this simulation)
  [sL,sR] = LocalGetInitialStates(this, Simulators(ct), xL, xR);
  
  dF = [ dF; evalJacobian( Simulators(ct), GradModel, x, sL, sR, j ) ];
end

% --------------------------------------------------------------------------
function [sL,sR] = LocalGetInitialStates(this, Simulator, xL, xR)
Estimation = this.Estimation;

est = get(Estimation.Parameters, {'Estimated'});
offset = 0;
for ct = 1:length(est)
  idxs = find( est{ct} );
  offset = offset + length( idxs );
end

p  = Estimation.States(:);
cs = Simulator.States;

sL = [];
sR = [];
for ct = 1:length(p)
  pct = p(ct);
  idxt = find(pct.Estimated);
  len = length(idxt);
  
  if len > 0
    if any( pct == cs)
      sLct = pct.Value;
      sRct = pct.Value;
      sLct(idxt) =  xL(offset+1:offset+len);
      sRct(idxt) =  xR(offset+1:offset+len);
      
      sL = [sL; sLct(:)];
      sR = [sR; sRct(:)];
    end
    offset = offset + len;
  end
end
