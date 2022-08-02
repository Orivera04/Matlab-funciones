function array = getGuids(obj, index)
%SWEEPSET/GETGUIDS returns the GUIDARRAY from a sweepset

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 

if nargin < 2
    index = ':';
end
array = obj.guid(index);
