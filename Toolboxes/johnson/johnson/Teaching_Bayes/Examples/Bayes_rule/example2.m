% EXAMPLE2.m
% -------------------------------------------
% Introduction to inference using Bayes' rule
% Learning about a student's ability
% [from Albert (1996), p. 29]

% Here the models are the ability levels of the student ("good",
% "mediocre" and "poor") and the data are the possible grades
% in a course ("A", "B", "C", "D", "F").  You observe the 4 grades
% B, B, C, C and wish to compute the probabilities of the ability
% levels.

prior = [.6
         .3
         .1];                 % initial probabilities of the three models
      
like = [.4 .4 .2  0  0
        .1 .2 .4 .2 .1  
         0  0 .3 .5 .2];      % likelihoods of 5 grades for each model
      
data = [2 2 3 3];             % observed test result
     
post = bayes(prior,like,data) % computes matrix of posterior probabilities 
                              % of the three models -- the first row
                              % contains the updated probabilities after observing
                              % the first grade, the second row contains the
                              % probabilities after observing the first two grades,
                              % etc.
     
     