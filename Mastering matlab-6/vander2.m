% vander2.m
% construct a Vandermonde matrix.

x=(1:6)';      % column vector for input data
m=5;           % highest power to compute
n=length(x);   % number of elements in x
V=ones(n,m+1); % preallocate memory for result

for i=1:m      % build V column by column
   V(:,i)=x.^(m+1-i)
end