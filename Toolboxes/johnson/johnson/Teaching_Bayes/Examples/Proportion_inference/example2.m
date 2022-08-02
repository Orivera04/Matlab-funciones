% EXAMPLE2.m
% -------------------------------------------
% Learning about a proportion -- summaries
% Baseball example [from Albert (1996), p. 42]

% In this example, p is the player's batting average.
% We suppose that p is located on the grid 
% .2, .21, ..., .5 and the prior distribution is
% uniform.  We observe 132 hits and 236 outs.

p = .2:.01:.5;               % values of proportion
prior = 1+0*p;               % prior probabilities (need not be normalized)
data = [132 236];            % observed data

post = p_disc(p,prior,data);          % vector of posterior probs

stem(p,post)                          % graph of posterior probabilities

post_mode=p(find(post==max(post)))    % posterior mode of p

post_mean=sum(p.*post)                % posterior mean of p

post_sd=sqrt(sum(p.^2.*post)-post_mean^2)  % posterior standard deviation

post_prob=sum(post(p<=.39))            % finds P(p<=.9)

prob_set=disc_int([p;post]',.9)        % 90% posterior probability interval
     