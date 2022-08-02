function [T,Z] = rks4(Fn,a,b,Za,m)
%---------------------------------------------------------------------------
%RKS4   Runge-Kutta solution for the system
%       of D.E.'s   Z' = F(t,Z) with Z(a) = Za.
% Sample call
%   [T,Y] = rks4('f',a,b,ya,m)
% Inputs
%   f    name of the function
%   a    left  endpoint of a<=t<=b
%   b    right endpoint of a<=t<=b
%   Za   vector of initial values
%   m    number of steps
% Return
%   T    parameter vector
%   Z    matrix of the vector solutions
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
% Algorithm 9.9 (Linear Shooting Method).
% Section	9.8, Boundary Value Problems, Page 488
%---------------------------------------------------------------------------

h = (b - a)/m;
T = zeros(1,m+1);
Z = zeros(m+1,length(Za));
T(1) = a;
Z(1,:) = Za;
for j=1:m,
  tj = T(j);
  Zj = Z(j,:);
  K1 = h*feval(Fn,tj,Zj);
  K2 = h*feval(Fn,tj+h/2,Zj+K1/2);
  K3 = h*feval(Fn,tj+h/2,Zj+K2/2);
  K4 = h*feval(Fn,tj+h,Zj+K3);
  Z(j+1,:) = Zj + (K1 + 2*K2 + 2*K3 + K4)/6;
  T(j+1) = a + h*j;
end
