function [ci_hi,ci_lo]= cicalc(TS,Xs,alpha,Trans)
% MODEL/CICALC - calculate the confidence interval for a model on a set of data

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:24 $


% why is Ys requ'd?

df=dferror(TS);
if ~isfinite(df)
	df= Inf;
	ni = norminv(alpha);
else
	ni = tinv(alpha,df);
end

IT2= nfactors(TS.Local)==1 | ~all(InputFactorTypes(TS.Local)==1);

if Trans
	PEVArgs= {0,0};
else
	PEVArgs= {0};
end
if IT2
	[V,x1,x2,y]= pevgrid(TS,Xs,PEVArgs{:});
else
	[V,y]= pev(TS,Xs,PEVArgs{:});
end

if Trans
	y= ytrans(m,y(:));
else
	y= y(:);
end

ts= ni*sqrt(V(:));

ci_lo= y(:)-ts;
ci_hi= y(:)+ts;
