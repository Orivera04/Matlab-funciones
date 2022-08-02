function obj = removeRectFromExtrapolationRegions(obj, varargin)
%REMOVERECTFROMEXTRAPOLATIONREGIONS Remove a rectangular region from the extrapolation regions mask
%
%  OBJ = REMOVERECTFROMEXTRAPOLATIONREGIONS(OBJ, ROWRANGE, COLRANGE)
%  removes rectangular regions from the extrapolation regions mask.
%  ROWRANGE and COLRANGE are (N-by-2) matrices with the corresponding rows
%  in each specifying the min and max of the ranges for a set of N
%  rectangles.
%  
%  If ROWRANGE and COLRANGE are omitted, all of the cells will be removed
%  from the mask.
%
%  OBJ = REMOVERECTFROMEXTRAPOLATIONREGIONS(OBJ, ROWRANGE) removes linear
%  regions from the regions mask of a 1D table.
%
%  OBJ = REMOVERECTFROMEXTRAPOLATIONREGIONS( ...
%            OBJ, ROWRANGE, COLRANGE, DIM3RANGE, ... , DIMnRANGE ...
%        )
%  removes hyper-cuboidal regions from an nD table.
%
%  If all of the trailing dimension values are set to 1, then a
%  higher-dimensional call will work on lower dimensional tables.  For
%  example this means that a regions mask on a 1D table can be altered with
%  the same syntax as that used for a 2D table.
%
%  SEE ALSO:  CGLOOKUP/ADDRECTTOEXTRAPOLATIONREGIONS.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:12:08 $ 

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
        mask(rowrange(n,1):rowrange(n,2)) = false; 
    end
elseif nargin==3
    rowrange = varargin{1};
    colrange = varargin{2};
    for n = 1:L(1)
        mask(rowrange(n,1):rowrange(n,2), colrange(n,1):colrange(n,2)) = false; 
    end
elseif nargin>3
    S = substruct('()', cell(1, length(L)));
    for n = 1:L(1)
        for m = 1:length(L)
            S.subs{m} = varargin{m}(n,1):varargin{m}(n,2);
        end
        mask = subsasgn(mask, S, false);
    end
else
    mask(:) = false;
end

if L(1)>0
    obj = pSetExtrapolationRegions(obj, mask);
end
