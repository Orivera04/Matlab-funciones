function [bf,post1,post2]=mod_crit(model,prior1,prior2,llike_fcn,data)
%
% MOD_CRIT Model criticism for discrete models.
%	[BF,POST1,POST2] = MOD_CRIT(MODEL,PRIOR1,PRIOR2,LLIKE_FCN,DATA) returns 
%	two vectors POST1 and POST2 of posterior probabilities and the Bayes
%	factor BF in favor of the first model, where MODEL is the vector of 
%	parameter values, PRIOR1 and PRIOR2 are two vectors of prior probabilities,
%	LLIKE_FCN is the name of the function containing the log likelihood and 
%	DATA is the vector of data corresponding to the likelihood.

like=feval(llike_fcn,model,data);

like=exp(like-max(like));

product1=like.*prior1;
post1=product1/sum(product1);

product2=like.*prior2;
post2=product2/sum(product2);

bf=sum(prior1.*like)/sum(prior2.*like);

function loglike=binom(p,data)
%
% BINOM log-likelihood for a binomial proportion
%	LOGLIKE=BINOM(P,DATA) returns a vector of log likelhoods of a binomial
%	proportion, where P is the vector of proportion values, and DATA is 
%	the vector containing the number of successes and failures.

s=data(1); f=data(2);
p1=p+.5*(p==0)-.5*(p==1);

loglike=s*log(p1)+f*log(1-p1);
loglike=loglike.*(p>0).*(p<1)-999*((p==0)*(s>0)+(p==1).*(f>0));


function loglike=caprecap(m,data)
%
% CAPTURE log-likelihood for capture-recapture sampling.
%	LOGLIKE=CAPTURE(M,DATA) returns a vector of log likelihoods of the 
%	unknown finite population size, where M is the vector of parameters
%	and DATA is a vector containing the number marked in population, 
%	the sample size, and the number marked in sample.

K=data(1); n=data(2); x=data(3);
i=(m>=n-x); o=1-i;
i=logical(i); o=logical(o);

m1=m(i);
z1=gammaln(m1+1)-gammaln(m1-n+x+1)-gammaln(m1+K+1)+gammaln(m1+K-n+1);
z2=-999*m(o);

loglike=0*m; loglike(i)=z1; loglike(o)=z2;



function loglike=dis_unif(m,data)
%
% DIS_UNIF log-likelihood for a discrete uniform upper bound
%	LOGLIKE=DIS_UNIF(M,DATA) returns a vector of log likelihoods of a 
%	discrete uniform upper bound, where M is the vector of parameter 
%	values, and DATA is the vector containing the sample size and the
%	maximum observation.

n=data(1); mx=data(2);
loglike=-n*log(m).*(m>=mx)-999*(m<mx);


function loglike=expon(m,data)
%
% EXPON log-likelihood for a exponential mean
%	LOGLIKE=EXPON(M,DATA) returns a vector of log likelhoods of a 
%	exponential mean, where M is the vector of mean values, and DATA is 
%	the vector containing the sample size and the sum of observations.

n=data(1); s=data(2);
loglike=-n*log(m)-s./m;


function loglike=hyper(m,data)
%
% HYPER log-likelihood for hypergeometric sampling.
%	LOGLIKE=HYPER(M,DATA) returns a vector of log likelihoods of the 
%	unknown number of successes in a finite population, where M is
%	the vector of parameters and DATA is a vector containing the
%	population size, sample size, and number of successes.

N=data(1); n=data(2); s=data(3);
i=(m>=s).*(m<=(N-n+s)); o=1-i;

m1=m(i);
z1=gammaln(m1+1)-gammaln(m1-s+1)+gammaln(N-m1+1)-gammaln(N-m1-n+s+1);
z2=-999*m(o);

loglike=0*m; loglike(i)=z1; loglike(o)=z2;



function loglike=normal(m,data)
%
% NORMAL log-likelihood for a normal mean
%	LOGLIKE=NORMAL(M,DATA) returns a vector of log likelhoods of a normal
%	mean, where M is the vector of mean values, and DATA is 
%	the vector containing the sample mean, the sample size, and the
%	population standard deviation.

xbar=data(1); n=data(2); sigma=data(3);

loglike=-.5*n/sigma^2*(m-xbar).^2;


function loglike=poisson(lam,data)
%
% POISSON log-likelihood for a Poisson mean
%	LOGLIKE=POISSON(LAM,DATA) returns a vector of log likelhoods of a 
%	Poisson mean, where LAM is the vector of mean values, and DATA is 
%	the vector containing the sample sum and the time interval.

s=data(1); t=data(2); 

loglike=-t*lam+s*log(lam);

