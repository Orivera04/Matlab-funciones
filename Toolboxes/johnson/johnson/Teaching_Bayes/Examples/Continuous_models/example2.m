% EXAMPLE2.m
% Learning about continuous models
% Using a mixture prior and binomial data.
% [Albert (1996), p. 178]
% Estimating a baseball average p.  Suppose that the
% prior for p is 90% a beta(20.4, 47.6) and 10% a uniform density.
% We observe 30 hits and 20 outs.  We are interested in the posterior
% density for p.
% [Needs utility function rbeta.m]

num=1000;                                        % size of simulation sample in computation

prior_s=[rbeta(20.4,47.6,900);rand(100,1)];      % prior_s contains 1000 simulated
                                                 % from the mixture prior

data=[30 20];                                    % data contains values of s and f

post_s=mod_cont(prior_s,'binom',data,num);       % post_s contains simulated sample
                                                 % from posterior of p



