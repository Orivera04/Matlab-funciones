function DataLog = getCurrentResponseG(this, model, sL, sR)
% GETCURRENTRESPONSEG Simulate the gradient model and return output data

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:43:49 $

% Use the gradient model
SimOptions = getSettings(this.SimOptions);

% Enable data logging
LeftPorts  = logSetup(this, [model '/Left'],  '_L');
RightPorts = logSetup(this, [model,'/Right'], '_R');
AllPorts = [ LeftPorts; RightPorts ];
set( AllPorts, 'TestPoint', 'on', 'DataLogging', 'on' );

% Experiment inputs
InData = object2struct(this);

% Output times
TimePoints = getSimTime(this);

% Simulate model (log written to local SPE_GradLog variable)
ws = warning('off'); lw = lastwarn;
try
  SimOptions = simset( SimOptions, ...
                       'InitialState', this.getCurrentStateG(model, sL, sR) );
  sim(model, TimePoints, SimOptions, InData{:});
catch
  SPE_GradLog = [];
end
DataLog = SPE_GradLog;
warning(ws), lastwarn(lw)

% Deactivate data logging ports
set( AllPorts, 'DataLogging', 'off', 'TestPoint', 'off' );
