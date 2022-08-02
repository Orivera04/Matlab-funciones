function [LB,UB]= sbounds(S)
% SWEEPSET/SBOUNDS bounds for each sweep

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:11:29 $

LB= zeros(size(S,[3,2]));
UB= LB;

for i=1:size(LB,1)
	d= S.data(sindex(S,i),:);
	if size(d,1)>1
		LB(i,:)= nanmin(d);
		UB(i,:)= nanmax(d);
	else
		LB(i,:)= d;
		UB(i,:)= d;
	end
end