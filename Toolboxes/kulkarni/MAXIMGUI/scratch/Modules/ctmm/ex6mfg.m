function R = ex6mfg(l,m,k,K)

% Compute Rate matrix for Manufacturing System
% Usage: l: production rate,
%        m: demand rate,
%        k: the machine is turned on when the inventory decreases to k,
%        K: storage capacity.

R = diag([l*ones(1,K) m*ones(1,K-k-1)],1) + diag([m*ones(1,K-1) zeros(1,K-k)],-1) ;
R(2*K-k,k+1) = m ;
