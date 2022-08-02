function C = max_star(A, B, star)
%MAX_STAR returns the max-star composition of given matrices.
%	MAX_STAR(A, B, STAR) returns the max-star composition of A and B.
%	STAR is either 'min' or 'prod'.

%	Roger Jang, 6-28-93.

[m,n] = size(A);
[p,q] = size(B);

if (n ~= p) error('Given matrices have incompatible sizes.'); end
if nargin == 2, star = 'min'; end
if nargin < 2, error('Need at least two input argument.'); end
if ~strcmp(star, 'min') & ~strcmp(star, 'prod'),
	error('The third argument should be either ''min'' or ''prod''.');
end

C = zeros(m,q);
for i = 1:m
	for j = 1:q
		C(i,j) = 0;
		for k=1:n
			if strcmp(star, 'min'),
				tmp = min(A(i, k), B(k, j));
			else
				tmp = A(i, k)*B(k, j);
			end
			C(i,j) = max(C(i,j), tmp);
		end

	end
end
