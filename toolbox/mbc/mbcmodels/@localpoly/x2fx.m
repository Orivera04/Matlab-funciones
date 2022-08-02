function V= x2fx(p,x);
% POLYNOM/X2FX generates X matrix for regression

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:40:54 $

x=x(:);
n=length(double(p))-1;
% Construct Vandermonde matrix.
V(:,n+1) = ones(length(x),1);
for j = n:-1:1
   V(:,j) = x.*V(:,j+1);
end
