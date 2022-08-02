% example1.m
% computations for essay graders example of Chapter 5

% load workspace containing essay graders data and input variables
load essay

% simulate from posterior distribution (without regression)
[Zij, Z, S, Cats, accept] = sampleMulti(N,sampSize,alpha,lambda);

% compute posterior means of latent traits
bZ=mean(Z)';

% simulate from posterior distribution (with regression)
[Zij,Z,S,Cats,B,Sr,accept]=sampReg(N,X,bZ,sampSize,alpha,lambda);
