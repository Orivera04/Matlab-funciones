% EXAMPLE3.m
% -------------------------------------------
% Learning about a proportion -- prediction
% Baseball example [from Albert (1996), p. 46]

% In this example, p is the player's batting average.
% We suppose that p is either .2, .25, .3, .35 with
% respective prior probabilities .25, .25, .25, .25.
% Suppose that the player has 20 future at-bats and we
% wish to predict the number of hits.

p = [.2 .25 .3 .35];         % values of proportion
prior = [.25 .25 .25 .25];   % prior probabilities
n=20;                        % future sample size
s=0:n;                       % number of hits of interest

pred_probs=p_disc_p(p,prior,n,s)  % computes vector of predictive
                                  % probabilities
