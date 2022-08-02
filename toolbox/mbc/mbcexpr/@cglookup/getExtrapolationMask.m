function mask = getExtrapolationMask(obj)
%GETEXTRAPOLATIONMASK Return extrapolation mask for table
%
%  MASK = GETEXTRAPOLATIONMASK(OBJ) returns a logical mask the same size as
%  the table data that indicates which cells have been selected as
%  "trusted" values for the purposes of performing an extrapolation.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:10:16 $ 

if isempty(obj.ExtrapolationMask)
    mask = false(size(get(obj, 'values')));
else
    mask = obj.ExtrapolationMask;
    Vsz = size(get(obj, 'values'));
    if ~all(size(mask)==Vsz)
        mask = false(Vsz);
    end
end
