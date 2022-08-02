echo on; clc;
%---------------------------------------------------------------------------
%A1_9   MATLAB script file for investigating Theorem 1.9
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
% Theorem 1.9  (First Fundamental Theorem).
% Section 1.1,  Review of Calculus, Page 7
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Theorem 1.9  (First Fundamental Theorem).  If  f  is continuous
%
% over the interval [a,b], then there exists a function  F, called
%
% the antiderivative of  f, such that
%    b
%    /
%    | f(x) dx  =  F(b) - F(a)     where  F'(x) = f(x).
%    /
%    a
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example for page 7.  Let f(x) = tan(x).  Show that
%
%    pi/4
%      /
%      | f(x) dx  =  F(pi/4) - F(-pi/3)      where  F'(x) = f(x).
%      /
%   -pi/3
f = 'tan(x)'
g = int(f,'x')
x = pi/4
Fb = eval(g)
x = -pi/3
Fa = eval(g)
Fb - Fa
% Or use the integrate command with limits of integration:
v =int(f,'x',-pi/3,pi/4)
eval(v)

pause % Press any key to continue.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot y = f(x).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
F = 'tan(X)';
a = -pi/3;
b =  pi/4;
h = (b-a)/100;
X = a:h:b;
Y = eval(F);

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -pi/3;
b =  pi/4;
c = -2;
d =  1;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
title('Integrating the function y = f(x).');
% fplot(f,[a b],'-g');
plot(X,Y,'-g');
xlabel('x');
ylabel('y');
grid;
hold off;

clc;

%....................................
% Begin section to print the results.
%....................................
clc;disp(' ');disp(' ');disp('The value of the integral is;');...
disp(' ');disp(' ');disp(v);disp(' ');disp(eval(v));

