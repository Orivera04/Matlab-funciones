function [B0,minb,maxb,OK]= initial(ts,x,y);
%INITIAL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:43:05 $

nk= length(ts.knots);

k= sort(ts.knots);

xs= sort(x);

r= xs(end)-xs(1);
tol= r/100;

maxb= xs(end-nk)- tol;
minb= xs(nk) + tol;

B0= double(ts);

bk= linspace(minb,maxb,nk+2);

B0(1:nk)= bk(2:end-1);

OK=1;
