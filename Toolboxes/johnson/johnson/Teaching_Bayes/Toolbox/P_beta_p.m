function pred=p_beta_p(ab,n,s)
%
% P_BETA_P Predictive distribution of number of successes in future binomial
%	experiment with a beta prior. PRED = P_BETA_P(AB,N,S) returns a vector 
%	PRED of predictive probabilities, where AB is the vector of beta
%	parameters, N is the future binomial sample size, and S is the vector of
%	numbers of successes for which predictive probabilities will be computed.

pred=0*s;

a=ab(1); b=ab(2);

lcon=gammaln(n+1)-gammaln(s+1)-gammaln(n-s+1);

pred=exp(lcon+betaln(s+a,n-s+b)-betaln(a,b));


