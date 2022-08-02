function this = State(block, varargin)
% STATE  Constructs an object to represent estimated states associated with
% a dynamic Simulink block.
%
% h = ParameterEstimator.State('block')
% h = ParameterEstimator.State('block', value)
% h = ParameterEstimator.State('block', value, minimum, maximum)
%
% BLOCK is a Simulink block name or handle.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:42:46 $

% Create class instance
this = ParameterEstimator.State;

ni = nargin;
if ni == 0
  % Call when reloading object
  return
end

% Initialize object
initialize(this, block);

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
