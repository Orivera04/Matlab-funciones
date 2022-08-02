function table = getStateData(this, selected)
% GETSTATEDATA Construct state table from data object properties
%
% The output TABLE has two parts:  TABLE(1): cell array

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:38:51 $

% 1: transient, 2: steady-state, 3: frequency-domain
type   = this.ExperimentType;
icdata = this.States{type};

% Return if no data
if isempty(icdata)
  table = {};
  return;
end

icdata = icdata(:,selected);

% Get state table
for ct = 1:length(icdata)
  current = icdata(ct);
  
  fullname = regexprep(current.Block, '\n\r?', ' ');
  slash    = max( findstr(fullname, '/') );
  block    = fullname( slash+1:end );
  
  data(ct,:) = { block, ...
                 current.Value, ...
                 eval(current.Estimated), ...
                 current.InitialGuess, ...
                 current.Minimum, ...
                 current.Maximum, ...
                 current.TypicalValue };
end

table = matlab2java(data);
