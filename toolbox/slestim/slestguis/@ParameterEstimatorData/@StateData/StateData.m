function this = StateData(h)
% STATEDATA Constructor
%
% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:37:40 $

% Create class instance
this = ParameterEstimatorData.StateData;

ni = nargin;
if ni == 0
  % Call when reloading object
  return
end

% In case Dimensions is a scalar.
sizes = [prod(h.Dimensions) 1];

% Initialize
this.Block      = h.Block;
this.Dimensions = h.Dimensions;

this.Data       = repmat({' '}, sizes);
this.DataSrc    = repmat({''}, sizes);
this.DataVal    = cell(sizes);

this.Ts          = mat2str(h.Ts, 5);
this.Domain      = h.Domain;
this.Description = h.Description;

this.Length      = repmat({'-'}, sizes);
