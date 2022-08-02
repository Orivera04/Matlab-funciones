function B = rjr(A,k)
%RJR	Random Jacobi Rotations.
%	B = RJR(A) applies a random Jacobi rotation to a square matrix A,
%	preserving its eigenvalues, its singular values, and any symmetry.
%	B = J*A*J', where J is a single random plane rotation.
%
%	B = RJR(A,2) applies two random plane rotations to a rectangular
%	matrix A, preserving its singular values.
%	B = J1*A*J2, where J1 and J2 are two different random plane rotations.

%	R. Schreiber, 1991, CBM, 9-9-93.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

[m,n] = size(A);

% Random rotation of rows.

theta = (2*rand-1)*pi;
c = cos(theta);
s = sin(theta);
i = 1 + fix(rand(1) * m);
j = i;
while (j == i),
   j = 1 + fix(rand(1) * m);
end
B = A;
B(i,:) = c * A(i,:) + s * A(j,:);
B(j,:) = c * A(j,:) - s * A(i,:);

% Possibly different random rotation of columns.

if nargin > 1
   theta = (2*rand-1)*pi;
   c = cos(theta);
   s = sin(theta);
   i = 1 + fix(rand(1) * n);
   j = i;
   while (j == i),
      j = 1 + fix(rand(1) * n);
   end
end
A = B;
B(:,i) = c * A(:,i) + s * A(:,j);
B(:,j) = c * A(:,j) - s * A(:,i);
