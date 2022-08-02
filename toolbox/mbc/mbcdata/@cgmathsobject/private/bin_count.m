function out = bin_count(i,n,k);
%BIN_COUNT
% OUT = BIN_COUNT(I,N,K) returns a column vector of k ones and n-k zeros where the pattern is the 'Ith'
% such pattern out of the N-choose-K ways of coming up with such a pattern.
% M = [];
% for i = 1:35
%     out = eval(cgmathsobject, 'bin_count', i, 7, 4)
%     M = [M, out];
% end
% M

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:50:03 $

if k<n-1/2;
   C = prod(n-k+1:n-1)/(prod(1:k-1));
else
   C = prod(k:n-1)/prod(1:n-k);
end


if i > C;
   out = [0;bin_count(i-C,n-1,k)];
else
   if k > 1
      out = [1;bin_count(i,n-1,k-1)];
   else
      out = zeros(n,1);
      out(i) =1; 
   end
end
