function obj = addRectToExtrapolationRegions(obj, varargin)
%ADDRECTTOEXTRAPOLATIONREGIONS Add a rectangular region to the extrapolation regions mask
%
%  OBJ = ADDRECTTOEXTRAPOLATIONREGIONS(OBJ, ROWRANGE, COLRANGE) adds
%  rectangular regions to the extrapolation regions mask.  ROWRANGE and
%  COLRANGE are (N-by-2) matrices with the corresponding rows in each
%  specifying the min and max of the ranges for a set of N rectangles.
%  
%  If ROWRANGE and COLRANGE are omitted, all of the cells will be added to
%  the mask.
%
%  Example:
%    In order to make a mask that matches the following:
%
%      0 0 0 0 0 0 0 0
%      0 1 1 0 0 0 0 0
%      0 1 1 0 1 1 1 0
%      0 1 1 0 1 1 1 0
%      0 1 1 0 1 1 1 0
%      0 1 1 0 0 0 0 0
%      0 0 0 0 0 0 0 0
%      0 0 0 0 0 0 0 0
%
%  use the call:
%
%    obj = addRectToExtrapolationRegions(obj, [2 6; 3 5], [2 3; 5 7]);
%
%
%  OBJ = ADDRECTTOEXTRAPOLATIONREGIONS(OBJ, ROWRANGE) adds linear regions
%  to the regions mask of a 1D table.
%
%  OBJ = ADDRECTTOEXTRAPOLATIONREGIONS( ...
%            OBJ, ROWRANGE, COLRANGE, DIM3RANGE, ... , DIMnRANGE ...
%        )
%  adds hyper-cuboidal regions to an nD table.
%
%  If all of the trailing dimension values are set to 1, then a
%  higher-dimensional call will work on lower dimensional tables.  For
%  example this means that a regions mask on a 1D table can be altered with
%  the same syntax as that used for a 2D table.
%
%  SEE ALSO:  CGLOOKUP/REMOVERECTFROMEXTRAPOLATIONREGIONS.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:09:54 $ 

if nargin>1
    % Check that all entries in varargin have same number of rows
    L = zeros(size(varargin));
    for n =1:length(L)
        L(n) = size(varargin{n},1);
    end
    if any(L-L(1))
        error('mbc:cglookup:InvalidSize', ...
            'All index vectors must have the same number of rows.');
    end
    nDims = getNumAxes(obj);
    if length(L)<nDims
        error('mbc:cglookup:InvalidArgument', ...
            'Not enough index vectors.  You must specify an index vector for each input axis of the table');
    end
else
    L = 1;
end

mask = getExtrapolationRegions(obj);
% Special case the 1D and 2D tables as these are important objects that
% merit special attention speed-wise.
if nargin==2
    rowrange = varargin{1};
    for n = 1:L(1)
        mask(rowrange(n,1):rowrange(n,2)) = true; 
    end
elseif nargin==3
    rowrange = varargin{1};
    colrange = varargin{2};
    for n = 1:L(1)
        mask(rowrange(n,1):rowrange(n,2), colrange(n,1):colrange(n,2)) = true; 
    end
elseif nargin>3
    S = substruct('()', cell(1, length(L)));
    for n = 1:L(1)
        for m = 1:length(L)
            S.subs{m} = varargin{m}(n,1):varargin{m}(n,2);
        end
        mask = subsasgn(mask, S, true);
    end
else
    mask(:) = true;
end

if L(1)>0
    obj = pSetExtrapolationRegions(obj, mask);
end

