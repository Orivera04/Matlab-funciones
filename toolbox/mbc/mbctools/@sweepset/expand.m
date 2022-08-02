function S= expand(S,t)
% SWEEPSET/EXPAND expand records into sweeps with size specified in t
%
% S= expand(S,t)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:06:13 $

s= size(S);
if s(1)~=s(3) | length(t)~=s(3)
	error('Invalid sweepset expansion')
end


bd1= S.baddata;
d1= S.data;

d2= zeros(sum(t),s(2));
bd2= sparse(d2);

j=1;
for i=1:length(t);
	d2(j:j+t(i)-1,:)= d1(i*ones(t(i),1),:);
	bd2(j:j+t(i)-1,:)= bd1(i*ones(t(i),1),:);
	j= j+t(i);
end
S.data= d2;
S.baddata= bd2;
S.nrec= size(d2,1);

S.xregdataset= xregdataset(testnum(S),type(S),t);