function this = SteadyStateData(block, varargin)
% STEADYSTATEDATA  Constructs a data object to represent steady-state data
% associated with a Simulink I/O port or signal.
%
% h = ParameterEstimator.SteadyStateData('block')
% h = ParameterEstimator.SteadyStateData('block', data)
% h = ParameterEstimator.SteadyStateData('block', portnumber)
% h = ParameterEstimator.SteadyStateData('block', portnumber, data)
%
% BLOCK is a Simulink block name or handle.
% PORTNUMBER is the output port number of the block whose signal is logged.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2003/12/22 00:57:25 $

% Create class instance
this = ParameterEstimator.SteadyStateData;

ni = nargin;
if ni == 0
  % Call when reloading object
  return
end

% Get number of relevant ports
nports = LocalNumPorts(this, block);

% Port number specified
% For ni == 2, the second argument is the port number if there is more than
% one port.
portNumber = 1;
if ( (ni == 2) && (nports > 1) ) || (ni == 3)
  portNumber = varargin{1};
end

% Initialize object
this.initialize(block, portNumber);

% Initialize Dimensions & public properties
update(this);

% Data specified
% For ni == 2, the second argument is the data if there is only one port.
if ( (ni == 2) && (nports == 1) ) || (ni == 3)
  this.Data = varargin{ni - 1};
end

% ----------------------------------------------------------------------------- %
function nports = LocalNumPorts(this, block)
util = slcontrol.Utilities;
h    = getBlockHandle(util, block);

if strcmp(h.BlockType, 'Outport')
  nports = h.Ports(1);
else
  nports = h.Ports(2);
end
