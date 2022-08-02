function [B0,minb,maxb,OK]= initial(bs,x,y);
%INITIAL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:15 $

nk= get(bs.xreg3xspline,'numknots');

k= get(bs.xreg3xspline,'knots');

xs= sort(x);

r= xs(end)-xs(1);
tol= r/100;

OK=length(xs)>=6;
if OK
	[lb,ub,A,c,nlc,alpha]= constraints(bs,{x},{y});
	
	maxb= ub(1);
	minb= lb(1);
	
	B0= double(bs);
	
	bk= linspace(minb,maxb,nk+2)';
	
	bs.xreg3xspline= set(bs.xreg3xspline,'knots',bk(2:end-1));
	bs.xreg3xspline= leastsq(bs.xreg3xspline,x,y);
	
	B0= double(bs);
	minb= [minb; -Inf*ones(length(B0)-nk,1)];
	maxb= [maxb; Inf*ones(length(B0)-nk,1)];
else
	minb= [0; -Inf*ones(length(B0)-nk,1)];
	maxb= [1; Inf*ones(length(B0)-nk,1)];
end

