echo on; clc;
%---------------------------------------------------------------------------
%A1_1   MATLAB script file for investigating Theorem 1.1
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
% Theorem 1.1  (Limits and Continuous Functions).
% Section 1.1,  Review of Calculus, Page 4
%---------------------------------------------------------------------------

clc; clear all; format short;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Theorem 1.1  (Limits and Continuous Functions).  Assume that
%
% f(x)  is defined on the set  S  and  x  is an element of S.
%                                       0
% The following statements are equivalent:
%
% (i)   The function  f  is continuous at x .
%                                          0
%
% (ii)  If  lim  x  = x , then  lim  f(x ) = f(x ).
%          n->oo  n    0       n->oo    n       0
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example for page 4.  Let  f(x) = sin(x).
%
% If  lim  x  = pi/4,  show that  lim  f(x ) = f(pi/4).
%    n->oo  n                    n->oo    n

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot a sequence of points.
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
f = 'sin(x)';
p = 0:1:15;
h = 2 .^(-p);
x = pi/4 - h;
y = eval(f);
z = zeros(size(x));

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot y = f(x).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = 0;
b = 1.8;
F = 'sin(X)';
h = (b-a)/100;
X = a:h:b;
Y = eval(F);

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
title('The limit of a sequence for  y = sin(x)  at  x = pi/4.'); figure(gcf);
% fplot(f,[a b],'-g');
plot(X,Y,'-g'); figure(gcf);
plot(x,y,'or');
plot(x,z,'+r');
plot(z,y,'+r');
xlabel('x');
ylabel('y');
grid;
hold off;
figure(gcf);

clc;

%....................................
% Begin section to print the results.
%....................................
points = [x;y]';
clc; disp(' '); disp('Table of values for the limit.');...
disp(' '); disp(['      x '  '       f(x )']);...
disp(['       n'  '          n ']);disp(' ');disp(points);

pause % Press any key to continue.

clc;

%**********************************************
% The following examples uses Maple commands
%
% that are ONLY available in the Maple toolbox.
%
%**********************************************

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 1.  Verify that  lim  sin(x) = sin(ƒ/6).
%                         x->ƒ/6

maple('limit','sin(x)','x=pi/6')

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 2.  Verify that  lim  sin(x)/x = 1.
%                         x->0

maple('limit','sin(x)/x','x=0')

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 3.  Verify that  lim  x exp(-x) = 0.
%                         x->oo

maple('limit','x*exp(-x)','x=infinity')
