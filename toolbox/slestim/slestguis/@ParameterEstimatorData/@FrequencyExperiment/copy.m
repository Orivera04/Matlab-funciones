function h = copy(this)
% COPY Deep copy the object

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:37:37 $

h = ParameterEstimatorData.FrequencyExperiment;

% Copy primitive properties
h.Model = this.Model;

% Deep copy handles
if ~isempty(this.InputData)
  h.InputData = copy(this.InputData);
end

if ~isempty(this.OutputData)
  h.OutputData = copy(this.OutputData);
end

if ~isempty(this.StateData)
  h.StateData = copy(this.StateData);
end

if ~isempty(this.OperatingPoint)
  h.OperatingPoint = copy(this.OperatingPoint);
end
