% vander6.m
% construct a Vandermonde matrix.

%x=(1:6)';      % column vector for input data
%m=5;           % highest power to compute
n=length(x);   % number of elements in x

V=ones(n,m+1);
V(:,2:end)=cumprod(x(:,ones(1,m)),2);
V=V(:,m+1:-1:1);
