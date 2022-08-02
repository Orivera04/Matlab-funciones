function [om,ok] = optmgr_boundaryonly( c, varargin )
%OPTMGR_BOUNDARYONLY   Creates an xregoptmgr for CONSTAR objects
%   OPTMGR_BOUNDARYONLY(C) is a a nested optim manger (xegoptmgr object) for 
%   the constar object C. This nested optim manger controls the case when all 
%   of the supplied data points are on the boundary.
%
%   See also OPTMGR, OPTMGR_INTERIOR, OPTMGR_AUTODILATION, 
%   OPTMGR_MANUALDILATION, OPTMGR_RAYSFROMDATA, OPTMGR_RAYSFROMNUMBER.


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 06:57:53 $ 

om = contextimplementation( xregoptmgr, c, @i_boundaryonly, [], ...
    'Boundary Only', @optmgr_boundaryonly );

om = AddOption( om, 'ActualDilationRadius', ...
    -1, {'numeric', [-Inf,Inf]}, '', 0 );

ok = 1;
return

%---------------------------------|--------------------------------------------|
function [c,I,R] = i_boundaryonly( c, om, X, center, varargin )
% Inputs:
%    c       constar object
%    om      option manger
%    X       data points
%    center  center of data
% Outputs:
% Outputs:
%    c       constar object
%    I       boundary point indices
%    R       dilation radius

I = (1:size(X,1))';
R = -1;

return

%---------------------------------|--------------------------------------------|
% EOF
%---------------------------------|--------------------------------------------|
