function values=m_norm_t(m0,prob,t,data)
%
% M_NORM_T Performs a test that a normal mean is equal to a specific value.
%	M_NORM_T(M0,PROB,T,DATA) gives a matrix where the first column contains
%	values of the Bayes factor and the second column contains the corresponding
%	posterior probabilities.  M0 is the value to be tested, PROB is the prior
%	probability of the hypothesis, T is a column vector of prior standard deviations
%	of the normal prior under the alternative hypothesis, and DATA is the vector
%	containing the sample mean, the sample size and the population standard 
%	deviation.

xbar=data(1); n=data(2); h=data(3);

num=.5*log(n)-log(h)-.5*n/h^2*(xbar-m0)^2;
den=-.5*log(h^2/n+t.^2)-.5./(h^2/n+t.^2)*(xbar-m0)^2;
bf=exp(num-den);

post=prob*bf./(prob*bf+1-prob);
values=[bf' post'];


