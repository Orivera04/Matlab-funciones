function out = uniq(in)
%UNIQ	Return a vector where neighboring same elements are reduced to
%	a single element. Used in CART.

%	Roger Jang, 7-31-1995

in = in(:)';
in = [in in(length(in))+1];
index = find(diff(in) ~= 0);
out = in(index);
