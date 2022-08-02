function post=mod_cont(model,llike_fcn,data,n)
%
% MOD_CONT Posterior distribution for continuous models.
%	POST = MOD_CONT(MODEL,LLIKE_FCN,DATA,N) returns a simulated sample
%	from the posterior distribution, where MODEL is a simulated sample
%	from the prior, LLIKE_FCN is the name of the function containing 
%	the log likelihood, DATA is the vector of data corresponding to 
%	the likelihood, and N is the size of the simulated sample in the
%	algorithm.

if nargin==3, n=1000; end

like=feval(llike_fcn,model,data);
prob=exp(like-max(like));
prob=prob/sum(prob);
post=model(rdisc(n,prob));

function rand_indices=rdisc(n,p)

% given vector of probabilities p
% rdiscrete(n,p) simulates n random
% indices

q=cumsum(p);
r=rand(1,n);
rand_indices=ones(1,n);
for i=1:length(q)
  rand_indices=rand_indices+(r>(q(i)*ones(1,n)));
end

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

