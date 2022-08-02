function obj = pSetExtrapolationRegions(obj, mask)
%PSETEXTRAPOLATIONREGIONS Set new extrapolation regions mask
%
%  OBJ = PSETEXTRAPOLATIONREGIONS(OBJ, MASK) sets a new regions mask for
%  the table.  The mask must be a logical matrix the same size as the
%  table's values matrix or an empty logical matrix.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:12:03 $ 

if isempty(mask)
    obj.ExtrapolationRegions = true(0);
else
    if all(size(mask)==size(get(obj, 'values')))
        if ~any(mask(:))
            % Compress empty masks down to an empty matrix.  The full
            % matrix is restored on demand by getExtrapolationRegions.
            obj.ExtrapolationRegions = true(0);
        else
            obj.ExtrapolationRegions = logical(mask);
        end
    else
        error('mbc:cglookup:InvalidSize', ...
            'Regions mask matrix must be the same size as the table value matrix.');
    end
end