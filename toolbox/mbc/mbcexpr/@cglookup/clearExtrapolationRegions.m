function obj = clearExtrapolationRegions(obj)
%CLEAREXTRAPOLATIONREGIONS  Remove all cells from extrapolation regions mask
%
%  OBJ = CLEAREXTRAPOLATIONREGIONS(OBJ) removes all of the table cells from
%  the extrapolation regions mask.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:10:07 $ 

obj = pSetExtrapolationRegions(obj, []);