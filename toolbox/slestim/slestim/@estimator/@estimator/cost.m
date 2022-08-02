function F = cost(this, R)
% COST Various cost functions for minimization

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:43:18 $

Options = this.Estimation.OptimOptions;

% Calculate the cost function
switch Options.CostType
case 'SSE'
  if strcmp(Options.RobustCost, 'off')
    F = sum_sqr_err(R);
  else
    F = rob_sum_sqr_err(R);
  end
  
case 'SAE'
  if strcmp(Options.RobustCost, 'off')
    F = sum_abs_err(R);
  else 
    F = rob_sum_abs_err(R);
  end
end

% --------------------------------------------------------------------------- %
% Sum of squared errors
function F = sum_sqr_err(R)
F = sum(R.^2);
        
% Robustified sum of squared errors
function F = rob_sum_sqr_err(R)
k = 3 * median( abs(R - median(R)) );
L = R.^2;
idx = (abs(R) > k);
L(idx) = 2 * k * abs(R(idx)) - k^2;
F = sum(L);

% Sum of absolute errors
function F = sum_abs_err(R)
F = sum(abs(R));

% Robustified sum of absolute errors
function F = rob_sum_abs_err(R)
k = 3 * median( abs(R - median(R)) );
L = max(min(R,k), -k);
F = sum(abs(L));
