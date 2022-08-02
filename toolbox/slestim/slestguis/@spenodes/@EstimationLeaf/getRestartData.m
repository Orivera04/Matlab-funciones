function table = getRestartData(this, info)
% GETOBJECTDATA  Get cell array of Matlab types corresponding to data for
% Simulink model parameter
%
% The input INFO: INFO(1): data type, e.g., 'parameters'
%
% The output TABLE has two parts:  TABLE(1): table
%                                  TABLE(2): indices to each block of data

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:38:50 $

type = char( info(1) );

switch type
case 'parameters'
  % Parameters
  data  = updateParData(this.Parameters);
case 'restarts'
  % Restarts
  data  = updateRestartsData(this.Parameters);
end
table = matlab2java(data);

% ---------------------------------------------------------------------------- %
% Get parameter table
function data = updateParData(pardata)
data = {};
for ct = 1:length(pardata)
  h = pardata(ct);
  data(ct,:) = { h.Name, h.BestValue, all(h.Estimated(:)), ...
                 h.InitialValue, h.Minimum, h.Maximum, h.Scaling };
end

% ---------------------------------------------------------------------------- %
% Get restarts table
function data = updateRestartsData(pardata)
data = {};
for ct = 1:length(pardata)
  h = pardata(ct);
  data(ct,:) = {h.Name, false, 1};
end
