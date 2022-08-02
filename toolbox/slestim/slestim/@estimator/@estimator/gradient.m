function G = gradient(this, J, R)
% GRADIENT Gradient of various cost functions for minimization

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:43:21 $

Options = this.Estimation.OptimOptions;

% Calculate the cost function
switch Options.CostType
case 'SSE'
  if strcmp(Options.RobustCost, 'off')
    G = sum_sqr_err(J, R);
  else
    G = rob_sum_sqr_err(J, R);
  end
  
case 'SAE'
  if strcmp(Options.RobustCost, 'off')
    G = sum_abs_err(J, R);
  else 
    G = rob_sum_abs_err(J, R);
  end
end

% --------------------------------------------------------------------------- %
% Sum of squared errors
function G = sum_sqr_err(J, R)
G = 2 * J' * R;

% Robustified sum of squared errors
function G = rob_sum_sqr_err(J, R)
k = 3 * median( abs(R - median(R)) );
L = max(min(R,k), -k);
G = 2 * J' * L;

% Sum of absolute errors
function G = sum_abs_err(J, R)
G = J' * sign(R);

% Robustified sum of absolute errors
function G = rob_sum_abs_err(J, R)
k = 3 * median( abs(R - median(R)) );
L = max(min(R,k), -k);
G = J' * sign(L);
