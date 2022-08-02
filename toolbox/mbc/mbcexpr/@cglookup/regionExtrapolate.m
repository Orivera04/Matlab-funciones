function [obj, OK, nRegsMissed] = regionExtrapolate(obj, method)
%REGIONEXTRAPOLATE Perform full region-based extrapolation
%
%  [OBJ, OK, REGS_MISSED] = REGIONEXTRAPOLATE(OBJ, METHOD) executes the
%  full region-based extrapolation algorithm.  This works by identifying
%  each region and performing an extrapolation within each of these
%  regions.  The remaining cells are then extrapolated using a mask which
%  is a combination of the overall extrapolation mask and the regions that
%  have been successfully extrapolated.  REGS_MISSED is a count of the
%  number of regions which were not individually extrapolated because they
%  contained no extrapolation mask cells.  These regions will have been
%  extrapolated as part of the final "remaining region" instead.  See
%  CGLOOKUP/EXTRAPOLATE for an explanation of the METHOD argument.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:12:04 $ 

nRegsMissed = 0;
OK = false;

if nargin<2
    method = 'auto';
end

mask = getExtrapolationMask(obj);
if any(mask(:))
    regionMask = getExtrapolationRegions(obj);
    if any(regionMask(:))
        regs = pDecomposeRegions(regionMask);
    else
        % With no regions the rest of the code will boil down to a standard
        % extrapolation
        regs = {};
    end
    
    for n = 1:length(regs)
        thisMask = mask & regs{n};
        if any(thisMask(:))
            obj = pExtrapolate(obj, method, thisMask, regs{n});
        else
            % Remove this region from the overall region mask
            regionMask(regs{n}) = false;
            nRegsMissed = nRegsMissed + 1;
        end
    end

    % Perform the final extrapolation
    obj = pExtrapolate(obj, method, mask | regionMask);
    OK = true;
end
