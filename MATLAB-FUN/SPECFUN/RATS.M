function S = rats(X,lens)
%RATS	Rational output.
%	RATS(X,LENS) uses RAT to display rational approximations to
%	the elements of X.  The string length for each element is LENS.
%	The default is LENS = 13, which allows 6 elements in 78 spaces.
%	Asterisks are used for elements which can't be printed in the
%	alloted space, but which are not negligible compared to the other
%	elements in X.
%
%	The same algorithm, with the default LENS, is used internally
%	by MATLAB for FORMAT RAT.
%
%	See also FORMAT, RAT.

%	Cleve Moler, 10-28-90, 2-15-94.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin < 2, lens = 13; end
lhalf = fix(lens/2);
tol = 10^(-lhalf) * norm(X(:),1);
[N,D] = rat(X,tol);
[m,n] = size(X);
ints = all(all(D == 1));
if ints
   nform = ['%' num2str(lens) '.0f'];
else
   nform = ['%' num2str(lhalf) '.0f'];
   dform = ['%-' num2str(lhalf) '.0f'];
end
S = [];
for i = 1:m
    s = [];
    for j = 1:n
        sj = sprintf(nform,N(i,j));
        if D(i,j) ~= 1
            sj = [sj '/' sprintf(dform,D(i,j))];
        elseif ~ints
            sj = [' ' sj '      '];
        end
        if length(sj) > lens
            k = 1:(length(sj)-lens);
            if all(sj(k) == ' ')
               sj(k) = [];
            elseif ints
               sj = [blanks(lens-1) '*'];
            else
               sj = [blanks(lhalf) '*' blanks(lens-lhalf-1)];
            end
        end
        s = [s sj];
    end
    S(i,:) = s;
end
