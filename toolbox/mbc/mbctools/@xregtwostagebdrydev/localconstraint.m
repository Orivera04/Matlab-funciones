function con = localconstraint( bdev, n )
%LOCALCONSTRAINT Local constraint model for a particular sweep.
%
%  CON = LOCALCONSTRAINT(BDEV,N) is the boundary constraint for the N-th
%  sweep.
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:20:34 $ 

if isempty( bdev.LocalParameters ),
    con = [];
else
    params = bdev.LocalParameters(n,:);
    con = getconstraint( bdev );
    con = getlocal( con, params );
end
