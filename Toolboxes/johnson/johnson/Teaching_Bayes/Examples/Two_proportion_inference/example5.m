% EXAMPLE5.m
% -----------------------------------
% Learning about two proportions
% using an exchangeable prior [Albert (1996), p 100].

% Let t1 and t2 denote the logits of p1 and p2.
% To reflect the prior belief that t1 and t2 are similar in size, we
% assume that (1) conditional on m, t1 and t2 are independent normal
% with mean m and standard deviation T and (2) m is distributed standard
% normal.

T=1;    % input the prior standard deviation of each logit
data=[4 16 8 12]%  % data from the two samples
num=1000    % number of simulations in the computation

[p1,p2]=pp_exch(T,data,num);

% p1 is vector containing simulated sample from posterior distribution of p1
% p2 is vector containing simulated sample from posterior distribution of p2

d=p2-p1;        % d contains simulated sample from posterior of difference p2-p1
mean(d),std(d)  % compute posterior mean and standard deviation of differene
