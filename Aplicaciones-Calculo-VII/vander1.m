% vander1.m
% construct a Vandermonde matrix.

%x=(1:6)';    % column vector for input data
%m=5;         % highest power to compute
V=[];

for i=0:m     % build V column by column
   V=[V x.^(m-i)];
end