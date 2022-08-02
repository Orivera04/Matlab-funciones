function [om,ok] = optmgr_raysfromdata( c, varargin )
%OPTMGR_RAYSFROMDATA   Creates an xregoptmgr for CONSTAR objects
%   OPTMGR_RAYSFROMDATA(C) is a a nested optim manger (xegoptmgr object) for 
%   the constar object C. This nested optim manger controls the number and 
%   direction of the rays use by the ray casting algorithm. In particuar, this 
%   optim manger specifies that the rays be given by the data directions.
%
%   See also OPTMGR, OPTMGR_INTERIOR, OPTMGR_BOUNDARYONLY, OPTMGR_AUTODILATION, 
%   OPTMGR_MANUALDILATION, OPTMGR_RAYSFROMNUMBER.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 06:57:56 $ 

om = contextimplementation( xregoptmgr, c, @i_raysfromdata, [], ...
    'From data', @optmgr_raysfromdata );
om = setAltMgrs( om, { @optmgr_raysfromdata, @optmgr_raysfromnumber } );


ok = 1;
return

%---------------------------------|--------------------------------------------|
function [c,r,null] = i_raysfromdata( c, om, varargin )
% Inputs:
%    c       constar object
%    om      option manger
% Outputs:
%    c       constar object
%    r       radius
%    null    ignore

null = [];
r = 'Data';

return


%---------------------------------|--------------------------------------------|
% Ruler:
%        1         2         3         4         5         6         7         8
%2345678901234567890123456789012345678901234567890123456789012345678901234567890
%---------------------------------|--------------------------------------------|
% EOF
%---------------------------------|--------------------------------------------|
