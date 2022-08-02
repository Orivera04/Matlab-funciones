% EXAMPLE2.M
% --------------------------------------------------------
% Learning about discrete models
% Inference about a uniform population [Albert (1996), p. 158]
% --------------------------------------------------------
% Suppose that we observed taxi numbers that are uniformly
% distributed on the set 1, ..., N.  Apriori we believe that N
% is equally likely to be 1,..., 200.  We observe five taxi 
% numbers and the maximum number observed is 100.  We wish to
% update the probabilities for N

N=1:200;              % values of the uniform upper bound

prior=1/200+0*N;      % corresponding prior probabilities

data=[5 100];         % sample size and maximum observation

post=mod_disc(N,prior,'dis_unif',data);  % posterior probabilities
