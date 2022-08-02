function this = StateData(block, varargin)
% STATEDATA Constructs a data object to represent state data associated with
% a dynamic Simulink block.
%
% h = ParameterEstimator.StateData('block')
% h = ParameterEstimator.StateData('block', data)
%
% BLOCK is a Simulink block name or handle.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:42:52 $

% Create class instance
this = ParameterEstimator.StateData;

ni = nargin;
if ni == 0
  % Call when reloading object
  return
end

% Initialize object
initialize(this, block);

% Data specified
if (ni == 2)
  update(this, varargin{1});
else
  update(this);
end
