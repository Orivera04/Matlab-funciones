function passign(p, data, useScalarExpansion)
%PASSIGN Vectorized assigning of cell array to dynamic memory
%
%  PASSIGN(P, DATA) copies the data in each element of the cell array DATA
%  into the corresponding heap location referenced in the pointer vector P.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $  $Date: 2004/02/09 06:47:26 $

okForElementbyElement = iscell(data) && (numel(p.ptr) == numel(data));
if nargin<3
    useScalarExpansion = ~okForElementbyElement;
end

if useScalarExpansion
    % scalar expansion
    % put data into each location
    HeapManager(3,p.ptr(:),{data});
elseif okForElementbyElement
    HeapManager(3,p.ptr(:),data(:));
else
    error('mbc:xregpointer:InvalidAssignment', 'Invalid vectorised assignment');
end
