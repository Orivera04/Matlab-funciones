% EXAMPLE3.m
% Summarizing posterior density for smoking/lung cancer problem
%
% Have 2 x 2 contingency table with two unknown proportions p1 and p2.
% We observe the table [83 3;72 14]. If the proportions are transformed 
% to the log odds ratio A and the log odds ratio E, then the log posterior
% density with a flat noninformative prior on (A, E) is given by
%
% h(A,E)=83 T1- 86 log(1+exp(T1))+72 T2-86 log(1+exp(T2))
% where T1=(A+E)/2, T2=(E-A)/2.  This log posterior is programmed in
% the MATLAB function logpost3.m

% Laplace method

data = [83 3 72 14];   % data consists of number of successes and sample size
                       % for each sample
mode = [2 5];          % starting guess at posterior mode
numiter = 10;          % number of iterations of Newton-Raphson

[mode,var,lint]=laplace('logpost3',mode,numiter,data)
                      % outputs posterior mode, estimate at posterior variance,
                      % and Laplace estimate at log integral

% Adaptive quadrature

mom=[0 1 0 1 0];      % estimate at E(W), SD(W), E(U), SD(U), corr(W,U)
numiter = 10;         % number of iterations of algorithm

[lint,mom]=ad_quad2('logpost3',mom,numiter,data)
                     % outputs posterior mean and variance,
                     % and value of log integral

% Gibbs sampling

start=[0 0];      % starting value for simulation
scale=[1 1];      % scale factors for random walk increment density
m=5000;           % number of iterations of algorithm

sim_sample=gibbs('logpost3',start,m,scale,data); 
                  % outputs simulated sample matrix from posterior density

