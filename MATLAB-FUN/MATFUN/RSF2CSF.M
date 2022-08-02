function [U,T] = rsf2csf(U,T)
%RSF2CSF Real block diagonal form to complex diagonal form.
%	[U,T] = RSF2CSF(U,T) converts a real, upper quasi-triangular
%	Schur form to a complex, upper triangular Schur form.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Find complex unitary similarities to zero subdiagonal elements.
n = max(size(T));
m = n;
while m > 1,
   s = abs(T(m-1,m-1)) + abs(T(m,m));
   if s + abs(T(m,m-1)) > s
      k = m-1:m;
      mu = eig(T(k,k)) - T(m,m);
      r = norm([mu(1), T(m,m-1)]);
      c = mu(1)/r;  s = T(m,m-1)/r;
      G = [c' s; -s c];
      j = m-1:n;  T(k,j) = G*T(k,j);
      i = 1:m;  T(i,k) = T(i,k)*G';
      i = 1:n;  U(i,k) = U(i,k)*G';
   end
   T(m,m-1) = 0;
   m = m-1;
end
