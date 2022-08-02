% --------------------------------------------------------------------------------
%                    ORDINAL DATA MODELING 
%                VALEN JOHNSON AND JAMES ALBERT
%                     CHAPTER 3 TOOLBOX
% 
%                  Jim Albert - October 1, 1998
%
% --------------------------------------------------------------------------------
%              Basic fitting and model checking programs
% --------------------------------------------------------------------------------
%
% breg_mle - finds maximum likelihood fit and goodness-of-fit diagnostics
%
% breg_bay - MCMC simulation of Bayesian posterior with a conditional means prior
%
% b_probg - Gibbs sampling for a probit regression model using data augmentation
%
% ---------------------------------------------------------------------------------
%                   Additional Bayesian programs
% ---------------------------------------------------------------------------------
%
% lfitted - summarizes posterior distribution for fitted probabilities
%           and residual distributions for logistic fit
%
% lfitted2 - outputs simulated sample for fitted probabilities for selected
%            for logistic fit
%
% cmp - computation of posterior mode, approximate posterior variance-,
%       covariance matrix and log marginal density using Laplace's method
%
% plotfitted - produces errorbar plot of many distributions
%
% llatent - logistic scores plot for latent residuals in logistic
%       regression
%
% logit_re2 - fit of random effects model for conduct dataset of Chapter 3
%
% post_pred - Posterior predictive distribution of standard deviation(y*)
%           for conduct dataset in Chapter 3
%
% ----------------------------------------------------------------------------------
%                 Datasets and example runs
% ----------------------------------------------------------------------------------
% 
% stat.dat - student grades example dataset (passing, sat variables) from Chapter 3
% stat2.dat - student grades example dataset (passing, sat, prerequisite grade vars) from Chapter 3
% conduct.dat - conduct disorder example dataset from Chapter 3
% swimmer.dat - exercise 3.1 dataset
% donner.dat - exercise 3.2 dataset
% pcase.dat - exercise 3.3 dataset
% educ1.dat - exercise 3.5 dataset
% survey.dat - exercise 3.6 dataset
%
% example1.m - m-file illustrating computations for student grades dataset
% example2.m - m-file illustrating computations for conduct disorder dataset
% ----------------------------------------------------------------------------------
