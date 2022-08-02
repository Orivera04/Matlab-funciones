function [pSS, level, obj] = getOriginal(obj)
%GETORIGINAL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:08:53 $

level = 0;
while ~isa(obj, 'sweepset');
	pSS = obj.pSweepset;
    if isvalid(obj.pSweepset)
        obj = pSS.info;
        level = level + 1;
    else
        obj = sweepset;
    end
end