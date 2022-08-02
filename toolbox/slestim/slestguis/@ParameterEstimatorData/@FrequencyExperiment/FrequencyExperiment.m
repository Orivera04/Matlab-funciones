function this = FrequencyExperiment(h)
% FREQUENCYEXPERIMENT Constructor

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:37:36 $

% Create class instance
this = ParameterEstimatorData.FrequencyExperiment;

ni = nargin;
if ni == 0
  % Call when reloading object
  return
end

% Initialize
this.Model      = h.Model;
this.InputData  = LocalSetInputData( h.InputData );
this.OutputData = LocalSetOutputData( h.OutputData );
this.StateData  = LocalSetStates( h.StateData );

% ----------------------------------------------------------------------------- %
function newdata = LocalSetInputData(hData)
% Create i/o data
newdata = [];
for ct = 1:length( hData )
  newdata = [ newdata; ParameterEstimatorData.FrequencyData( hData(ct) ) ];
end

% ----------------------------------------------------------------------------- %
function newdata = LocalSetOutputData(hData)
% Create i/o data
newdata = [];
for ct = 1:length( hData )
  newdata = [ newdata; ParameterEstimatorData.FrequencyData( hData(ct) ) ];
end

% ----------------------------------------------------------------------------- %
function newdata = LocalSetStates(hData)
% Create state data
newdata = [];
for ct = 1:length( hData )
  newdata = [ newdata; ParameterEstimatorData.StateData( hData(ct) ) ];
end
