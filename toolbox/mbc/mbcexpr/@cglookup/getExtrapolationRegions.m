function mask = getExtrapolationRegions(obj)
%GETEXTRAPOLATIONREGIONS Return extrapolation regions for table
%
%  MASK = GETEXTRAPOLATIONREGIONS(OBJ) returns a logical mask the same size
%  as the table data that indicates which cells have been marked as being
%  part of a "region" for the purposes of performing an extrapolation.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:10:17 $ 

if isempty(obj.ExtrapolationRegions)
    mask = false(size(get(obj, 'values')));
else
    mask = obj.ExtrapolationRegions;
    Vsz = size(get(obj, 'values'));
    if ~all(size(mask)==Vsz)
        mask = false(Vsz);
    end
end
