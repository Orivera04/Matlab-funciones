function table = getParameterData(this)
% GETPARAMETERDATA  Construct parameter table from data object properties
%
% The output TABLE has two parts:  TABLE(1): cell array

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:38:48 $

pardata = this.Parameters;

% Return if no data
if isempty(pardata)
  table = {};
  return;
end

% Get parameter table
for ct = 1:length(pardata)
  current = pardata(ct);
  data(ct,:) = { current.Name, ...
                 current.Value, ...
                 eval(current.Estimated), ...
                 current.InitialGuess, ...
                 current.Minimum, ...
                 current.Maximum, ...
                 current.TypicalValue };
end

table = matlab2java(data);
