function [spost,mom,x,f]=ad_quad1(logpost,mom,iter,par)
% AD_QUAD1 Summarizes a one-parameter posterior by adaptive quadrature.
%	[SPOST,MOM,X,F]=AD_QUAD1(LOGPOST,MOM,ITER,PAR) returns the estimate SPOST
%	at the log integral of the posterior, a vector MOM containing the posterior 
%	mean and standard deviation, a vector X containing the parameter grid,
%	and the vector F of values of the log posterior, where LOGPOST is a
%	function containing the definition of the log posterior, MOM is the
%	vector containing the initial guess at the moments, ITER is the
%	number of iterations in the procedure, and PAR is vector of parameters
%	connected to the definition of the function.

for i=1:iter
  [spost,mom,x,f]=ns(logpost,mom,par);
end
spost=log(spost);

function [spost,newmom,x,f]=ns(logpost,mom,par);

% naylor/smith adaptive quadrature on one-dimensional posterior
% [spost,newmom,x,f]=ns(logpost,mom,par)
% where logpost is function defining log posterior, mom is guess at mean
% and standard deviation, and par is vector of parameter values in function
% output is integral est, new moments, grid and function values on grid

tq=[-3.4362 -2.5327 -1.7567 -1.0366 -0.3429 0.3429 1.0366 1.7567 2.5327 3.4362];
wet=[1.0255 0.8207 0.7414 0.7033 0.6871 0.6871 0.7033 0.7414 0.8207 1.0255];
con=sqrt(2);

mx=mom(1); sx=mom(2);

x=mx+tq*sx*con; 
wx=wet*sx*con;	
f=feval(logpost,x,par);

abf=exp(f).*wx;
spost=sum(abf); smx=sum(abf.*x); smxx=sum(abf.*x.*x);
mx=smx/spost; sx=sqrt(smxx/spost-mx^2);

newmom=[mx,sx];


