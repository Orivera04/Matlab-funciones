function [om,ok] = optmgr_raysfromnumber( c, varargin )
%OPTMGR_RAYSFROMNUMBER   Creates an xregoptmgr for CONSTAR objects
%   OPTMGR_RAYSFROMNUMBER(C) is a a nested optim manger (xegoptmgr object) for 
%   the constar object C. This nested optim manger controls the manual settings 
%   for the number of rays to be used by the raty casting algorithm.
%
%   See also OPTMGR, OPTMGR_INTERIOR, OPTMGR_BOUNDARYONLY, OPTMGR_AUTODILATION, 
%   OPTMGR_MANUALDILATION, OPTMGR_RAYSFROMDATA.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 06:57:57 $ 

om = contextimplementation( xregoptmgr, c, @i_raysfromnumber, [], ...
    'Manual', @optmgr_raysfromnumber );

om = AddOption( om, 'nrays', ...
    100, {'int', [1,Inf] }, ...
    'Number of Rays', logical(1) );

ok = 1;
return

%------------------------------------------------------------------------------|
function [c,r,null] = i_raysfromnumber( c, om, varargin )
% Inputs:
%    c       constar object
%    om      option manger
% Outputs:
%    c       constar object
%    r       number of rays
%    null    ignore

null = [];
r = get( om, 'nrays' );

return



%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
