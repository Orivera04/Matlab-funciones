function obj = addToExtrapolationMask(obj, varargin)
%ADDTOEXTRAPOLATIONMASK Add table cells to the extrapolation mask
%
%  OBJ = ADDTOEXTRAPOLATIONMASK(OBJ, ROW, COL) adds the specified table
%  cell to the extrapolation mask.  ROW and COL can be vectors of the same
%  length, N, in which case they will specify N cells to add to the mask.
%
%  OBJ = ADDTOEXTRAPOLATIONMASK(OBJ, ROW) adds table cells to the mask of a
%  1D table.
%
%  OBJ = ADDTOEXTRAPOLATIONMASK(OBJ, ROW, COL, DIM3, ...DIMn) adds table
%  cells to an nD table.
%
%  If all of the trailing dimension values are set to 1, then a
%  higher-dimensional call will work on lower dimensional tables.  For
%  example this means that a mask on a 1D table can be altered with the
%  same syntax as that used for a 2D table.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:09:55 $ 

L = cellfun('prodofsize', varargin);
if any(L-L(1))
    error('mbc:cglookup:InvalidSize', ...
        'All index vectors must be the same length.');
end
nDims = getNumAxes(obj);
if length(L)<nDims
    error('mbc:cglookup:InvalidArgument', ...
        'Not enough index vectors.  You must specify an index vector for each input axis of the table');
end
 
mask = getExtrapolationMask(obj);
if L(1)==1
    mask(varargin{1:nDims}) = true;
elseif L(1)>1
    idx = sub2ind(size(mask), varargin{1:nDims});
    mask(idx) = true;
end
if L(1)>0
    obj = pSetExtrapolationMask(obj, mask);
end
