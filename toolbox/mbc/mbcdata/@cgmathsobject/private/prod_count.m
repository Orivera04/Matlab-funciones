function out = prod_count(i,N);
%PROD_COUNT
% Suppose you have n1 objects in container 1, n2 in container 2 up to nm in container m
% then the number of ways to take one object out of each container is n1 times n2 times ... times nm. 
% OUT = PROD_COUNT(I,N) for I less than this number, gives a row vector that represents the 'Ith' such combination. 
% OUT will be an 1 by m vector the jth entry of which will be the index of the element in the jth container that you want
% (minus 1).
%
% M = [];
% N = [2,3,5];
% for i = 0:29
%     M = [M;prod_count(i,N)];
% end
% M
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:50:15 $

if length(N)==1;
   out = i;
else
   out = [fix(i/prod(N(2:end))),...
         prod_count(i-fix(i/prod(N(2:end)))*prod(N(2:end)),...
         N(2:end))];
end
