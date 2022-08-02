% EXAMPLE1.m
% -----------------------------------
% Learning about two proportions
% using discrete uniform prior [Albert (1996), p 82].

% Suppose that P1 and P2 are the two proportions of
% interest.  Each proportion can be the values 0, .1, ...
% 1 and the prior is uniform over the grid of proportion values.
% The numbers of successes and failures in the two samples
% are (2, 13) and (14, 1).  We are interested in the
% posterior distribution of the difference P2-P1.

lohinum=[0 1 11];    % smallest value, largest value, and grid size
                     % for each proportioin
type='u';            % type of prior is testing type
[p1,p2,prior]=pp_prior(lohinum,type);  
% constructs vectors of probabilities p1 and p2 and probability matrix
                                      
data=[2 13 14 1];   % data for two samples

[post,diff_dist]=pp_disc(p1,p2,prior,data)  

% computes matrix of posterior probabilities and probability
% distribution for difference of two proportions p2-p1
% rows of matrix correspond to values of p1 and columns of
% matrix correspond to p2
                                      
