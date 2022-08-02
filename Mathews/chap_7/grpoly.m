function grpoly(a,b,m,n)
%---------------------------------------------------------------------------
%GRPOLY   To graph a polynomial.
% Sample call
%    grpoly(a,b,m,n)
% Inputs
%   a   left  endpoint of [a,b]
%   b   right endpoint of [a,b]
%   m   number subintervals for drawing curves
%   n   the degree of polynomial approximation
% Return
%   A graph is the output of this function.
%
% NUMERICAL METHODS: MATLAB Programs, (c) John H. Mathews 1995
% To accompany the text:
% NUMERICAL METHODS for Mathematics, Science and Engineering, 2nd Ed, 1992
% Prentice Hall, Englewood Cliffs, New Jersey, 07632, U.S.A.
% Prentice Hall, Inc.; USA, Canada, Mexico ISBN 0-13-624990-6
% Prentice Hall, International Editions:   ISBN 0-13-625047-5
% This free software is compliments of the author.
% E-mail address:      in%"mathews@fullerton.edu"
%---------------------------------------------------------------------------

h = (b - a)/m/n;
X = a:h:b;
Y = f(X);
Xp(1) = a;
Yp(1) = f(a);
for k = 1:m,
  Va = X(n*(k-1)+1);
  Vb = X(n*(k)+1);
  VM = ceil(200/m);
  Vh = (Vb-Va)/VM;
  Vab= X(n*(k-1)+1:n*(k)+1);
  Vyy= f(Vab);
  Px = polyfit(Vab,Vyy,n);
  Vx = Va+Vh:Vh:Vb;
  Vy = polyval(Px,Vx);
  Xp = [Xp,Vx];
  Yp = [Yp,Vy];
end
h = (b-a)/200;
X1 = a:h:b;
Y1 = f(X1);
Z = zeros(size(X));
plot(X,Y,'or',X,Z,'+r',X1,Y1,'-g',Xp,Yp,'-r');
h0 = (b - a)/m;
X = a:h0:b;
Y = f(X);
for k = 1:m+1,
  X0 = X(k);
  Y0 = f(X(k));
  plot([X0 X0],[0 Y0],'-r');
end
figure(gcf);
