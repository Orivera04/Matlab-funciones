function R = ex6inv(l,m,k,r)

% Computes Rate matrix for Inventory Systems
% Usage: l: arrival rate deliveries,
%        m: arrival rate of demands,
%        k: base stock,
%        r: order size.

R = diag(m*ones(1,k+r),-1) + diag(l*ones(1,k+1),r) ;
