function h = copy(this)
% COPY Deep copy the object

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:43:12 $

h = ParameterEstimator.TransientExperiment;

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

% Copy parent properties
h.Model       = this.Model;
h.InitFcn     = this.InitFcn;
h.Description = this.Description;
