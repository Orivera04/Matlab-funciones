function obj = pSetExtrapolationMask(obj, mask)
%PSETEXTRAPOLATIONMASK Set new extrapolation mask
%
%  OBJ = PSETEXTRAPOLATIONMASK(OBJ, MASK) sets a new extrapolation mask for
%  the table.  The mask must be a logical matrix the same size as the
%  table's values matrix or an empty logical matrix.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:12:02 $ 

if isempty(mask)
    obj.ExtrapolationMask = true(0);
else
    if all(size(mask)==size(get(obj, 'values')))
        if ~any(mask(:))
            % Compress empty masks down to an empty matrix.  The full
            % matrix is restored on demand by getExtrapolationMask.
            obj.ExtrapolationMask = true(0);
        else
            obj.ExtrapolationMask = logical(mask);
        end
    else
        error('mbc:cglookup:InvalidSize', ...
            'Mask matrix must be the same size as the table value matrix.');
    end
end
