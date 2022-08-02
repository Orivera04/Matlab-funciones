% vander2.m
% construct a Vandermonde matrix.

x=(1:6)';      % column vector for input data
m=5;           % highest power to compute
n=length(x);   % number of elements in x
V=ones(n,m+1) % preallocate memory for result

for i=0:m-1    % build V column by column
   V(:,i+1)=x.^(m-i)
end