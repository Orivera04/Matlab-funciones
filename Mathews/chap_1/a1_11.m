echo on; clc;
%---------------------------------------------------------------------------
%A1_11   MATLAB script file for investigating Theorem 1.11
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
% Theorem 1.11  (Mean Value Theorem for Integrals).
% Section 1.1,   Review of Calculus, Page 8
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Theorem 1.11  (Mean Value Theorem for Integrals).  If  f  is continuous
%
% over the interval [a,b], then there exists a number c, with a < c < b,
%
%
%                      b
%                 1    /
%  such that    -----  | f(x) dx  =  f(c).
%               b - a  /
%                      a
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example on page 7.  Let  f(x) = sin(x) + sin(3x)/3,  find  c 
%
%                   2.5
%               1    /
% so that     -----  | (sin(x) + sin(3x)/3)dx  =  f(c).
%              2.5   /
%                    0

f = 'sin(x) + 1/3*sin(3*x)'
int(f,'x',0,2.5)
L = 1/(2.5-0)*(-cos(5/2)-1/9*cos(15/2)+10/9)
solve('0.74949587653722 = sin(x) + 1/3*sin(3*x)','x')
c1 = 0.4405654397881374
c2 = 1.268010029510486
c3 = c2 + 2*(pi/2-c2)
x  = c1;
y = eval(f);

pause % Press any key to continue.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot y = f(x).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = 0;
b = 2.5;
F = 'sin(X) + 1/3*sin(3*X)'
h = (b-a)/100;
X = a:h:b;
Y = eval(F);

clc; figure(1); clg;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = 0;
b = 2.5;
c = 0;
d = 1.05;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
title('The mean value theorem for integrals.'); figure(gcf);
% fplot(f,[0 2.5],'-g'); figure(gcf);
plot(X,Y,'-g'); figure(gcf);
plot([0 2.5],[y y],'-r');
plot([c1 c1],[0 y],'--r');
plot([c2 c2],[0 y],'--r');
plot([c3 c3],[0 y],'--r');
grid
hold off
figure(gcf);
clc;

disp(' '); disp(['f(x) = ' f]); disp(' ');...
disp('The value(s) of c are:'); disp(' '); disp([c1 c2 c3]');


clc;

%....................................
% Begin section to print the results.
%....................................
clc;disp(' ');disp(' ');...
disp('The mean value theorem for the integrals.');...
disp(' ');disp(['f(x) = ' f]);...
disp(' ');disp('b');...
disp(' ');disp('/');...
disp(' ');disp('| f(x) dx  =  [b - a]*f(c)');...
disp(' ');disp('/');...
disp(' ');disp('a');...
disp(' ');disp('The value(s) of c are:');...
disp(' ');disp([c1 c2 c3]');disp(' ');
