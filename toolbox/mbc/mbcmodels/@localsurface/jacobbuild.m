function Blk = jacobbuild(m,sys)
%JACOBBUILD

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:42:17 $

switch class(m.userdefined)
case 'xregcubic'
    Blk= add_block('models2/LocalModJacob/localSurfaceCubicJacob',[sys,'/localSurfaceCubicJacob']);
case 'xreg3xspline'
    Blk= add_block('models2/LocalModJacob/localSurfaceSplineJacob',[sys,'/localSurfaceSplineJacob']);
end

% break library link
set_param(Blk,'linkstatus','none');