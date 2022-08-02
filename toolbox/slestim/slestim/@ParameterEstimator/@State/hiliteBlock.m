function hiliteBlock(this)
% HILITEBLOCK Highlights the block represented by this object.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2003/12/22 00:57:12 $

block  = this.Block;

try
  parent = get_param(block, 'Parent');
  open_system( parent )
  set_param( block, 'HiliteAncestors', 'default' )
catch
  error( 'Cannot locate Simulink block ''%s''.\n', block )
end
