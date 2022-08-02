function [obj, OK] = extrapolate(obj, method)
%EXTRAPOLATE Perform standard extrapolation on table
%
%  [OBJ, OK] = EXTRAPOLATE(OBJ, METHOD) extrapolates new values for all
%  unlocked table cells using the cells marked in the extrapolation mask as
%  the trusted ones.  METHOD can be 'linear', 'rbf' or 'auto'.  If METHOD
%  is omitted then the default is 'auto', which will decide on the
%  extrapolation method to use based on the shape of the area being
%  extrapolated.  If you attempt to force 'rbf' then you may get errors in
%  cases where it is not supported.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:10:12 $ 

if nargin<2
    method = 'auto';
end
mask = getExtrapolationMask(obj);
if ~any(mask(:))
    OK = false;
else
    obj = pExtrapolate(obj, method, mask);
    OK = true;
end
