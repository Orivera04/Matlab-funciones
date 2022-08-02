function TS= RFcovupdate(TS)
% RFCOVUPDATE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



%   $Revision: 1.6.2.3 $  $Date: 2004/02/09 07:59:16 $

D= cov(TS);
for i=1:length(TS.Global)
	% change variance estimate in global models 
	[ri,s2,df]= var(TS.Global{i});
	if s2~=0
		ri= ri*sqrt(D(i,i)/s2);
		TS.Global{i}= var(TS.Global{i},ri,D(i,i),df);
	end
	if (DatumType(TS.Local)==1 | DatumType(TS.Local)==2) & ~RFstart(TS.Local)
		TS.datum= TS.Global{1};
	end
end		
