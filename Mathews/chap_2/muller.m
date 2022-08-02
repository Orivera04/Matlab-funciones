function [p2,y2,err,P] = muller(f,p0,p1,p2,delta,epsilon,max1)
%---------------------------------------------------------------------------
%MULLER   Muller's method is used to locate a root
% Sample calls
%   [p2,y2,err] = muller('f',p0,p1,p2,delta,epsilon,max1)
%   [p2,y2,err,P] = muller('f',p0,p1,p2,delta,epsilon,max1)
% Inputs
%   f         name of the function
%   p0        starting value
%   p1        starting value
%   p2        starting value
%   delta     convergence tolerance for p2
%   epsilon   convergence tolerance for y2
%   max1      maximum number of iterations
% Return
%   p2        solution: the root
%   y2        solution: the function value
%   err       error estimate in the solution for p2
%   P         History vector of the iterations
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
% Algorithm 2.8 (Muller's Method).
% Section	2.5, Aitken's Process & Steffensen's & Muller's Methods, Page 97
%---------------------------------------------------------------------------

P(1) = p0;
P(2) = p1;
P(3) = p2;
y0  = feval(f,p0);
y1  = feval(f,p1);
y2  = feval(f,p2);
for k=1:max1,
  h0 = p0 - p2;
  h1 = p1 - p2;
  c  = y2;
  e0 = y0 - c;
  e1 = y1 - c;
  det1 = h0*h1*(h0-h1);
  a  = (e0*h1 - h0*e1)/det1;
  b  = (h0^2*e1 - h1^2*e0)/det1;
  if  b^2 > 4*a*c,
    disc = sqrt(b^2 - 4*a*c);
  else
    disc = 0;
  end
  if b < 0, disc = - disc; end
  z = - 2*c/(b + disc);
  p3 = p2 + z;
  if  abs(p3-p1) < abs(p3-p0),
    u = p1;
    p1 = p0;
    p0 = u;
    v = y1;
    y1 = y0;
    y0 = v;
  end
  if  abs(p3-p2) < abs(p3-p1),
    u = p2;
    p2 = p1;
    p1 = u;
    v = y2;
    y2 = y1;
    y1 = v;   
  end
  p2 = p3;
  y2 = feval(f,p2);
  P = [P,p2];
  err = abs(z);
  relerr = err/(abs(p3)+eps);
  if (err<delta)|(relerr<delta)|(abs(y1)<epsilon), break, end
end
