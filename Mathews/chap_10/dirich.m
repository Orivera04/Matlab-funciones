function U = dirich(f1,f2,f3,f4,a,b,h,tol,max1)
%---------------------------------------------------------------------------
%DIRICH   Dirichlet solution to Laplace's equation.
% Sample call
%   U = dirich('f1','f2','f3','f4',a,b,h,tol,max1)
% Inputs
%   f1     name of a boundary function
%   f2     name of a boundary function
%   f3     name of a boundary function
%   f4     name of a boundary function
%   a      width of interval [0 a]: 0<=x<=a
%   b      width of interval [0 b]: 0<=y<=b
%   h      step size
%   tol    convergence tolerance    
%   max1   maximum number of iterations
% Return
%   U      solution: matrix
%
% NUMERICAL METHODS: MATLAB Programs, (c) John H. Mathews 1995
% To accompany the text:
% NUMERICAL METHODS for Mathematics, Science and Engineering, 2nd Ed, 1992
% Prentice Hall, Englewood Cliffs, New Jersey, 07632, U.S.A.
% Prentice Hall, Inc.; USA, Canada, Mexico ISBN 0-13-624990-6
% Prentice Hall, International Editions:   ISBN 0-13-625047-5
% This free software is compliments of the author.
% E-mail address:      in%"mathews@fullerton.edu"
%
% Algorithm 10.4 (Dirichlet Method for Laplace's Equation).
% Section	10.3, Elliptic Equations, Page 531
%---------------------------------------------------------------------------

n = fix(a/h)+1;
m = fix(b/h)+1;
ave = (a*(feval(f1,0)+feval(f2,0)) ...
    +  b*(feval(f3,0)+feval(f4,0)))/(2*a+2*b);
U = ave*ones(n,m);
for j=1:m,
  U(1,j) = feval(f3,h*(j-1));
  U(n,j) = feval(f4,h*(j-1));
end
for i=1:n,
  U(i,1) = feval(f1,h*(i-1));
  U(i,m) = feval(f2,h*(i-1));
end
U(1,1) = (U(1,2) + U(2,1))/2;
U(1,m) = (U(1,m-1) + U(2,m))/2;
U(n,1) = (U(n-1,1) + U(n,2))/2;
U(n,m) = (U(n-1,m) + U(n,m-1))/2;
w = 4/(2+sqrt(4-(cos(pi/(n-1))+cos(pi/(m-1)))^2));
err = 1;
cnt = 0;
while ((err>tol)&(cnt<=max1))
  err = 0;
  for j=2:(m-1),
    for i=2:(n-1),
      relx = w*(U(i,j+1)+U(i,j-1)+U(i+1,j)+ U(i-1,j)-4*U(i,j))/4;
      U(i,j) = U(i,j) + relx;
      if (err<=abs(relx)), err=abs(relx); end
    end
  end
  cnt = cnt+1;
end
