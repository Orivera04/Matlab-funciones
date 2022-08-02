function y = ortht(a, tol)

[u,s,v] = svd(a,0);
[m,n] = size(a);
if m > 1, s = diag(s);
   elseif m == 1, s = s(1);
   else s = 0;
end
if nargin == 1
  tol = max(m,n) * max(s) * eps;
end;
r = sum(s > tol);
q = u(:,1:r);

