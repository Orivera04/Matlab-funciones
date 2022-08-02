function replaceblock(blk,newblk,newblklibrary)
% REPLACEBLOCK  Aerospace Blockset helper function for mask callback.

% blk           -- handle to block who's to be replaced
% newblk        -- new block to replace blk
% newblklibrary -- library where newblk exists 
%
%   Copyright 1990-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/04/06 01:04:17 $

FilterMaskType = get_param(blk,'MaskType');

if ~strcmp(FilterMaskType,newblk)
    pos = get_param(blk,'Position');
    delete_block(blk);
    add_block([ newblklibrary '/' newblk],blk,'Position',pos);
end

return
