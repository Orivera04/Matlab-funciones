echo on; clc;
%---------------------------------------------------------------------------
%A1_4   MATLAB script file for investigating Theorem 1.4
%
% NUMERICAL METHODS: MATLAB Programs, (c) John H. Mathews 1995
% To accompany the text:
% NUMERICAL METHODS for Mathematics, Science and Engineering, 2nd Ed, 1992
% Prentice Hall, Englewood Cliffs, New Jersey, 07632, U.S.A.
% Prentice Hall, Inc.; USA, Canada, Mexico ISBN 0-13-624990-6
% Prentice Hall, International Editions:   ISBN 0-13-625047-5
% This free software is compliments of the author.
% E-mail address:       in%"mathews@fullerton.edu"
%
% Theorem 1.4  (Differentiable function implies continuous function).
% Section 1.1,  Review of Calculus, Page 5
%---------------------------------------------------------------------------

clc; clear all; format short;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Theorem 1.4  (Differentiable function implies continuous function).
%
% If  f(x)  is differentiable at  x = x , then  f(x) is
%                                      0
% continuous at x .
%                0
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example for page 5.  Let  f(x) = sin(x+1).  Investigate the
%
% derivative via limiting slopes of secant lines at  x  = 0.
%                                                     0

f  = 'sin(x+1)';
df = 'cos(x+1)';

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot y = f(x).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = 0;
b = 1.1;
F = 'sin(X+1)';
h = (b-a)/100;
X = a:h:b;
Y = eval(F);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = 0;
b = 1.1;
c = 0;
d = 1.1;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
title('The function y = f(x) is differentiable at x = 0.'); figure(gcf);
% fplot(f,[a b],'-g'); figure(gcf);
plot(X,Y,'-g'); figure(gcf);
for j = 1:14,
  x = a;
  y = eval(f);
  x0 = x;
  y0 = y;
  x = a + 1/2^j;
  y = eval(f);
  x1 = x;
  y1 = y;
  dx = x1-x0;
  dy = y1-y0;
  m = dy/dx;
  dX = [dx, dx];
  dY = [dy, dy];
  M = [m, m];
  plot([x0, b-a],[y0, y0+(b-a)*m],'-r'); figure(gcf);
end
xlabel('x');
ylabel('y');
grid;
hold off;
figure(gcf); 

%....................................
% Begin section to print the results.
%....................................
points = [dX; dY; M]';
clc; disp(' '); disp('Table of values for the derivative.');...
disp(' '); disp(['      dx '  '       dy' '       dy/dx']);...
disp(' ');disp(points);

pause % Press any key to continue.

clc;

f = 'sin(x+1)';
p = 0:1:13;
h = 2 .^(-p);
x = h;
y = eval(f);
z = zeros(size(x));

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot y = f(x).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = 0;
b = 1.8;
F = 'sin(X+1)';
h = (b-a)/100;
X = a:h:b;
Y = eval(F);

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = 0;
b = 1.8;
c = 0;
d = 1.05;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
title('The function y = f(x) is continuous at x = 0.'); figure(gcf);
% fplot(f,[a b],'-g'); figure(gcf);
plot(X,Y,'-g'); figure(gcf);
plot(x,y,'or');
plot(x,z,'+r');
plot(z,y,'+r');
xlabel('x');
ylabel('y');
grid;
hold off;
figure(gcf);

%....................................
% Begin section to print the results.
%....................................
points = [x;y]';
clc; disp(' '); disp('Table of values for the limit.');...
disp(' '); disp(['      x '  '       f(x )']);...
disp(['       n'  '          n ']);disp(' ');disp(points);
