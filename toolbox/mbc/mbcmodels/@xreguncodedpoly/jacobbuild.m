function Blk = jacobbuild(m,sys)
% JACOBBUILD overloaded to insert a cubic jacob block

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 08:00:24 $

Blk = add_block(['models2/TwoStageJacob/xregcubicJacob'],[sys,'/xregcubicJacob']);

% break library link
set_param(Blk,'linkstatus','none');