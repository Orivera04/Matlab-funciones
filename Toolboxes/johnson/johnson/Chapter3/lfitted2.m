function fitted=lfitted2(Mb,cov,link)
% LFITTED2 Posterior distribution for fitted probabilities for logistic model.
%
%    FITTED=LFITTED2(MB,COV,LINK) returns a matrix of simulated values from the
%    posterior distributions of selected fitted probabilities, where MB is the
%    matrix of simulated values from the posterior, COV is a matrix of covariate
%    vectors, and LINK is the link function ('l' for logit, 'p' for for probit, 
%    and 'c' for complementary log-log).

%-------------------------------------------------------------  
%  Jim Albert - May 15, 1998
%-------------------------------------------------------------

N=size(cov,1); 
m=size(Mb,1);
fitted=zeros(m,N);

for i=1:N
   lp=(cov(i,:)*Mb')';
   p=g(lp,link);
   fitted(:,i)=p;
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
