function obj = setTolerance(obj, tol)
%SETTOLERANCE Set the tolerance for the switch factors
%
%  OBJ = SETTOLERANCE(OBJ, TOL) sets the tolerance on the switch factors.
%  The tolerance is the relative amount that an input can miss a switched
%  model by and still be counted as hitting it.  TOL is a vector of values
%  the same length as the number of switch factors.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:53:52 $ 

if length(tol)==length(obj.Tolerance)
    obj.Tolerance = tol;
else 
    error('mbc:xregmodswitch:InvalidArgument', ...
        'Length of tolerance vector must be equal to the number of switched inputs');
end
