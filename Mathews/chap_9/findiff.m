function [T,X] = findiff(p,q,r,a,b,alpha,beta,n)
%---------------------------------------------------------------------------
%FINDIFF   Finite difference solution to the boundary value problem
%          x`` = p(t)x`(t)+q(t)x(t)+r(t), x(a) = alpha, x(b) = beta
%          This subroutine uses trisys.m to solve a tri-diagonal system.
% Sample call
%   [T,X] = findiff('p','q','r',a,b,alpha,beta,n)
% Inputs
%   p       name of the function
%   q       name of the function
%   r       name of the function
%   a       left  endpoint of [a,b]
%   b       right endpoint of [a,b]
%   alpha   left  boundary value
%   beta    right boundary value
%   n       number of steps
% Return
%   T       solution: vector of abscissas
%   X       solution: vector of ordinates
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
% Algorithm 9.10. (Finite-Difference Method).
% Section	9.9, Finite-Difference Method, Page 496
%---------------------------------------------------------------------------

T  = zeros(1,n+1);
X  = zeros(1,n-1);
Va = zeros(1,n-2);
Vb = zeros(1,n-1);
Vc = zeros(1,n-2);
Vd = zeros(1,n-1);
h = (b - a)/n;
for j=1:n-1,
  Vt(j) = a + h*j;
end
for j=1:n-1,
  Vb(j) = -h^2*feval(r,Vt(j));
end
Vb(1)   = Vb(1)   + (1 + h/2*feval(p,Vt(1)))*alpha;
Vb(n-1) = Vb(n-1) + (1 - h/2*feval(p,Vt(n-1)))*beta;
for j=1:n-1,
  Vd(j) = 2 + h^2*feval(q,Vt(j));
end
for j=1:n-2,
  Va(j) = -1 - h/2*feval(p,Vt(j+1));
end
for j=1:n-2,
  Vc(j) = -1 + h/2*feval(p,Vt(j));
end
X = trisys(Va,Vd,Vc,Vb);
T = [a,Vt,b];
X = [alpha,X,beta];
