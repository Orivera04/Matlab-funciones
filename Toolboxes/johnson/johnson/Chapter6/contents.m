%
--------------------------------------------------------------------------------
%                    ORDINAL DATA MODELING
%                VALEN JOHNSON AND JAMES ALBERT
%                     CHAPTER 6 TOOLBOX
%
%                  Jim Albert - November 30, 1998
%
%----------------------------------------------------------------------------
%                Basic fitting programs
%----------------------------------------------------------------------------
%
% item_r - Bayesian fit of two-parameter item response model - probit link
%
% l_itemr - Bayesian fit of two-parameter item response model - logit link
%
% item_r1 - Bayesian fit of one-parameter item response model - probit link
%
% item_r_h - Bayesian fit of two-parameter item response model - probit link
%            exchangeable model placed on item slope parameters
%
%----------------------------------------------------------------------------
%                Additional programs
%----------------------------------------------------------------------------
%
% irtobs - computes observed proportion of correct for groups of latent ability
%
% ir_curve - computes values of the probability of correct response (probit
link)
%            for selected values of item parameters -- useful for plotting
item
%            response curves
%
% irtpost - computes 5th, 50th, 95th percentiles of posterior of item response
%           curve - probit link
%
% plotpost - computes 5th, 50th, 95th percentiles and graph of each
component of
%           a matrix of simulated values
%
% phi - computes cumulative density function of a standard normal random
variable
%
%----------------------------------------------------------------------------
%               Datasets and sample runs
%----------------------------------------------------------------------------
%
% ratings.dat - shyness rating dataset from Chapter 6
%
% place98.dat - math placement dataset in exercises of Chapter 6
%
% example.m - m-file illustrating computations for ratings dataset
%----------------------------------------------------------------------------