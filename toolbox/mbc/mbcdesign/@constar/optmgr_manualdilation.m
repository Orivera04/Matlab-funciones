function [om,ok] = optmgr_manualdilation( c, varargin )
%OPTMGR_MANUALDILATION   Creates an xregoptmgr for CONSTAR objects
%   OPTMGR_MANUALDILATION(C) is a a nested optim manger (xegoptmgr object) for 
%   the constar object C. This nested optim manger controls the manual settings
%   for the dilation radius of data points for in the boundary determination.
%
%   See also OPTMGR, OPTMGR_INTERIOR, OPTMGR_BOUNDARYONLY, OPTMGR_AUTODILATION, 
%   OPTMGR_RAYSFROMDATA, OPTMGR_RAYSFROMNUMBER.


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 06:57:55 $ 

om = contextimplementation( xregoptmgr, c, @i_manualdilation, [], ...
    'Manual', @optmgr_manualdilation );

om = AddOption( om, 'radius', ...
    1.0, {'numeric', [0,Inf] }, ...
    'Radius', logical(1) );

ok = 1;
return

%---------------------------------|--------------------------------------------|
function [c,r,null] = i_manualdilation( c, om, varargin )
% Inputs:
%    c       constar object
%    om      option manger
% Outputs:
%    c       constar object
%    r       radius
%    null    ignore

null = [];
r = get( om, 'radius' );

return

%---------------------------------|--------------------------------------------|
% Ruler:
%        1         2         3         4         5         6         7         8
%2345678901234567890123456789012345678901234567890123456789012345678901234567890
%---------------------------------|--------------------------------------------|
% EOF
%---------------------------------|--------------------------------------------|
