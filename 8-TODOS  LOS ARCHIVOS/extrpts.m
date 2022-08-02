
function vert = extrpts(A, rel, b)

% Extreme points vert of the polyhedral set

%               X = {x: Ax <= b or Ax >= b, x >= 0}.

% Inequality signs are stored in the string rel, e.g.,
% rel = '<<>' stands for <= , <= , and >= , respectively.

[m, n] = size(A);
nlv = n;
for i=1:m
   if(rel(i) == '>')
      A = [A -vr(m,i)];
   else
      A = [A vr(m,i)];
   end
   if b(i) < 0
      A(i,:) = - A(i,:);
      b(i) = -b(i);
   end
end
warning off
[m, n]= size(A);
b = b(:);
vert = [];
if (n >= m)
   t = nchoosek(1:n,m);
   nv = nchoosek(n,m);
   for i=1:nv
      y = zeros(n,1);
      x = A(:,t(i,:))\b;
      if all(x >= 0 & (x ~= inf & x ~= -inf))
         y(t(i,:)) = x;
         vert = [vert y];
      end
   end
else
   error('Number of equations is greater than the number of variables')
end
vert = delcols(vert);
vert = vert(1:nlv,:);






      