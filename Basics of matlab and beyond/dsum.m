function x = dsum(x,k)
%DSUM
%	Differential sum function.  If X is a vector [x(1) x(2) ... x(n)],
%	then DSUM(X) returns a vector of sums between adjacent
%	elements [x(2)+x(1)  x(3)+x(2) ... x(n)+x(n-1)].  If X is a
%	matrix, the sums are calculated down each column:
%	DSUM(X) = X(2:n,:) + X(1:n-1,:).
%	DSUM(X,n) is the n'th differential sum function.

%	Michael Maurer, 22 March 1991, after DIFF.M by J.N. Little 8-30-85

if nargin == 1
	k = 1;
end
for i=1:k
	[m,n] = size(x);
	if m == 1
		x = x(2:n) + x(1:n-1);
	else
		x = x(2:m,:) + x(1:m-1,:);
	end
end
