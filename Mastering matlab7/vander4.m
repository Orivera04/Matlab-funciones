% vander4.m
% construct a Vandermonde matrix.

%x=(1:6)';      % column vector for input data
%m=5;           % highest power to compute
n=length(x);   % number of elements in x

p=m:-1:0;      % column powers
V=repmat(x,1,m+1).^repmat(p,n,1);