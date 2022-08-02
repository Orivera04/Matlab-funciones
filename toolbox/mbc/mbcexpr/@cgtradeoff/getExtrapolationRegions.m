function mask = getExtrapolationRegions(obj)
%GETEXTRAPOLATIONREGIONS Return extrapolation regions for tradeoff tables
%
%  MASK = GETEXTRAPOLATIONREGIONS(OBJ) returns the regions mask that should
%  be applied to the tables in this tradeoff when extrapolating.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:16:09 $ 

mask = logical(obj.fillReg);
