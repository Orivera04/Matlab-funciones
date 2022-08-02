function this = TransientExperiment(h)
% TRANSIENTEXPERIMENT Constructor

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:37:56 $

% Create class instance
this = ParameterEstimatorData.TransientExperiment;

ni = nargin;
if ni == 0
  % Call when reloading object
  return
end

% Initialize
this.Model         = h.Model;
this.InputData     = LocalSetData( h.InputData );
this.OutputData    = LocalSetData( h.OutputData );
this.InitialStates = LocalSetStates( h.InitialStates );

% ----------------------------------------------------------------------------- %
function newdata = LocalSetData(hData)
% Create i/o data
newdata = [];
for ct = 1:length( hData )
  newdata = [ newdata; ParameterEstimatorData.TransientData( hData(ct) ) ];
end

% ----------------------------------------------------------------------------- %
function newdata = LocalSetStates(hData)
% Create state data
newdata = [];
for ct = 1:length( hData )
  newdata = [ newdata; ParameterEstimatorData.StateData( hData(ct) ) ];
end
