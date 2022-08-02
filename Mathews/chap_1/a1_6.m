echo on; clc;
%---------------------------------------------------------------------------
%A1_6   MATLAB script file for investigating Theorem 1.6
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
% Theorem 1.6  (Mean Value Theorem).
% Section 1.1,  Review of Calculus, Page 5
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Theorem 1.6  (Mean Value Theorem).  Assume that  f  is continuous
%
% on the interval [a,b] and that  f'(x)  exists for all  a < x < b.
%
% Then there exists a number  c,  with  a < c < b,  such that
%
%                f(b) - f(a)
%      f'(c)  =  -----------  =  m.
%                  b  -   a
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example on page 6.  Consider f(x) = sin(x) over [0.1, 2.1].
%
% According to the Mean Value theorem, there exists a 
%
% value  c  with 0.1 < c < 2.1 such that
%
%                f(2.1) - f(0.1)
%      f'(c)  =  ---------------  =  m.
%                  2.1  -   0.1

% Enter the function  f  and compute m:

m = (sin(2.1) - sin(0.1))/(2.1 -  0.1)
f  = 'sin(x)';
pause;% Press any key to continue.
% Find the function  f'  and where f'(c) = m:
df = diff(f,'x')
solve('cos(x) = 0.38168797500102','x')
c0 = 1.179174480257052;
x = c0;
y0 = eval(f);

pause % Press any key to continue.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare points to plot.
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

x1 = 0.1;
x = x1;
y1 = eval(f);
x2 = 2.1;
x = x2;
y2 = eval(f);

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot y = f(x).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a =  0;
b =  2.2;
F = 'sin(X)';
h = (b-a)/100;
X = a:h:b;
Y = eval(F);

%clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a =  0
b =  2.2
c =  0
d =  1.4
pause %Press any key to continue.
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
title('The Mean Value theorem solves  f`(c) = m.'); figure(gcf);
% fplot(f,[a b],'-g'); figure(gcf);
plot(X,Y,'-g'); figure(gcf);
plot([x1 x2],[y1 y2],'or');
plot([x1 x2],[y1 y2],'-r'); figure(gcf);
plot(c0,y0,'or');
plot([x1 x2],[y0-(c0-x1)*m  y0+(x2-c0)*m],'-r');
plot(c0,0,'or');
plot([c0 c0],[0 y0],'--r');
xlabel('x');
ylabel('y');
grid;
hold off;
clc;
figure(gcf);
 
clc;
pause %Press any key to continue.
%....................................
% Begin section to print the results.
%....................................
disp('f(x)=');
f
disp( '['), disp(num2str(x1)), disp(num2str(x2)),disp(']');
disp('f´(x) = '); disp(df) ;disp('m=');disp(m);
disp('The value c where f´(c) = m is:');
disp(' ');disp(c0);
