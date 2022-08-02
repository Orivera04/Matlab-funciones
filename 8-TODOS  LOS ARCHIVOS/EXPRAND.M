function values=exprand(mu,n,m);
% Usage:   V = exprand( mu)        % for 1 x 1
%    or    V = exprand( mu, n)     % for n x n
%    or    V = exprand( mu, n, m)  % for n x m
%
% computes a matrix of size n x m, exponentially distributed 
%     with mean mu      (see also unirand, normrand, rand)
if nargin < 1, help exprand, return, end
if nargin == 1, 
    n=1; m=1;
elseif nargin == 2, 
    m=n;
end
 z=rand(n,m);
 z=-log(1-z)*mu;
 values=z;

