function Blk = evalbuild(m,sys)
% evalbuild method adds an evaluation simulink block to
% a simulink implementation of a model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:42:04 $

switch class(m.userdefined)
case 'xregcubic'
    Blk= add_block('models2/LocalMod/localSurfaceCubicEval',[sys,'/localSurfaceCubicEval']);
case 'xreg3xspline'
    Blk= add_block('models2/LocalMod/localSurfaceSplineEval',[sys,'/localSurfaceSplineEval']);
end

% break library link
set_param(Blk,'linkstatus','none');