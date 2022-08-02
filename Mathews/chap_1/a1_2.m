echo on; clc;
%---------------------------------------------------------------------------
%A1_2   MATLAB script file for investigating Theorem 1.2
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
% Theorem 1.2  (Intermediate Value Theorem).
% Section 1.1,  Review of Calculus, Page 4
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Theorem 1.2  (Intermediate Value Theorem).  Assume that  f
%
% is a continuous function on the interval [a,b] and  L  is
%
% any number between  f(a)  and  f(b).  Then there exists a
%
% value  c  with  a < c < b such that  f(c) = L.
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example on page 4.  Given  f(x) = cos(x-1)  which is a
% 
% continuous function on the interval [0,2.5] and  L = 0.8
%
% Since  f(0) = 0.54030230586814  < L < 1 = f(1)  there exists
%
% a value  c  with  0 < c < 1 such that  f(c ) = L.  Also,
%           1            1                  1
% Since  f(2.5) = 0.07073720166770  < L < 1 = f(1)  there exists
%
% a value  c  with  1 < c < 2.5  such that  f(c ) = L.
%           2            2                     2

pause % Press any key to continue.

clc;

f = 'cos(x-1)';
L = '0.8';
solve('cos(x-1) = 0.8','x')
c1 = 1 - acos(0.8)
y1 = cos(c1-1)
c2 = 1 + acos(0.8)
y2 = cos(c2-1)

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot y = f(x).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = 0;
b = 2.5;
F = 'cos(X-1)';
h = (b-a)/100;
X = a:h:b;
Y = eval(F);

clc; figure(1); clf;

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
title('The intermediate value theorem for y = f(x).'); figure(gcf);
% fplot(f,[a b],'-g'); figure(gcf);
plot(X,Y,'-g');
plot([a b],[y1 y2],'-r');
plot(c1,y1,'or');
plot(c2,y2,'or'); figure(gcf);
plot([c1 c1],[0 y1],'--r');
plot([c2 c2],[0 y2],'--r');
xlabel('x');
ylabel('y');
grid;
hold off;
figure(gcf);

clc;

%....................................
% Begin section to print the results.
%....................................
M1='Assume that  f  is a continuous on [a,b] and'; 
M2='L  is  any number between  f(a)  and  f(b).';
M3='There exists a value  c  with  a < c < b such that  f(c) = L.';
M4='The values  c  and  c  for the intermediate value therorem are:';
M5='             1       2';
clc;disp(' ');disp(' ');disp(M1);disp(M2);disp(M3);...
disp(' ');disp(['f(x) = ' f]);...
disp(' ');disp(['L = ' L]);...
disp(' ');disp(['[a,b] = [' num2str(a) ',' num2str(b) ']']);...
disp(' ');disp(M4);disp(M5);disp(' ');disp([c1 c2]');


