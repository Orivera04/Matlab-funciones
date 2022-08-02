% EXAMPLE3.M
% --------------------------------------------------------
% Learning about discrete models
% Inference about a finite population [Albert (1996), p. 162]
% --------------------------------------------------------
% Suppose that a finite population of known size N consists of
% an unknown number K of successes.  We take a random sample of
% size n and observe x successes.  We wish to learn about K.

K=0:100;          % list of possible numbers of successes

prior=1/101+0*K;  % probabilities on these values of K

data=[100 20 12]; % vector containing population size N, sample
                  % size n, and observed number of successes x

post=mod_disc(K,prior,'hyper',data); % compute posterior probs

