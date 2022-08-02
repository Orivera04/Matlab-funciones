function OptimInfo = minimize(this)
% MINIMIZE Runs the optimization algorithm to minimize the cost and estimate
%          the model parameters.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.7 $ $Date: 2004/04/11 00:43:35 $

% Parameter specs.
p = obj2var(this);
this.Info.xMin   = p.Minimum;
this.Info.xMax   = p.Maximum;
this.Info.xScale = p.Typical;

if any( isfinite(p.Minimum) ) || any( isfinite(p.Maximum) )
  warning('Ignoring lower and upper bounds on the tuned variables.')
end

% Minimization
this.Options.TypicalX = this.Info.xScale;
[x, fval, exitflag, output] = ...
    fminsearch( @LocalCostFun, p.Initial, this.Options, this );

% Output
OptimInfo = struct('Cost',     fval, ...
                   'X',        x, ...
                   'ExitFlag', exitflag, ...
                   'Output',   output );

% ------------------------------------------------------------------------- %
function F = LocalCostFun(x, this)
% Return F only
R = this.error(x,0);
F = this.cost(R);

% Update TypicalX
this.Info.xScale = max( this.Info.xScale, abs(x) );
