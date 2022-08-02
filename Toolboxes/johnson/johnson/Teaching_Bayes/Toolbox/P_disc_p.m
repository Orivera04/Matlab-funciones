function pred=p_disc_p(p,probs,n,s)
%
% P_DISC_P Predictive distribution of number of successes in future binomial
%	experiment with a discrete prior. PRED = P_DISC_P(P,PROBS,N,S) returns 
%	vector PRED of predictive probabilities, where P is the vector of 
%	values of the proportion, PROBS is the corresponding vector of
%	probabilities, N is the future binomial sample size, and S is the vector of
%	numbers of successes for which predictive probabilities will be computed.

pred=0*s;

for i=1:length(p);
 pred=pred+probs(i)*binopdf(s,n,p(i));
end

function prob=binopdf(x,n,p)

prob=exp(gammaln(n+1)-gammaln(x+1)-gammaln(n-x+1)+x.*log(p)+(n-x).*log(1-p));


