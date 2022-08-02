function [summ_fitted,summ_resid]=lfitted(Mb,data,link)
% LFITTED Summarizes posterior distribution for fitted probabilities
%       and residual distributions.
%
%       [SUMM_FITTED,SUMM_RESID]=LFITTED(MB,DATA,LINK) returns 5th, 50th, and
%       95th percentiles of fitted probabilities (SUMM_FITTED) and residuals
%       (SUMM_RESID), where MB is the matrix of simulated values from the
%       posterior distribution, DATA is the data matrix [y n x], and LINK is
%       the link function ('l' for logit, 'p' for for probit, and 'c' for 
%       complementary log-log).

%-------------------------------------------------------------  
%  Jim Albert - May 15, 1998
%-------------------------------------------------------------

N=size(data,1);
p=size(data,2);
y=data(:,1); n=data(:,2); x=data(:,3:p);
m=size(Mb,1);

probs=[.05 .5 .95];
k=length(probs);
summ_fitted=zeros(N,k);
summ_resid=zeros(N,k);

cp=((1:m)-.5)/m;

for i=1:N
   lp=(x(i,:)*Mb')';
   p=g(lp,link);
   summ_fitted(i,:)=interp1(cp,sort(p),probs);
   residual=y(i)-summ_fitted(i,:);
   summ_resid(i,:)=residual([3 2 1]);
end

function p=g(eta,link)

if link=='l'
   p=exp(eta)./(1+exp(eta));
elseif link=='p'
   p=phi(eta);
elseif link=='c'
   p=1-exp(-exp(eta));
end

function val=phi(x)
val=.5*(1+erf(x/sqrt(2)));

