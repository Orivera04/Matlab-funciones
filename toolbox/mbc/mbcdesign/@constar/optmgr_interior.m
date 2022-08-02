function [om,ok] = optmgr_interior( c, varargin )
%OPTMGR_INTERIOR   Creates an xregoptmgr for CONSTAR objects
%   OPTMGR_INTERIOR(C) is a a nested optim manger (xegoptmgr object) for the 
%   constar object C. This nested optim manger controls the case when not all 
%   of the supplied data points are on the boundary of the region and those 
%   that are on the boundary need to be found.
%
%   See also OPTMGR, OPTMGR_BOUNDARYONLY, OPTMGR_AUTODILATION, 
%   OPTMGR_MANUALDILATION, OPTMGR_RAYSFROMDATA, OPTMGR_RAYSFROMNUMBER.


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 06:57:54 $ 

om = contextimplementation( xregoptmgr, c, @i_interior, [], ...
    'Interior', @optmgr_interior );
om = setAltMgrs( om, { @optmgr_interior, @optmgr_boundaryonly } );

om = AddOption( om, 'DilationRadius', ...
    optmgr_autodilation(c), 'xregoptmgr', 'Dilation Radius' );
om = AddOption( om, 'RayCasting', ...
    optmgr_raysfromdata(c), 'xregoptmgr', 'Ray Casting' );

om = AddOption( om, 'ActualDilationRadius', ...
    -1, {'numeric', [-Inf,Inf]}, '', 0 );

ok = 1;
return

%---------------------------------|--------------------------------------------|
function [c,I,R] = i_interior( c, om, X, center, varargin )
% Inputs:
%    c       constar object
%    om      option manger
%    X       data points
%    center  center of data
% Outputs:
%    c       constar object
%    I       boundary point indices
%    R       dilation radius

dilationradius = get( om, 'DilationRadius' );
[c, radius] = run( dilationradius, c, [] );
raycasting = get( om, 'RayCasting' );
[c, nrays] = run( raycasting, c, [] );
[I,R] = ray_casting( X, radius, nrays, center );
 
I = I';
 
return

%---------------------------------|--------------------------------------------|
% EOF
%---------------------------------|--------------------------------------------|
