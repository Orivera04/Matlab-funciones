function h = copy(this)
% COPY Deep copy the object

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:42:10 $

h = ParameterEstimator.Estimation;

% Deep copy handles
for ct = 1:length(this.Experiments)
  h.Experiments = [ h.Experiments; copy(this.Experiments(ct)) ];
end

if ~isempty(this.Parameters)
  h.Parameters = copy(this.Parameters);
end

if ~isempty(this.States)
  h.States = copy(this.States);
end

% Copy primitive properties
h.Model        = this.Model;
h.SimOptions   = copy(this.SimOptions);
h.OptimOptions = copy(this.OptimOptions);
h.EstimInfo    = this.EstimInfo;
h.Description  = this.Description;
h.UserData     = this.UserData;
h.Version      = this.Version;
