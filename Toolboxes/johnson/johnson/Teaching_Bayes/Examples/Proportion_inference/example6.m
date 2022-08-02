% EXAMPLE6.m
% -------------------------------------------
% Learning about a proportion 
% A test for a proportion [Albert (1996), p. 62].

% You are testing if a coin is fair (null hypothesis)
% against the alternative that the coin is biased.  You
% place prior probability .5 on the null hypothesis.  Also,
% if the coin is biased, you assign the probability a
% beta(10,10) distribution.  You observe 22 heads and
% 28 tails.

p0=.5;            % proportion value to be tested
prob=.5;          % prior probability of proportion value
beta_par=[10 10]; % parameters of beta prior if proportion is
                  % not equal to value
data=[22 28];     % observed number of successes and failures

p_beta_t(p0,prob,beta_par,data) % outputs Bayes factor in favor
                                % of proportion value and posterior
                                % probability of this value