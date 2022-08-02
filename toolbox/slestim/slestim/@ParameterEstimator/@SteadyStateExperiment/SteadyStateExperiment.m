function this = SteadyStateExperiment(model, varargin)
% STEADYSTATEEXPERIMENT Constructs an object to represent the experimental I/O
% data and the state data of a Simulink model to be used for
% parameter estimation.
%
% h = ParameterEstimator.SteadyStateExperiment('model')
% h = ParameterEstimator.SteadyStateExperiment('model', hIn, hOut, hSt)
%
% MODEL is a Simulink model name or handle.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:43:02 $

% Create class instance
this = ParameterEstimator.SteadyStateExperiment;

ni = nargin;
if ni == 0
  % Call when reloading object
  return
end

% Initialize object
initialize(this, model);

% Initialize public properties
if ni == 1
  update(this);
elseif ni <= 4
  this.InputData  = varargin{1};
  this.OutputData = varargin{2};
  this.StateData  = varargin{3};
end
