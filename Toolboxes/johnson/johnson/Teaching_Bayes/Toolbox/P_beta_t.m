function values=p_beta_t(p0,prob,ab,data)
%
% P_BETA_T Performs a test that a proportion is equal to a specific value.
%	P_BETA_T(P0,PROB,AB,DATA) gives a vector of the Bayes factor and
%	the probability of the hypothesis P=P0, where P0 is the proportion
%	value to be tested, PROB is the prior probability of the hypothesis,
%	AB is the vector of parameters of the beta density under the 
%	alternative hypothesis, and DATA is the vector of numbers of 
%	successes and failures.

a=ab(1); b=ab(2);
s=data(1); f=data(2);

lbf=s*log(p0)+f*log(1-p0)+betaln(a,b)-betaln(a+s,b+f);

bf=exp(lbf);
post=prob*bf/(prob*bf+1-prob);
values=[bf post];


