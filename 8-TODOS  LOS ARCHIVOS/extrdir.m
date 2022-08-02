

function d = extrdir(A, rel, b)

% Extreme directions d of the polyhedral set

%            X = {x: Ax <= b, or Ax >= b, x >= 0}.

% Matrix A must be of the full row rank.

[m, n] = size(A);
n1 = n;
for i=1:m
   if(rel(i) == '>')
      A = [A -vr(m,i)];
   else
      A = [A vr(m,i)];
   end
end
[m, n] = size(A);
A = [A;ones(1,n)];
b = [zeros(m,1);1];
d = feassol(A,b);
if ~isempty(d)
   d1 = d(1:n1,:);
   d = delcols(d1);
   s = sum(d);
   for i=1:n1
      d(:,i) = d(:,i)/s(i);
   end
else
   d = [];
end



