function obj = clearExtrapolationMask(obj)
%CLEAREXTRAPOLATIONMASK Remove all cells from extrapolation mask
%
%  OBJ = CLEAREXTRAPOLATIONMASK(OBJ) removes all of the table cells from
%  the extrapolation mask.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:10:06 $ 

obj = pSetExtrapolationMask(obj, []);