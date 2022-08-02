function R = ex6ssq(l,m,K)

% Computes Rate matrix for Finite Capacity Single Server Queue
% Usage: l: arrival rate;
%        m: service rate m;
%        K: capacity;

R = ex6fbd(l*ones(1,K), m*ones(1,K));
