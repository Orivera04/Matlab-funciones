function freeptr(MP)
% MDEVPROJECT/FREEPTR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:03:27 $

for i=1:length(MP.Datalist)
	pSSF = MP.Datalist(i);
	% Free any underlieing sweepsets in the filter
	pSSF.freeallptr;
	freeptr(pSSF);
end
