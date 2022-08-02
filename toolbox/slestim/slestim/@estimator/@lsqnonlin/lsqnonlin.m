function this = lsqnonlin(Estimation)
% LSQNONLIN Constructor

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:43:38 $

% Create object
this = estimator.lsqnonlin;

% Check OPTIM is on the path
if ~license('test', 'Optimization_Toolbox')
  error('Simulink Parameter Estimation requires the Optimization Toolbox.')
end

% Initialize properties
this.initialize(Estimation);

% Default options
Options = optimset('lsqnonlin');
Options.PrecondBandWidth = Inf;
Options.Jacobian = 'on';

Options = optimset( Options, getSettings(Estimation.OptimOptions) );
this.Options = Options;
