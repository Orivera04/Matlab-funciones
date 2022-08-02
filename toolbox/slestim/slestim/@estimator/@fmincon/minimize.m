function OptimInfo = minimize(this)
% MINIMIZE Runs the optimization algorithm to minimize the cost and estimate
%          the model parameters.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.7 $ $Date: 2004/04/11 00:43:31 $

% Parameter specs.
p = obj2var(this);
this.Info.xMin   = p.Minimum;
this.Info.xMax   = p.Maximum;
this.Info.xScale = p.Typical;

% Minimization
this.Options.TypicalX = this.Info.xScale;
[x, fval, exitflag, output] = ...
    fmincon( @LocalCostFun, p.Initial, [], [], [], [], ...
             p.Minimum, p.Maximum, [], this.Options, this );

% Output
OptimInfo = struct( 'Cost',     fval, ...
                    'X',        x, ...
                    'ExitFlag', exitflag, ...
                    'Output',   output );

% ------------------------------------------------------------------------- %
function [F, G] = LocalCostFun(x, this)
% Compute cost function and its gradient
GradRequest = (nargout>1);

R = this.error(x,0);
F = this.cost(R);

if GradRequest
  if strcmp(this.Estimation.OptimOptions.GradientType, 'refined')
    % Compute jacobian by simulation of gradient model
    J = this.simjacobian(x);
  else
    % Compute jacobian by finite differencing
    J = this.numjacobian(x);
  end
  
  if isempty(J)
    J = zeros(length(R), length(x));
  end
  
  G = gradient(this,J,R);
end

% Update TypicalX at major steps only to insulate it from large X tried
% during line search.
if GradRequest
  this.Info.xScale = max( this.Info.xScale, abs(x) );
end
