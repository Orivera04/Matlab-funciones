
function [pts, y] = evalpdf(x, pt, A)


y = [];
n = length(x);
pts = union(x, pt);
[p, q] = size(A);
for m=1:p
   for k=1:n-1
      l = find(pts == x(k));
      r = find(pts == x(k+1));
      if k < n-1
         y = [y polyval(A(m,:), pts(l:r-1))];
      else
         y = [y polyval(A(m,:), pts(l:r))];
      end
   end
end
y = reshape(y',length(pts),p);





