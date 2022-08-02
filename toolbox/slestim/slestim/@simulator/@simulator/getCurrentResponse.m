function DataLog = getCurrentResponse(this)
% GETCURRENTRESPONSE Simulate the model and return output data

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:43:48 $

% Use the estimation model
model      = this.Experiment.Model;
SimOptions = getSettings(this.SimOptions);

% Enable data logging
hOutport = logSetup(this);
set( hOutport, 'TestPoint', 'on', 'DataLogging', 'on' );

% Experiment inputs
InData = object2struct(this);

% Output times
TimePoints = getSimTime(this);

% Simulate model (log written to local SPE_DataLog variable)
ws = warning('off'); lw = lastwarn;
try
  SimOptions = simset( SimOptions, ...
                       'InitialState', this.getCurrentState );
  sim(model, TimePoints, SimOptions, InData{:});
catch
  SPE_DataLog = [];
end
DataLog = SPE_DataLog;
warning(ws), lastwarn(lw)

% Deactivate data logging ports
set( hOutport, 'DataLogging', 'off', 'TestPoint', 'off' );
