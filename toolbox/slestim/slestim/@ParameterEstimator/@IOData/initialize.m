function initialize(this, block, portNumber)
% INITIALIZE Initialize object properties
%
% BLOCK      is a Simulink block name or handle.
% PORTNUMBER is the port number of the block.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:42:39 $

% Get Simulink object corresponding to block
util = slcontrol.Utilities;
h    = getBlockHandle(util, block);

% Set private properties
this.Block      = h.getFullName;
this.PortType   = LocalPortType(this, h.BlockType);
this.PortNumber = LocalPortNumber(this, portNumber);

% ----------------------------------------------------------------------------- %
function PortType = LocalPortType(this, BlockType)
if any( strcmp( BlockType, {'Inport', 'Outport'} ) )
  PortType = BlockType;
else
  PortType = 'Signal';
end

% ----------------------------------------------------------------------------- %
function portNumber = LocalPortNumber(this, portNumber)
ports    = get_param( this.Block, 'Ports' );
nports   = ports(2);  % Number of output ports.
isSignal = strcmp(this.PortType, 'Signal');

if ~isSignal && ( portNumber ~= 1 )
  error( 'Invalid port number for ''%s'' block.', this.Block );
elseif isSignal && ( portNumber > nports )
  error('Simulink block ''%s'' does not have %d output port(s).', ...
        this.Block, portNumber);
end
