% EXAMPLE4.m
% -----------------------------------
% Learning about two proportions
% using an exchangeable prior [Albert (1996), p. 93].

% We are interested in testing the hypothesis that p1=p2

prob=.5;         % prior probability that p1=p2
par1=[1 1];      % beta parameters of prior on common proportion value
                 % under hypothesis of equality
par2=[1 1 1 1];  % parameters of independent beta priors placed on
                 % p1 and p2 under alternative hypothesis that p1<>p2
data=[2 13 14 1];% data for two samples

pp_bet_t(prob,par1,par2,data)

% outputs vector containing Bayes factor in favor of hypothesis that
% p1=p2 and posterior probability of p1=p2
