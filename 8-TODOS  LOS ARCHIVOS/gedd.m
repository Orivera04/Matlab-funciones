clear;
%  Solves a block tridiagonal SPD algebraic system.
%  Uses domain-decomposition and Schur complement.
%  Define the block 5x5 matrix AAA
n = 5;
A = zeros(n);
for i = 1:n
   A(i,i) = 4;
   if (i>1) 
       A(i,i-1)=-1;
   end
   if (i<n)
       A(i,i+1)=-1;
   end
end      
   I = eye(n);
   AA= zeros(n*n);
   for i =1:n
      newi = (i-1)*n +1;
      lasti = i*n;
      AA(newi:lasti,newi:lasti) = A;
      if (i>1)
          AA(newi:lasti,newi-n:lasti-n) = -I;
      end
      if (i<n)
          AA(newi:lasti,newi+n:lasti+n) = -I;
      end
   end
   
Z = zeros(n);
A0 = [A Z Z;Z A Z;Z Z A];
A1 = zeros(n^2,3*n);
A1(n^2-n+1:n^2,1:n)=-I;
A2 = zeros(n^2,3*n);
A2(1:n,1:n) = -I;
A2(n^2-n+1:n^2,n+1:2*n) = -I;
A3 = zeros(n^2,3*n);
A3(1:n,n+1:2*n) = -I;
A3(n^2-n+1:n^2,2*n+1:3*n) = -I;
A4 = zeros(n^2,3*n);
A4(1:n,2*n+1:3*n) = -I;
ZZ =zeros(n^2);
% Define 5x5 block matrix
AAA = [AA ZZ ZZ ZZ A1;
   ZZ AA ZZ ZZ A2;
   ZZ ZZ AA ZZ A3;
   ZZ ZZ ZZ AA A4;
   A1' A2' A3' A4' A0];
%  Define the right side
d1 =ones(n*n,1)*10*(1/(n+1)^2);
d2 =ones(n*n,1)*10*(1/(n+1)^2);
d3 =ones(n*n,1)*10*(1/(n+1)^2);
d4 =ones(n*n,1)*10*(1/(n+1)^2);
d0 =ones(3*n,1)*10*(1/(n+1)^2);
d = [d1' d2' d3' d4' d0']';
%   Start the Schur complement method
%   Parallel computation with four processors
Z1 = AA\[A1 d1];
Z2 = AA\[A2 d2];
Z3 = AA\[A3 d3];
Z4 = AA\[A4 d4];
%   Parallel computation with four processors
W1 = A1'*Z1;
W2 = A2'*Z2;
W3 = A3'*Z3;
W4 = A4'*Z4;
%  Define the Schur complement system.
Ahat = A0 -W1(1:3*n,1:3*n) - W2(1:3*n,1:3*n) - W3(1:3*n,1:3*n) -W4(1:3*n,1:3*n);
dhat = d0 -W1(1:3*n,1+3*n) -W2(1:3*n,1+3*n) -W3(1:3*n,1+3*n) -W4(1:3*n,1+3*n);
%  Solve the Schur complement system.
x0 = Ahat\dhat;
%   Parallel computation with four processors
x1 = AA\(d1 - A1*x0);
x2 = AA\(d2 - A2*x0);
x3 = AA\(d3 - A3*x0);
x4 = AA\(d4 - A4*x0);
%  Compare with the full Gauss elimination method.
norm(AAA\d - [x1;x2;x3;x4;x0])