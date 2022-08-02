function data = object2struct(this)
% OBJECT2STRUCT Create a cell array of structures corresponding to data.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/19 01:33:33 $

% Get the names of the current inport blocks
model = this.Experiment.Model;
InPorts = find_system( model, 'SearchDepth', 1, 'BlockType', 'Inport' );

data = {};
InData = this.Experiment.InputData;

% Construct the I/O signals
for ct = 1:length(InPorts)
  blk = InPorts{ct};
  idx = find( strcmp( blk, get(InData, {'Block'}) ) );
  if length(idx) > 1
    error('Multiple data sets cannot be assigned to input port %s.', Inport{ct});
  end
  
  if ~isempty(idx)
    % Get input data from experiment
    [time, values] = LocalHandleNaNs( InData(idx) );
    dims = InData(idx).Dimensions;
  else
    % No experimental data for this port
    time   = [];
    values = [];
    dims = evalin('base', get_param( blk, 'PortDimensions'), '1');
    
    % Top level input ports cannot inherit port dimensions
    if dims == -1
      dims = 1;
    end
  end
  
  % Set data structure
  data{ct}.time = time;
  data{ct}.signals.values     = values;
  data{ct}.signals.dimensions = dims;
  data{ct}.signals.label      = '';
  data{ct}.signals.blockName  = blk;
  
  % Initialize to zero if no data is specified
  if isempty(time) || isempty(values)
    data{ct}.time = 0;
    if length(dims) > 1
      data{ct}.signals.values = zeros(dims);
    else
      data{ct}.signals.values = zeros([1 dims]);
    end
  end
end

% ----------------------------------------------------------------------------- %
function [time, values] = LocalHandleNaNs(h)
time   = h.Time;
values = h.Data;

nanIdxs = find( isnan(values) );

if ~isempty(nanIdxs)
  % Remove NaNs
  if length(h.Dimensions) < 2
    rowIdxs = unique(nanIdxs - floor((nanIdxs-1) / length(time)) * length(time));
    values(rowIdxs, :) = [];
  else
    rowIdxs = unique( ceil( nanIdxs / prod(h.Dimensions) ) );
    values  = removePages(values, rowIdxs);
  end
  
  % Adjust time vector
  time(rowIdxs) = [];
end

% ----------------------------------------------------------------------------- %
function x = removePages(x, idxs)
% Removes pages "idxs" from the last dimension of "x"
% IDXS must be sorted in ascending order.
dims  = ndims(x);
str(1:dims) = {':'};

for ct = length(idxs):-1:1
  str{dims}   = idxs(ct);
  x( str{:} ) = [];
end
