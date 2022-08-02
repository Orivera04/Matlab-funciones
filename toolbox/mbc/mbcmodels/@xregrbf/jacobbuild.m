function Blk = jacobbuild(m,sys)
% RBF jacobbuild method adds an evaluation simulink block to
% a simulink implementation of a global rbf model
% Overlaoding required because the Eval block has a second output that is the 
% Jacobian.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:54:53 $

Blk = add_block(['models2/TwoStageJacob/rbfJacob'],[sys,'/rbfJacob']);

% break library link
set_param(Blk,'linkstatus','none');
