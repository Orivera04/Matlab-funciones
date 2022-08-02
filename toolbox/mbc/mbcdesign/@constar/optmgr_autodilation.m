function [om,ok] = optmgr_autodilation( c, varargin )
%OPTMGR_AUTODILATION   Creates an xregoptmgr for CONSTAR objects
%   OPTMGR_AUTODILATION(C) is a a nested optim manger (xegoptmgr object) for the 
%   constar object C. This nested optim manger controls the dilation radius for 
%   the data points when the boundary nodes need to be found.
%
%   See also OPTMGR, OPTMGR_INTERIOR, OPTMGR_BOUNDARYONLY, 
%   OPTMGR_MANUALDILATION, OPTMGR_RAYSFROMDATA, OPTMGR_RAYSFROMNUMBER.


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 06:57:52 $ 

om = contextimplementation( xregoptmgr, c, @i_autodilation, [], ...
    'Auto', @optmgr_autodilation );
om = setAltMgrs( om, { @optmgr_autodilation, @optmgr_manualdilation } );

ok = 1;
return

%---------------------------------|--------------------------------------------|
function [c,r,null] = i_autodilation( c, om, varargin )
% Inputs:
%    c       constar object
%    om      option manger
% Outputs:
%    c       constar object
%    r       radius
%    null    ignore

null = [];
r = 'Auto';

return

%---------------------------------|--------------------------------------------|
% EOF
%---------------------------------|--------------------------------------------|
