function setEstimInfo(this, NewInfo, varargin)
% SETESTIMINFO Updates the estimation results

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:42:22 $

EstimInfo = this.EstimInfo;

if isempty(varargin)
  EstimInfo = NewInfo;
elseif strcmp(varargin{1}, 'iter')
  EstimInfo.Cost      = [EstimInfo.Cost;       NewInfo.Cost];
  EstimInfo.FCount    = [EstimInfo.FCount;     NewInfo.FCount];
  EstimInfo.FirstOrd  = [EstimInfo.FirstOrd;   NewInfo.FirstOrd];
  EstimInfo.Gradient  = [EstimInfo.Gradient;   NewInfo.Gradient];
  EstimInfo.Iteration = [EstimInfo.Iteration;  NewInfo.Iteration];
  EstimInfo.Procedure = [EstimInfo.Procedure; {NewInfo.Procedure}];
  EstimInfo.StepSize  = [EstimInfo.StepSize;   NewInfo.StepSize];
  EstimInfo.Values    = [EstimInfo.Values;     NewInfo.Values];
end

this.EstimInfo = EstimInfo;
