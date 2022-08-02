function values=unirand(a,b,n,m);
% Usage:   V = unirand( a,b)        % for 1 x 1
%    or    V = unirand( a,b, n)     % for n x n
%    or    V = unirand( a,b, n, m)  % for n x m
%
% computes a matrix of size n x m, uniformly distributed in (a,b)
%                              (see also exprand, normrand, rand)
if nargin < 2, help unirand, return, end
if nargin == 2, 
    n=1; m=1;
elseif nargin == 3, 
    m=n;
end
 z=rand(n,m);
 z=z*(b-a)+a;
 values=z;

