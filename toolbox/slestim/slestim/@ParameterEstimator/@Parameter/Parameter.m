function this = Parameter(name, varargin)
% PARAMETER Constructs an object to represent estimated parameters associated
% with dynamic Simulink block.
%
% h = ParameterEstimator.Parameter('name')
% h = ParameterEstimator.Parameter('name', value)
% h = ParameterEstimator.Parameter('name', value, minimum, maximum)
%
% NAME is the parameter name.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.5 $Date: 2004/04/11 00:42:41 $

% Create class instance
this = ParameterEstimator.Parameter;

ni = nargin;
if ni == 0
  % Call when reloading object
  return
end

% Initialize object
initialize(this, name);

% Data specified
if (ni == 2) || (ni == 4)
  update(this, varargin{1});
else
  update(this);
end

% Min & Max specified
if (ni == 4)
  this.Minimum = varargin{2};
  this.Maximum = varargin{3};
end
