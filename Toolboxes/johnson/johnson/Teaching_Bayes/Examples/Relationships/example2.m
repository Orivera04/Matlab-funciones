% EXAMPLE2.m
% Learning about relationships
% Test of independence in a two-way contingency table
%
% [Albert (1996), p. 144]
%
% Suppose one observes a 2-way contingency table and one
% wishes to test the hypothesis of independence.  One places
% a uniform prior on the vector of proportions under the 
% dependence hypothesis and places uniform priors on the
% marginal row and column proportions under independence.
% One computes the Bayes factor against the independence
% hypothesis.

data_table=[11 68  3
             9 23  5];            % define 2-way table

bayes_factor=c_table(data_table)  % computes Bayes factor

 
