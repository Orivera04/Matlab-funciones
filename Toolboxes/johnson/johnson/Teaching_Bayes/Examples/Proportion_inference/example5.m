% EXAMPLE5.m
% -------------------------------------------
% Learning about a proportion 
% Prediction using a beta prior [Albert (1996), p. 57].

% Suppose that your current beliefs about a proportion
% are described by a beta(20.4, 47.6) distribution and
% you wish to predict the number of successes in a future
% sample of size 20.

beta_par=[20.4 47.6];  % vector of beta parameters
n=20;                  % size of future sample
s=0:20;                % numbers of successes

pred_probs=p_beta_p(beta_par,n,s)  % vector of predictive
                                   % probabilities

                                          
                                          