% example2.m
% computations for roc example of Chapter 5

% load workspace containing roc data and input variables
load roc

% simulate from posterior distribution
[Zij,Z,S,Cats,m0,m1,v0,v1] = roc(N,D,TmT,sampSize,alpha,lambda);
