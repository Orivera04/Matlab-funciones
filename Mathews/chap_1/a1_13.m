echo on; clc;
%---------------------------------------------------------------------------
%A1_13   MATLAB script file for investigating Theorem 1.13
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
% Theorem 1.13  (Taylor's Theorem).
% Section 1.1,   Review of Calculus, Page 10
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Theorem 1.13  (Taylor's Theorem).  Assume that  f(x)  and its
%                               (n)
% derivatives f'(x),f''(x),...,f   (x) are all continuous on [a,b]
%
% Suppose that x  is a fixed value in the interval [a,b].  Then
%               0
%         f(x)  =  P (x) + R (x), where
%                   n       n
%
% P (x)  is the n-th degree Taylor polynomial expanded about x
%  n                                                          0
% and  R (x) is the Lagrange form of the remainder.
%       n
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example on page 10.  Let  f(x) = sin(x).
%
% Find the Taylor polynomial of degree n = 9 for
%
% f(x)  expanded about the point  x  = 0.
%                                  0

n = 9;
f = 'sin(x)';
taylor(f,'x',n+1)
p9 = 'x - x^3/6 + x^5/120 - x^7/5040 + x^9/362880';

pause % Press any key to continue.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot y = f(x).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a =  0;
b =  2*pi;
F = 'sin(X)';
P9 = 'X - X.^3/6 + X.^5/120 - X.^7/5040 + X.^9/362880';
h = (b-a)/100;
X = a:h:b;
Y = eval(F);
Z = eval(P9);

clc; figure(1); clg;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a =  0;
b =  2*pi;
c = -1.05;
d =  1.05;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
title('Graphs of y = sin(x), y = P9(x) over [0 2ƒ].'); figure(gcf);
% fplot(f,[0 2*pi],'-g'); figure(gcf);
plot(X,Y,'-g');
% fplot(p9,[0 2*pi],'-r'); figure(gcf);
plot(X,Z,'-r');
grid;
xlabel('x');
ylabel('y');
hold off
figure(gcf);

clc;

M1 = 'The function y = f(x) and Taylor polynomial P (x) are:';
M2 = '                                             n';
clc;disp(' ');disp(' ');disp(M1);disp(M2);...
disp(' ');disp(['f(x) = ',f]);disp(' ');...
disp(' ');disp(['p9(x) = ',p9]);disp(' ');

