% EXAMPLE4.M
% --------------------------------------------------------
% Learning about discrete models
% Model criticism - comparing priors [Albert (1996), p. 166]
% --------------------------------------------------------
%
% Suppose that a new baseball player is evaluated.  Let p
% denote his true batting average.  The manager believes that
% p = .2, .22, ..., .34 and assigns probabilities to these values.
% A scout places a different prior distribution on these same set
% of values.  The player gets 10 hits and 20 outs in his first 30
% at-bats.  Wish to update the probabilities for both the manager
% and the scout and assess which prior is more consistent with the data.

p=.2:.02:.34;                             % grid of proportion values
prior1=[.05 .05 .10 .25 .25 .15 .10 .05]; % prior probs of manager
prior2=[.20 .20 .20 .15 .10 .05 .05 .05]; % post probs of manager

data=[10 20];                             % observed # of successes and failures

[bf,post1,post2]=mod_crit(p,prior1,prior2,'binom',data);

% post1 is vector of posterior probs for first prior
% post2 is vector of posterior probs for second prior
% bf is Bayes factor in support of first prior

