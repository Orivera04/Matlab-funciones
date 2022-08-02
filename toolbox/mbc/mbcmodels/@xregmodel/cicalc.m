function [ci_hi,ci_lo]= cicalc(m,Xs,Ys,alpha,Trans)
% MODEL/CICALC - calculate the confidence interval for a model on a set of data
%
% [ci_hi,ci_lo]= cicalc(m,Xs,Ys,Trans)
%
% X and Y must be in natural units.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:51:28 $

if Trans & ~isempty(m.ytrans)
	% transformed yhat and sigma(yhat)^2
	p = evalpev(code(m,Xs),m);
	yhat= ytrans(m,EvalModel(m,Xs));
else
	% untransformed yhat and sigma(yhat)^2
	[p,yhat] = pev(m,code(m,Xs),0);
end

% build confidence intervals
df= dferror(m);
if isfinite(df) & df<1000
	ts= tinv(1-(1-alpha)/2,df)*sqrt(p);
else
	ts= norminv(1-(1-alpha)/2)*sqrt(p);
end
ci_lo= yhat-ts;
ci_hi= yhat+ts;
