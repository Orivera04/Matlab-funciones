% EXAMPLE2.m
% Summarizing posterior density for two-parameter problem
% [Albert (1996), Chapter 11]
%
% Have 2 x 2 contingency table with two unknown proportions p1 and p2.
% We observe the table [1 10;3 12]. If the proportions are transformed 
% to the log odds ratio W and the log odds ratio U, then the log posterior
% density with a noninformative prior is given by
%
% h(W,U)=T1-11 log(1+exp(T1))+3 T2-15 log(1+exp(T2))
%
% where T1=(W+U)/2, T2=(U-W)/2.  This log posterior is programmed in
% the MATLAB function logpost2.m

% Laplace method

data = [1 11 3 15];    % data consists of number of successes and sample size
                       % for each sample
mode = [1 1];          % starting guess at posterior mode
numiter = 10;          % number of iterations of Newton-Raphson

[mode,var,lint]=laplace('logpost2',mode,numiter,data)
                      % outputs posterior mode, estimate at posterior variance,
                      % and Laplace estimate at log integral

% Adaptive quadrature

mom=[0 1 0 1 0];      % estimate at E(W), SD(W), E(U), SD(U), corr(W,U)
numiter = 10;         % number of iterations of algorithm

[lint,mom]=ad_quad2('logpost2',mom,numiter,data)
                     % outputs posterior mean and variance,
                     % and value of log integral

% Gibbs sampling

start=[0 0];      % starting value for simulation
scale=[1 1];      % scale factors for random walk increment density
m=1000;           % number of iterations of algorithm

sim_sample=gibbs('logpost2',start,m,scale,data); 
                  % outputs simulated sample matrix from posterior density

