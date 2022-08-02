function update(this, varargin)
% UPDATE Re-initialize the properties
%
% Requires valid Model.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:43:06 $

% REM: Will compile the model.
util   = slcontrol.Utilities;
hModel = getModelHandle(util, this.Model);

% The model associated with this object should be compiled
compiled = isModelCompiled(util, hModel);
if ~compiled
  LocalCompile(hModel.getFullName)
end

% Update all the input data objects.
this.InputData = LocalUpdateInputs( this.InputData, this );

% Update all the output and signal data objects.
isOutport = strcmp( get(this.OutputData, {'PortType'}), 'Outport' );
Outputs = LocalUpdateOutputs( this.OutputData( isOutport), this );
Signals = LocalUpdateSignals( this.OutputData(~isOutport), this );
this.OutputData = [ Outputs; Signals ];

% Terminate if compiled in this file
if ~compiled
  LocalTerminate(hModel.getFullName)
end

% Update all the state data objects
this.StateData = LocalUpdateStates( this.StateData, this );

% Set properties
set( this, varargin{:} );

% ----------------------------------------------------------------------------- %
function LocalCompile(model)
% Try catch to prevent the model from being left in a poorly compiled state.
try
  feval( model, [], [], [], 'compile' );
catch
  fprintf('\nUnable to compile the block diagram ''%s''.\n', model);
  rethrow( lasterror );
end

% ----------------------------------------------------------------------------- %
function LocalTerminate(model)
try
  feval( model, [], [], [], 'term' );
catch
  fprintf('\nUnable to terminate the block diagram ''%s''.\n', model);
  rethrow( lasterror );
end

% ----------------------------------------------------------------------------- %
function hData = LocalUpdateInputs(hData, this)
% Get the names of the current inport blocks
new_Ports = find_system( this.Model, 'SearchDepth', 1, 'BlockType', 'Inport' );

% Check to see if data objects need to be removed or added
if ~isempty(hData)
  % Get the names of the old inport blocks
  old_Ports = get( hData, {'Block'} );
  
  % Find the intersection of the new and old inport blocks
  [int_Ports, new_idx, old_idx] = intersect( new_Ports, old_Ports );
  
  % Find the data objects that should remain
  hData = hData(old_idx);
  
  % Find the new inport blocks that need to be added to the list
  new_Ports = new_Ports( setxor( 1:length(new_Ports), new_idx ) );
end

% Update old data objects
for ct = 1:length(hData)
  hData(ct).update;
end

% Create the data objects for the new inport blocks.
for ct = 1:length(new_Ports)
  hData = [ hData ; ParameterEstimator.SteadyStateData( new_Ports{ct} ) ];
end

% Sort by port number
if ~isempty(hData)
  portnames = get( hData, {'Block'} );
  portnums  = str2double( get_param(portnames, 'Port') );
  [vals, idxs] = sort( portnums );
  hData = hData( idxs );
end

% ----------------------------------------------------------------------------- %
function hData = LocalUpdateOutputs(hData, this)
% Get the names of the current outport blocks
new_Ports = find_system( this.Model, 'SearchDepth', 1, 'BlockType', 'Outport' );

% Check to see if data objects need to be removed or added
if ~isempty(hData)
  % Get the names of the old outport blocks
  old_Ports = get( hData, {'Block'} );
  
  % Find the intersection of the new and old outport blocks
  [int_Ports, new_idx, old_idx] = intersect(new_Ports, old_Ports);
  
  % Find the data objects that should remain
  hData = hData(old_idx);
  
  % Find the new outport blocks that need to be added to the list
  new_Ports = new_Ports( setxor(1:length(new_Ports), new_idx) );
end

% Update old data objects
for ct = 1:length(hData)
  hData(ct).update;
end

% Create the data objects for the new outport blocks.
for ct = 1:length(new_Ports)
  hData = [ hData ; ParameterEstimator.SteadyStateData( new_Ports{ct} ) ];
end

% Sort by port number
if ~isempty(hData)
  portnames = get(hData, {'Block'});
  portnums  = str2double( get_param(portnames, 'Port') );
  [vals, idxs] = sort( portnums );
  hData = hData( idxs );
end

% ----------------------------------------------------------------------------- %
function hData = LocalUpdateSignals(hData, this)
% Get the names of the current outport ports
hPorts = handle( find_system( this.Model, 'FindAll', 'on', ...
                              'Type', 'port', 'PortType', 'outport', ...
                              'TestPoint','on', 'DataLogging', 'on' ) );
new_Ports = get(hPorts, {'Parent'});

% Full names of the new outport ports, made unique by attaching port number.
new_Names = cell( size(new_Ports) );
for ct = 1:length(new_Ports)
  new_Names{ct} = [ new_Ports{ct}, '/', num2str( hPorts(ct).PortNumber ) ];
end

% Check to see if data objects need to be removed or added
if ~isempty(hData)
  % Get the names of the old output ports
  old_Ports = get(hData, {'Block'});

  % Full names of the old outport ports, made unique by attaching port number.
  old_Names = cell( size(old_Ports) );
  for ct = 1:length(old_Ports)
    old_Names{ct} = [ old_Ports{ct}, '/', num2str( hData(ct).PortNumber ) ];
  end

  % Find the intersection of the new and old output ports (wrt full names)
  [int_Ports, new_idx, old_idx] = intersect(new_Names, old_Names);
  
  % Find the data objects that should remain
  hData = hData(old_idx);
  
  % Find the new output ports that need to be added to the list
  new_Ports = new_Ports( setxor( 1:length(new_Ports), new_idx ) );
  hPorts    = hPorts( setxor( 1:length(hPorts), new_idx ) );
end

% Update old data objects
for ct = 1:length(hData)
  hData(ct).update;
end

% Create the data objects for the new outport ports.
for ct = 1:length(new_Ports)
  PortNo = get( hPorts(ct), 'PortNumber');
  hData = [ hData ; ParameterEstimator.SteadyStateData( new_Ports{ct}, PortNo ) ];
end

% Sort by port name
if ~isempty(hData)
  portnames    = get(hData, {'Block'});
  [vals, idxs] = sort( portnames );
  hData = hData( idxs );
end

% ----------------------------------------------------------------------------- %
function hData = LocalUpdateStates(hData, this)
% Get the unique names of the current blocks with states
util = slcontrol.Utilities;
AllStates = getTunableStates(util, this.Model);
AllVals   = evalStates(util, this.Model, {AllStates.Block});
idxN = 1:length(AllStates);

% Check to see if state objects need to be removed or added
if ~isempty(hData)
  % Get the names of the old blocks with states
  oldStates = get( hData, {'Block'} );
  
  % Find the intersection of the new and old blocks with states
  [dummy, inew, iold] = intersect({AllVals.Block}, oldStates);
  
  % Find the state objects that should remain
  hData  = hData(iold);
  
  % Find the blocks with states that need to be added to the list
  idxN = setxor( idxN, inew );
end

% Update the old state objects
for ct = 1:length(hData)
  block = hData(ct).Block;
  idx   = find( strcmp(block, {AllVals.Block}) );
  
  hData(ct).update( AllVals(idx).Value, ...
                    'Ts',     AllVals(idx).Ts, ...
                    'Domain', AllStates(idx).Domain );
end

% Create the state objects for the new blocks with states.
for ct = 1:length(idxN)
  idx = idxN(ct);
  block  = AllVals(idx).Block;
  value  = AllVals(idx).Value;
  
  hData = [ hData ; ParameterEstimator.StateData( block, value ) ];
  hData(end).Ts = AllVals(idx).Ts;
end

% Sort by block name
[dummy, idxs] = sort( get(hData, {'Block'}) );
hData = hData( idxs );
