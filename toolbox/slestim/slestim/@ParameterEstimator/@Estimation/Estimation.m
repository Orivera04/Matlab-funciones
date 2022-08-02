function this = Estimation(model, varargin)
% ESTIMATION Constructor
%
% h = ParameterEstimator.Estimation('model')
% h = ParameterEstimator.Estimation('model', hParams)
% h = ParameterEstimator.Estimation('model', hParams, hExps)
%
% MODEL is a Simulink model name or handle
% HPARAMS is a vector of @Parameter objects

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:42:07 $

% Create class instance
this = ParameterEstimator.Estimation;

ni = nargin;
if ni == 0
  % Call when reloading object
  return
end

% Initialize object
initialize(this, model);

% Initialize public properties
update(this);

% Arguments specified
if (ni == 2)
  this.Parameters  = varargin{1};
elseif (ni == 3)
  this.Parameters  = varargin{1};
  this.Experiments = varargin{2};
end
