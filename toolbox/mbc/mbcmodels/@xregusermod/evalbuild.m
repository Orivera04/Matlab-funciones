function Blk = evalbuild(m,sys)
% xregusermod evalbuild method adds an evaluation simulink block to
% a simulink implementation of a global usermodel

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:05 $

try
    Blk= feval(m.funcName,m,'evalbuild',sys);
catch
    Blk = add_block('models2/TwoStage/userModEval',[sys,'/userModEval']);
    
    % break library link
    set_param(Blk,'linkstatus','none');
    
    warning('User Model block added to simulink system - Please fill this block with the appropriate function');
    
end