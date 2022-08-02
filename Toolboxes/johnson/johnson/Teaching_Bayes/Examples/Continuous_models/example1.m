% EXAMPLE1.m
% Learning about continuous models
% Capture/recapture sampling
%
% One is interested in estimating the total number
% of fish (N) in a lake.  You introduce M marked fish,
% then take a sample of n without replacement -- you
% observe x tagged fish.
% A priori you think that log(N) is N(6.9, .4)

num=1000;                           % size of simulation sample in computation
log_prior_s=6.9+.4*randn(num,1);    % simulate values from prior of log(N)
prior_s=exp(log_prior_s);           % prior_s contains simulated sample from prior of N

data=[100 40 5];                    % data contains values of M, n, x

post_s=mod_cont(prior_s,'caprecap',data,num); % post_s contains simulated sample
                                              % from posterior of N

 
