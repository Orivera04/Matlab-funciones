function ts= update(ts,p,dat);
%UPDATE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:43:18 $


nk= length(ts.knots);
ts.knots= p(1:nk);

pl= p(nk+1:end);
t= Terms(ts.xreglinear);
P=zeros(size(t));
P(t)= pl;
ts.xreglinear= update(ts.xreglinear,P);
