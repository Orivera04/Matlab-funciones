% EXAMPLE3.m
% -----------------------------------
% Learning about two proportions
% using discrete subjective prior [Albert (1996), p 85].

% Suppose that P1 and P2 are the two proportions of
% interest.  Each proportion can be the values 0, .1, ...
% 1 and the prior is subjectively determined by specifying
% marginal distributions for p1 and p2 and assuming that the
% proportions are independent.
% The numbers of successes and failures in the two samples
% are (2, 13) and (14, 1).  We are interested in the
% posterior distribution of the difference P2-P1.

p1=.1:.1:.9;                          % values of first proportion p1
p2=.1:.1:.9;                          % values of second proportion p2
prior1=[.4 .3 .15 .05 .05 .05 0 0 0]; % prior probs for p1
prior2=[0 0 0 .05 .05 .05 .15 .3 .4]; % prior probs for p2

prior=prior1'*prior2;                 % construct probability matrix
                                      % p1 corresponds to rows and p2 columns
                                    
data=[2 13 14 1];   % data for two samples

[post,diff_dist]=pp_disc(p1,p2,prior,data)  

% computes matrix of posterior probabilities and probability
% distribution for difference of two proportions p2-p1
% rows of matrix correspond to values of p1 and columns of
% matrix correspond to p2
                                      
