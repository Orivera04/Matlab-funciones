% EXAMPLE1.m
% -------------------------------------------
% Learning about a proportion
% Baseball example [from Albert (1996), p. 41]

% In this example, p is the player's batting average.
% We suppose that p is either .2, .25, .3, .35 with
% respective prior probabilities .25, .25, .25, .25.
% We observe 5 hits (successes) and 15 outs (failures)

p = [.2 .25 .3 .35];         % values of proportion
prior = [.25 .25 .25 .25];   % prior probabilities
data = [5 15];               % observed data

post = p_disc(p,prior,data)  % vector of posterior probs
     