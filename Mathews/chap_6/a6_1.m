echo on; clc;
%---------------------------------------------------------------------------
%A6_1   MATLAB script file for implementing Algorithm 6.1
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
% Algorithm 6.1 (Differentiation Using Limits).
% Section	6.1, Approximating the Derivative, Page 326
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program finds a numerical approximation for f'(x0).
%
% The method employed is the limit process.
%
%
%
% The function f(x) is stored in the M-file  f.m
%
% function z = f(x)
% z = cos(x);

pause % Press any key to continue.

clc;
%.......................................................................
% Begin a section which enters the function(s) necessary for the example
% into M-file(s) by executing the diary command in this script file.
% The preferred programming method is not to use these steps.
% One should enter the function(s) into the M-file(s) with an editor.
delete output
delete f.m
diary  f.m; disp('function z = f(x)');...
            disp('z = cos(x);');...
diary off;
f(0); % Remark. f.m and difflim.m are used for Algorithm 6.1
pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 6.2, page 320  Find a numerical approximation for the
% derivative  f'(x)  for the function  f(x) = cos(x).
%
% Enter the abscissa for differentiation in x0.
%
% Enter the endpoints interval [a,b] about x0 in a and b.

x0 = 0.8;

a  = 0;

b  = pi/2;

y0 = f(x0);

pause % Press any key to graph the function.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
h  = (b-a)/100;
Xs = a:h:b;
Ys = f(Xs);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = 0;
b = 1.6;
c = 0;
d = 1.1;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(x0,y0,'or',Xs,Ys,'g');
xlabel('x');
ylabel('y');
title('y = f(x) and the given point');
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 6.2, page 320  Find a numerical approximation for the
% derivative  f'(x)  for the function  f(x) = cos(x).
%
% Enter the abscissa for differentiation in x0.
%
% Enter the tolerance in  toler.

x0 = 0.8;

toler = 1e-12;

[H,D,E,n] = difflim('f',x0,toler);

pause % Press any key to see the approximate derivative.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
X1 = [a b];
C = [D(n) f(x0)];
Y1 = polyval(C,X1-x0);

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -0.05;
b =  1.6;
c = -0.05;
d =  1.05;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(x0,y0,'or',Xs,Ys,'-g',X1,Y1,'-r');
xlabel('x');
ylabel('y');
title('The tangent line has slope m = f`(x0).');
grid;
hold off;
figure(gcf); pause % Press any key to continue.

points = [H;D];

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx0 = 'Approximating the derivative by finding a limit.';
Mx1 = 'Numerical approximations for ';
Mx2 =  ['f`(',num2str(x0),')'];
Mx3 = [Mx1,Mx2];
Mx4 = 'The approximate value of ';
Mx5 = [Mx4,Mx2,' = '];
Mx6 = 'An estimate for the error bound is:';
Mx7 = ' approx. derivative   +- error bound';
clc,echo off,diary output,...
disp(''),disp(Mx0),disp(''),disp(Mx3),...
disp('     h                  D(k)'),disp(points'),...
disp(''),disp(Mx5),disp(D(n)),...
disp(Mx6),disp(Mx7),disp([D(n) E(n)]),diary off,echo on
