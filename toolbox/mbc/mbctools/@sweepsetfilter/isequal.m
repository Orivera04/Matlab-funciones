function OK = isequal(ssf1, ssf2)
%ISEQUAL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:09:02 $

OK = 0;
if isa(ssf2, 'xregpointer')
	if ~isvalid(ssf2)
		return
	end
	ssf2 = ssf2.info;
end

if ~strcmp(get(ssf1,'label'), get(ssf2,'label'))
	return
end

p1 = ssf1.pSweepset;
p2 = ssf2.pSweepset;

if p1 == 0 | p2 == 0
	OK = p1 == p2;
	return
end

OK = isequal(sweepset(ssf1), sweepset(ssf2));
