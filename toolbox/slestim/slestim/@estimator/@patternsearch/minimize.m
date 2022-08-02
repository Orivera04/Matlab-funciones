function OptimInfo = minimize(this)
% MINIMIZE Runs the optimization algorithm to minimize the cost and estimate
%          the model parameters.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:43:42 $

% Parameter specs.
p = obj2var(this);
this.Info.xMin   = p.Minimum;
this.Info.xMax   = p.Maximum;
this.Info.xScale = p.Typical;

% Minimization
this.Options.OutputFcns = @(x,y,z) LocalOutput(x,y,z,this);
[x, fval, exitflag, output] = ...
    patternsearch( {@LocalCostFun, this}, p.Initial, [], [], [], [], ...
                   p.Minimum, p.Maximum, this.Options );

% Output
OptimInfo = struct( 'Cost',     fval, ...
                    'X',        x, ...
                    'ExitFlag', exitflag, ...
                    'Output',   output );

% ------------------------------------------------------------------------- %
function F = LocalCostFun(x, this)
% Return F only
R = this.error(x,0);
F = this.cost(R);

% Update TypicalX
% REVISIT: Geck 206968
this.Info.xScale = max( this.Info.xScale, abs(x(:)) );

% ------------------------------------------------------------------------- %
function [stop, options, optchanged] = LocalOutput(state,options,stage,this)
values = state.x;
type   = stage;

stop = feval(this.Options.OutputFcn, values, state, type, this);
optchanged = false;
