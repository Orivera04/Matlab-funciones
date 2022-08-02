function blk= slRecon(m,sname)
% LOGISTIC/SLRECON -  adds the appropriate reconstruct block

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:42:37 $

blk= add_block(['Models2/Reconstruct/linearRecon'],...
   [sname,'/Reconstruct']);

% break library link
set_param(blk,'linkstatus','none');