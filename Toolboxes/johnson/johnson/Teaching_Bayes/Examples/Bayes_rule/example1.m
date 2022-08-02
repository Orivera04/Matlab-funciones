% EXAMPLE1.m
% -------------------------------------------
% Introduction to inference using Bayes' rule
% Do you have a rare disease?
% [from Albert (1996), p. 25]

% Here the two models are "have disease" and "don't have disease"
% The data is the result of the blood test which can be 
% positive or negative.   You observe a positive test result and
% you wish to find the probability you have the disease.

prior = [.001 
         .999];               % probabilities of the two models

like = [.95 .05
        .05 .95];             % likelihoods of + and - for each model

data = 1;                     % observed test result
     
post = bayes(prior,like,data) % computes posterior probabilities 
                              % of the two models
     
     