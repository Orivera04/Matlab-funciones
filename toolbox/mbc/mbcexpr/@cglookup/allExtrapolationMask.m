function ret = allExtrapolationMask(obj, varargin)
%ALLEXTRAPOLATIONMASK Check whether all cells are in the extrapolation mask
%
%  IN_MASK = ALLEXTRAPOLATIONMASK(OBJ) returns true if all table cells are
%  marked as being in the extrapolation mask.
%
%  IN_MASK = ALLEXTRAPOLATIONMASK(OBJ, ROW, COL) where ROW and COL are
%  scalars checks whether the cell at (ROW, COL) is in the extrapolation
%  mask.
%
%  IN_MASK = ALLEXTRAPOLATIONMASK(OBJ, ROWRANGE, COLRANGE) where ROWRANGE
%  and COLRANGE are (1-by-2) vectors defining min and max bounds of a
%  rectangular region in the mask checks whether all cells in the defined
%  region are in the extrapolation mask.  
%
%  IN_MASK = ALLEXTRAPOLATIONMASK(OBJ, DIM1, DIM2, ..., DIMn) where DIMn is
%  a scalar or range for each input axis of the table checks for cells in
%  the mask of a multi-dimensional table.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:09:58 $ 

% Can shortcut if the ExtrapolationMask field is empty (== all false)
ret = ~isempty(obj.ExtrapolationMask);
if ret
    mask = getExtrapolationMask(obj);
    if nargin==1
        ret = all(mask(:));
    else
        if isscalar(varargin{1})
            ret = mask(varargin{:});
        else
            S = substruct('()', cell(1, length(varargin)));
            for m = 1:length(varargin)
                S.subs{m} = varargin{m}(1):varargin{m}(2);
            end
            sub_mask = subsref(mask, S);
            ret = all(sub_mask(:));
        end
    end
end
    