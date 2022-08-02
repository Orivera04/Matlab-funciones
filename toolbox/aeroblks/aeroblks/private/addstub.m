function addstub(blk,stubtype)
% ADDSTUB  Aerospace Blockset helper function for mask callback.

% blk      -- handle to block who's to be replaced
% stubtype -- either 'Terminator' or 'Ground'
%
%   Copyright 1990-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/04/06 01:04:02 $

% Change if not already terminator or ground
if ~strcmp(get_param(blk,'BlockType'),stubtype)
  pos = get_param(blk,'Position');
  delete_block(blk);
  add_block(['built-in/' stubtype],blk,'Position',pos,'showname','off');
end

return
