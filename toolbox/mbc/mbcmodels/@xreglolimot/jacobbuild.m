function Blk = jacobbuild(m,sys)
% RBF jacobbuild method adds an evaluation simulink block to
% a simulink implementation of a global rbf model
% Overlaoding required because the Eval block has a second output that is the 
% Jacobian.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.6.1 $  $Date: 2004/02/09 07:50:45 $

load_system('models2');

Blk = add_block(['models2/TwoStageJacob/lollimotJacob'],[sys,'/lollimotJacob']);

% break library link
set_param(Blk,'linkstatus','none');

%% close_system('models2');
