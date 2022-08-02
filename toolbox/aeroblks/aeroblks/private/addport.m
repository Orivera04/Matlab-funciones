function addport(blk,porttype,port)
% ADDPORT  Aerospace Blockset helper function for mask callback.

% blk      -- handle to block who's to be replaced
% porttype -- either 'Outport' or 'Inport'
% port     -- port number either a string or numeric
%
%   Copyright 1990-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/04/06 01:04:01 $

if isnumeric(port)
    port = num2str(port);
elseif ~ischar(port)
    error('aeroblks:addport:invalidportnumber','port number is invalid');
end

% Change if not already outport or inport
if ~strcmp(get_param(blk,'BlockType'),porttype)
  pos = get_param(blk,'Position');
  delete_block(blk);   
  add_block(['built-in/' porttype],blk,'Position',pos,'Port',port,'showname','on');
else
  set_param(blk,'Port',port)
end

return
