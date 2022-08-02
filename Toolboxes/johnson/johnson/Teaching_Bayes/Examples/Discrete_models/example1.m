% EXAMPLE1.M
% --------------------------------------------------------
% Learning about discrete models
% Inference about a Poisson model [Albert (1996), p. 157]
% --------------------------------------------------------
% Suppose we observe the number of cars sold in 24 days by
% a particular salesman.  We assume that this number is
% Poisson with mean 24 M, where M is the daily selling rate.
% Suppose that we think that M is either .5, .25, .125 with
% respective probabilities .2, .5, .3.  We observe 10 cars sold
% in 24 days.  Want posterior distribution for M.

M=[.5 .25 .125];       % values of the Poisson mean

prior=[.2 .5 .3];      % corresponding prior probabilities

data=[10 24];          % sample sum and time interval

post=mod_disc(M,prior,'poisson',data)  % posterior probabilities
