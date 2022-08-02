function S = houses(n)
% HOUSES  Two houses for use with LIFEX.
%   For small integer n, try
%      lifex(houses(n))
% See also: HOUSE.

H = sparse(n:-1:1,1:n,1,2*n,2*n-1) + ...
    sparse(2:n,n+1:2*n-1,1,2*n,2*n-1);
H(n:2*n,2) = 1;
H(n:2*n,2*n-2) = 1;
H(2*n,2:2*n-2) = 1;
w = floor(n/2)-1; 
H(n+w:2*n,n-w) = 1;
H(n+w:2*n,n) = 1;
H(n+w,n-w:n) = 1;
S = [H 0*H; 0*H rot90(H,2)];
