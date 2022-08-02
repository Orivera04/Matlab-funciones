function this = FrequencyData(h)
% FREQUENCYDATA Constructor
%
% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:37:32 $

% Create class instance
this = ParameterEstimatorData.FrequencyData;

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

this.Frequency    = ' '; 
this.FrequencySrc = '';
this.FrequencyVal = [];

this.Weight     = repmat({'1'},   sizes);
this.Length     = repmat({'-/-'}, sizes);
