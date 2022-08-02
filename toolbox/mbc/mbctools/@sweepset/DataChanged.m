function OK=DataChanged(OldData,NewData);
% SWEEPSET/DATACHANGED

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:05:56 $

OK= 0;
sn= size(OldData,3);
if size(NewData,3)>=sn
	nd= subsref(NewData,substruct('()',{':',':',1:sn}));
	if	all(testnum(OldData)==testnum(nd)) & ...             % test numbers are same
			all(size(OldData,1:2) ==size(nd,1:2)) & ...       % same size of data (recs x vars)
			all(OldData.data(:)==nd.data(:))                  % data is the same
		OK= 1;
	end
end
