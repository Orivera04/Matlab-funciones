function Blk = jacobbuild(m,sys)
% xregusermod jacobbuild method adds an evaluation simulink block to
% a simulink implementation of a global model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:19 $

Blk = add_block(['models2/TwoStageJacob/userModJacob'],[sys,'/userModJacob']);

% break library link
set_param(Blk,'linkstatus','none');

warning('User Model Jacobian block added to simulink system - Please fill this block with the appropriate function');