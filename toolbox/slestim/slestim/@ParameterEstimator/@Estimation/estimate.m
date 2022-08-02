function varargout = estimate(this, varargin)
% ESTIMATE  Perform parameter estimation
%
% Given an estimation EST, you can run an estimation using
%   estimate(est)        Estimate using the current experiments in EST
%   estimate(est, exps)  Estimate using the experiments supplied by EXPS

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.12 $ $Date: 2004/04/16 22:21:48 $

if ( nargin > 1 )
  this.Experiments = varargin{1};
end

% Is the model loaded?
LoadFlag = isempty( find( get_param(0, 'Object'), 'Name', this.Model ) );
if LoadFlag
  load_system(this.Model);
end

% Check settings
[hasTunedParams, hasTunedStates, hasExperiments] = checkSettings(this);
if ~hasTunedParams && ~hasTunedStates
  error('No parameters or states to estimate.')
elseif ~hasExperiments
  error( 'No experiments specified for this estimation.' )
end

% Create simulator objects
this.Simulators = getSimulators(this);

switch this.OptimOptions.Algorithm;
case 'fmincon'
  Estimator = estimator.fmincon(this);
case 'fminsearch'
  Estimator = estimator.fminsearch(this);
case 'lsqnonlin'
  Estimator = estimator.lsqnonlin(this);
case 'patternsearch'
  Estimator = estimator.patternsearch(this);
end

% Set info structure and output function
Estimator.Info = struct( 'xMin', [], 'xMax', [], 'xScale', [] );
Estimator.Options.OutputFcn = @LocalOutput;

% Clear estimation info
this.clearEstimInfo;

% Change status to 'run' (see setFunction for side effects)
this.EstimStatus = 'run';

% Start estimation.  Will fill this.EstimInfo property.
sw = warning('off'); lw = lastwarn;
OptimInfo = minimize(Estimator);
warning(sw); lastwarn(lw)

% Return to idle status
this.EstimStatus = 'idle';

% Clean up
if strcmp( this.OptimOptions.GradientType, 'refined' )
  try
    delete( Estimator.Gradient )
  catch
    error('Error closing model %s.\n%s', Estimator.Gradient.GradModel, lasterr);
  end
end

% Close model
if LoadFlag
   close_system(this.Model,0);
end

if nargout > 0
  varargout{1} = OptimInfo;
end

% ------------------------------------------------------------------------- %
function stop = LocalOutput(values, state, type, Estimator)
% Used to store progress information and stop optimization
drawnow % Force processing of any stop event

this = Estimator.Estimation;
stop = strcmp( this.EstimStatus, 'stop');

if strcmp(type, 'iter')
  if ~stop
    % Resync estimation data with current best X
    Estimator.syncEstimation(values);
  
    % Update plots
    for ct = 1:length(this.Simulators)
      estimUpdate(this.Simulators(ct));
    end
  end
  
  % Update iteration infor
  newInfo = Estimator.getIterInfo(values, state, type);
  this.setEstimInfo(newInfo, type)
  
  % Send event to listeners
  this.send('EstimUpdate')
elseif strcmp(type, 'done')
  newInfo = this.EstimInfo;
  newInfo.Covariance = Estimator.covariance(values);
  this.setEstimInfo(newInfo);
end
