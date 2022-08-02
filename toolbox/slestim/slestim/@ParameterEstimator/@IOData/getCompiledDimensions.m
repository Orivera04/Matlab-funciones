function dimensions = getCompiledDimensions(this)
% GETCOMPILEDDIMENSIONS Get signal dimensions from the compiled model.
%
% Requires valid Block, PortType, and PortNumber properties.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:42:37 $

hBlock = get_param(this.Block, 'Object');
util   = slcontrol.Utilities;
hModel = getModelHandleFromBlock(util, hBlock);

% Get port handle
switch this.PortType
case 'Outport'
  hPort = handle( hBlock.PortHandles.Inport(  this.PortNumber ) );
case { 'Inport', 'Signal' }
  hPort = handle( hBlock.PortHandles.Outport( this.PortNumber ) );
end

% The model associated with this object should be compiled
compiled = isModelCompiled(util, hModel);
if ~compiled
  LocalCompile(hModel.getFullName)
end

% Get compiled port info
dimensions = hPort.CompiledPortDimensions(2:end);

% Terminate if compiled in this file
if ~compiled
  LocalTerminate(hModel.getFullName)
end

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
