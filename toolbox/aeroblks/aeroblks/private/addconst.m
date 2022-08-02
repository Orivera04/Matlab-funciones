function addconst(blk,valuestr)
% ADDCONST  Aerospace Blockset helper function for mask callback.

% blk      -- handle to block who's to be replaced
% valueste -- Value to be used in constant block
%
%   Copyright 1990-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/04/06 01:04:00 $

% Change if not already constant
if isnumeric(valuestr)
    valuestr = num2str(valuestr);
elseif ~ischar(valuestr)
    error('aeroblks:addconst:invalidvalue','constant value is invalid');
end

if ~strcmp(get_param(blk,'blocktype'),'Constant')
    pos = get_param(blk,'Position');
    delete_block(blk);
    add_block('built-in/Constant',blk,'Position',pos,'Value',valuestr,'OutDataTypeMode','Inherit via back propagation');
else
    set_param(blk,'Value',valuestr)
end

return
