function h = copy(this)
% COPY Deep copy the object

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:37:57 $

h = ParameterEstimatorData.TransientExperiment;

% Copy primitive properties
h.Model = this.Model;

% Deep copy handles
if ~isempty(this.InputData)
  h.InputData = copy(this.InputData);
end

if ~isempty(this.OutputData)
  h.OutputData = copy(this.OutputData);
end

if ~isempty(this.InitialStates)
  h.InitialStates = copy(this.InitialStates);
end
