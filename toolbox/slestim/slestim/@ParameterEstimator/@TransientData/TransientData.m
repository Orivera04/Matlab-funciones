function this = TransientData(block, varargin)
% TRANSIENTDATA  Constructs a data object to represent time-series data
% associated with a Simulink I/O port or signal.
%
% h = ParameterEstimator.TransientData('block')
% h = ParameterEstimator.TransientData('block', data, time/Ts)
% h = ParameterEstimator.TransientData('block', portnumber)
% h = ParameterEstimator.TransientData('block', portnumber, data, time/Ts)
%
% BLOCK      is a Simulink block name or handle.
% PORTNUMBER is the port number of the block whose signal is logged.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2003/12/22 00:57:37 $

% Create class instance
this = ParameterEstimator.TransientData;

ni = nargin;
if ni == 0
  % Call when reloading object
  return
end

% Port number specified
portNumber = 1;
if (ni == 2) || (ni == 4)
  portNumber = varargin{1};
end

% Initialize object
initialize(this, block, portNumber);

% Initialize Dimensions & public properties
update(this);

% Data & time specified
if (ni == 3) || (ni == 4)
  this.Data = varargin{ni - 2};

  targ = varargin{ni - 1};
  if isscalar(targ)
    this.Ts = targ;       % Sample time
  elseif isvector(targ)
    this.Time = targ(:);  % Time vector
  end
end
