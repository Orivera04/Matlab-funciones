function R = ex6fbd(l,m)

% Computes Rate matrix for Finite Birth and Death Processes
% Usage: l: row vector of birth rates.
%        m: row vector of death rates.

R = diag(l,1) + diag(m,-1);
