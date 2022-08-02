% --------------------------------------------------------------------------------
%                    ORDINAL DATA MODELING 
%                VALEN JOHNSON AND JAMES ALBERT
%                     CHAPTER 4 TOOLBOX
% 
%           Jim Albert and Val Johnson - October 1, 1998
%
%----------------------------------------------------------------------------
%                Basic fitting programs
%----------------------------------------------------------------------------
%
% ordinal_MLE - MLE fit of ordinal model using probit or logistic link
%
% plotfit - plots estimated multinomial probabilities against one covariate
%
% sampleOrdProb - Bayesian fit of ordinal model, probit link, noninformative prior
%
% norm_plot - constructs normal probability plot
%
% o_post_pred - simulates, summarizes, and graphs posterior predictive residuals
%
%----------------------------------------------------------------------------
%               Datasets and sample runs
%----------------------------------------------------------------------------
%
% ostat.dat - statistics class dataset (grade, sat vars) from Chapter 4
% ostat2.dat - statistics class dataset (grade, sat, prereq grade vars) from Chapter 4
% grader.dat - essay grader dataset from Chapter4
% educ.dat - exercise 4.1 dataset
% survey.dat - exercise 4.2 dataset
% skotko.dat - exercise 4.6 dataset
%
% example1.m - m-file illustrating computations for statistics class dataset
% example2.m - m-file illustrating computations for essay grader dataset
%
%----------------------------------------------------------------------------


