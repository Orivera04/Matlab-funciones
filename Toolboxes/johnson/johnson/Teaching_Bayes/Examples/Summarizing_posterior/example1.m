% EXAMPLE1.m
% Summarizing posterior density for one-parameter problem
% [Albert (1996), Chapter 11]
%
% Suppose that one is estimating a binomial proportion p.
% Assume that logit(p) is Cauchy(0, 1) and one observes 1 success
% and 9 failures.  The log posterior of T=logit(p) is equal to
%
% h(T) = T-10 log(1+exp(T))-log(1+T^2)
%
% This log posterior is programmed in the MATLAB function logpost1.m

% Laplace method

data = [1 9];    % data consists of number of successes and failures
mode = 0;        % starting guess at posterior mode
numiter = 10;    % number of iterations of Newton-Raphson

[mode,var,lint]=laplace('logpost1',mode,numiter,data)
                 % outputs posterior mode, estimate at posterior variance,
                 % and Laplace estimate at log integral

% Adaptive quadrature

mn=0; sd=1;      % estimates at posterior mean and standard deviation
numiter = 10;    % number of iterations of algorithm

[lint,mom]=ad_quad1('logpost1',[mn sd],numiter,data)
                 % outputs posterior mean and variance,
                 % and value of log integral

% Metropolis

start=0;         % starting value for simulation
scale=1;         % scale factor for random walk increment density
m=1000;          % number of iterations of algorithm

sim_sample=metrop('logpost1',start,m,scale,data); 
                 % outputs simulated sample from posterior density

