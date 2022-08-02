function [obj, OK] = extrapolateSingleRegion(obj, varargin)
%EXTRAPOLATESINGLEREGION Perform extrapolation within a region
%
%  [OBJ, OK] = EXTRAPOLATESINGLEREGION(OBJ, ROW, COL, METHOD) extrapolates
%  new values for all unlocked table cells in the region that contains cell
%  (ROW, COL) using the cells that are in the region and marked in the
%  extrapolation mask as the trusted ones.  METHOD can be 'linear', 'rbf'
%  or 'auto'.  If METHOD is omitted then the default is 'auto', which will
%  decide on the extrapolation method to use based on the shape of the area
%  being extrapolated.  If you attempt to force 'rbf' then you may get
%  errors in cases where it is not supported.
%
%  [OBJ, OK] = EXTRAPOLATESINGLEREGION(OBJ, ROW, METHOD) performs the
%  extrapolation for 1D tables.
%
%  [OBJ, OK] = EXTRAPOLATESINGLEREGION(OBJ, ROW, COL, ..., DIMn, METHOD)
%  performs the extrpaolation for nD tables.
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:10:13 $ 


% Check last argument for being a method
if ischar(varargin{end}) 
    method = varargin{end};
    varargin = varargin(1:end-1);
else
    method = 'auto';
end

% Reject multi-dimensional input case as there is no support for it in the
% extrapolation and region-finding functions
if length(varargin)>2
    error('mbc:cglookup:invalidArgument', ...
        'N-dimensional tables are not yet supported by this routine.');
elseif length(varargin)==1
    % Need to insert a dummy "1" index for 1D problem
    varargin{2} = 1;
end

if anyExtrapolationRegions(obj, varargin{:})
    % Get the region definition
    regmask = pFindRegion(getExtrapolationRegions(obj), varargin{:});
    % Extrapolation mask is the intersection of the overall mask with the
    % current region
    mask = getExtrapolationMask(obj) & regmask;
    if any(mask(:))
        obj = pExtrapolate(obj, method, mask, regmask);
        OK = true;
    else
        % No cells to extrapolate from
        OK = false;
    end
else
    % Nothing to do
    OK = false;
end
