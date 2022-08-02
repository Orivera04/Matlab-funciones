function mask = getExtrapolationMask(obj)
%GETEXTRAPOLATIONMASK Return extrapolation mask for tradeoff tables
%
%  MASK = GETEXTRAPOLATIONMASK(OBJ) returns the mask that should be applied
%  to the tables in this tradeoff when extrapolating.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:16:08 $ 

mask = logical(obj.fillMask);
