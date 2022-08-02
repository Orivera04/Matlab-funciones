function [c, v] = condest(A)
%CONDEST Estimate the 1-norm condition number.
%	Higham's modification of Hager's method.
%	[C, V] = CONDEST(A) computes a lower bound C for the 1-norm condition
%	number of A, and a vector V such that NORM(A*V)=NORM(A)*NORM(V)/C.
%	V is an approximate null vector if C is large.

%	Reference: N.J. Higham, FORTRAN codes for estimating the one-norm of
%	a real or complex matrix, with applications to condition estimation,
%	ACM Trans. Math. Soft., 14 (1988), pp. 381-396.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

n = max(size(A));
one = ones(n,1);
maxits = 5;                    % Arbitrary limit on the number of iterations.

[L,U] = lu(A);
k = find(abs(diag(U))==0);
if any(k)
   c = Inf;
   v = zeros(n,1);
   k = min(k);
   v(k) = 1;
   if k > 1
      v(1:k-1) = U(1:k-1,1:k-1)\(-U(1:k-1,k));
   end
   v = v/norm(v,1);
   return
end

if n == 1
   % A nonzero scalar is perfectly conditioned.
   c = 1;
   v = 1;
   return
end 

x = ones(n,1)/n;

v = U\(L\x);      % Av=x
gamma = norm(v, 1);
xi = sign(v); f = find(xi==0); xi(f) = one(f);   % set sign(0) := 1
lastsign = xi;
x = L'\(U'\xi);   % A'x=xi
x = real(x);      % Needed only for the complex case.

for k=2:maxits

    % Get smallest index for which max(abs(z)) is attained.
    [big, j] = max(abs(x)); f = find(abs(x)==big); j = f(1);
    x = zeros(n,1); x(j)=1;

    v = U\(L\x);      % Av=x
    xi = sign(v); f = find(xi==0); xi(f) = one(f);   % set sign(0) := 1

    vold = gamma;
    gamma = norm(v, 1);

    if xi == lastsign | gamma <= vold
       break
    end
    lastsign = xi;

    x = L'\(U'\xi);   % A'x=xi
    x = real(x);      % Needed only for the complex case.

    if norm(x, inf) == x(j), break, end
    if k == maxits
       disp(['Warning: Not converged after ' int2str(maxits) ' iterations.'])
    end
end

x = (0:n-1)';
x = (1-2*rem(x,2)) .* (1 + x/(n-1));
x = U\(L\x);
temp = 2*norm(x,1)/(3*n);
if temp > gamma
   v = x; gamma = temp;
end

anorm = norm(abs(A),1);  % abs for complex case so true 1-norm used.
c = gamma*anorm;
v = v/norm(v,1);
