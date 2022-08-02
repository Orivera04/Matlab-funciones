function S = csfit(X,Y,ct)
%---------------------------------------------------------------------------
%CSFIT   Construct a cubic spline through the given points.
% Sample call
%   S = csfit(X,Y,ct)
% Inputs
%   X    vector of abscissas
%   Y    vector of ordinates
%   ct   curve type
% Return
%   S    matrix of spline coefficients
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
% Algorithm 5.4 (Cubic Splines).
% Section	5.3, Interpolation by Spline Functions, Page 297
%---------------------------------------------------------------------------

n = length(X)-1;
if length(ct)==0, ct=2; end
if ct==1, 
  clc,disp(' '),disp('Specify the derivatives:'),
  Mx0 = ['Enter S`(',num2str(X(1)),') = '];
  dx0 = input(Mx0);
  Mxn = ['Enter S`(',num2str(X(n+1)),') = '];
  dxn = input(Mxn);
end
if ct==5, 
  clc,disp(' '),disp('Specify the second derivatives:'),
  Mx0 = ['Enter S``(',num2str(X(1)),') = '];
  ddx0 = input(Mx0); 
  Mxn = ['Enter S``(',num2str(X(n+1)),') = '];
  ddxn = input(Mxn);
end
n = length(X)-1;
H = diff(X);                    % Compute differences.
D = diff(Y)./H;
A = H(2:n-1);
B = 2*(H(1:n-1) + H(2:n));
C = H(2:n);
V = 6*diff(D);
if  ct==1,                      % Modify matrix and column vector.
  B(1) = B(1) - H(1)/2;
  V(1) = V(1) - 3*(D(1)-dx0);
  B(n-1) = B(n-1) - H(n)/2;
  V(n-1) = V(n-1) - 3*(dxn-D(n));
elseif  ct==2,
  M(1) = 0;
  M(n+1) = 0;
elseif  ct==3,
  B(1) = B(1) + H(1) + H(1)*H(1)/H(2);
  C(1) = C(1) - H(1)*H(1)/H(2);
  B(n-1) = B(n-1) + H(n) + H(n)*H(n)/H(n-1);
  A(n-2) = A(n-2) - H(n)*H(n)/H(n-1);
elseif  ct==4,
  B(1) = B(1) + H(1);
  B(n-1) = B(n-1) + H(n);
elseif  ct==5,
  V(1) = V(1) - H(1)*ddx0;
  V(n-1) = V(n-1) - H(n)*ddxn;
end
for k = 2:n-1,                  % Solve tridiagonal system.
  temp = A(k-1)/B(k-1);
  B(k) = B(k) - temp*C(k-1);
  V(k) = V(k) - temp*V(k-1);
end
M(n-1+1) = V(n-1)/B(n-1);
for k = n-2:-1:1,
  M(k+1) = (V(k)-C(k)*M(k+2))/B(k);
end
if  ct==1,                      % Determine the end coefficients.
  M(1) = 3*(D(1)-dx0)/H(1) - M(2)/2;
  M(n+1) = 3*(dxn-D(n))/H(n) - M(n)/2;
elseif  ct==2,
  M(1) = 0;
  M(n+1) = 0;
elseif  ct==3,
  M(1) = M(2) - H(1)*(M(3)-M(2))/H(2);
  M(n+1) = M(n) + H(n)*(M(n)-M(n-1))/H(n-1);
elseif  ct==4,
  M(1) = M(2);
  M(n+1) = M(n);
elseif  ct==5,
  M(1) = ddx0;
  M(n+1) = ddxn;
end
for k = 0:n-1,                  % Compute the spline coefficients.
  S(k+1,1) = Y(k+1);
  S(k+1,2) = D(k+1) - H(k+1)*(2*M(k+1)+M(k+2))/6;
  S(k+1,3) = M(k+1)/2;
  S(k+1,4) = (M(k+2)-M(k+1))/(6*H(k+1));
end
