function set_mask_help(blk,str)
% SET_MASK_HELP  Aerospace Blockset helper function for mask callback.

% blk -- handle to block whos web help should be updated
% str -- new string for the web help
%
%   Copyright 1990-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/04/06 01:04:18 $


helpstr = get_param(blk,'MaskHelp');

if ~strcmp(helpstr,str)
    set_param(blk,'MaskHelp',str)
end

return
