function MP= mapptr(MP,RefMap);
% MDEVPREJECT?MAPPTR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:03:40 $

for i=1:length(MP.Datalist)
	% datalist contains pointers in mvdata
	MP.Datalist(i)= mapptr(MP.Datalist(i),RefMap);
end
MP.modeldev= mapptr(MP.modeldev,RefMap);
