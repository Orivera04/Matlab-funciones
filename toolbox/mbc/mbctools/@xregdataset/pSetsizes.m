function T = pSetsizes(T, sizes, testnumbers, type)
%PSETSIZES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:18:50 $


if nargin < 4
    type = -1*ones(size(sizes));
end

if numel(type) == numel(testnumbers) && numel(type) == numel(sizes)
    T.type = {type(:)'};
    T.sizes =  {uint32(sizes(:)')};
    T = testnum(T, testnumbers);
end
