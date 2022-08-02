function this = FrequencyData(block, varargin)
% FREQUENCYDATA Constructs a data object to represent frequency-domain data
% associated with a Simulink I/O port or signal.
%
% h = ParameterEstimator.FrequencyData('block')
% h = ParameterEstimator.FrequencyData('block', data, frequency/Fs)
% h = ParameterEstimator.FrequencyData('block', portnumber)
% h = ParameterEstimator.FrequencyData('block', portnumber, data, frequency,Fs)
%
% BLOCK      is a Simulink block name or handle.
% PORTNUMBER is the port number of the block whose signal is logged.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:42:27 $

% Create class instance
this = ParameterEstimator.FrequencyData;

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

% Data & frequency specified
if (ni == 3) || (ni == 4)
  this.Data = varargin{ni - 2};

  farg = varargin{ni - 1};
  if isscalar(farg)
    this.Fs = farg;            % Sample frequency
  elseif isvector(farg)
    this.Frequency = farg(:);  % Frequency vector
  end
end
