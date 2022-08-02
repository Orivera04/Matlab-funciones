
function [pts, yi] = evalppf(t, xi, A)


n = length(t);
[p, q] = size(A);
if n-1 ~= p
   error('Vector t and matrix A must be "compatible"')
end
yi = [];
pts = union(t, xi);
for m=1:p
   l = find(pts == t(m));
   r = find(pts == t(m+1));
   if m < n-1
      yi = [yi polyval(A(m,:), pts(l:r-1))];
   else
      yi = [yi polyval(A(m,:), pts(l:r))];
   end
end
