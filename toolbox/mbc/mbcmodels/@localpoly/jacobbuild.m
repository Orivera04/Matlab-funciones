function Blk = jacobbuild(m,sys)
% quadspline evalbuild method adds an evaluation simulink block to
% a simulink implementation of a global model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:40:29 $

Blk= add_block('models2/LocalModJacob/PolynomJacob',[sys,'/PolynomJacob']);

% break library link
set_param(Blk,'linkstatus','none');