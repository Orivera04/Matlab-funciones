echo on; clc;
%---------------------------------------------------------------------------
%A8_1   MATLAB script file for implementing Algorithm 8.1
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
% Algorithm 8.1 (Golden Search for a Minimum).
% Section	8.1, Minimization of a Function, Page 413
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program finds a local minimum of a function f(x).
%
% The method is the golden ratio search.
%
% It is assumed that f(x) is unimodal over [a,b].
%
%
%
% The function f(x) is to be placed in the M-file  f.m
% function z = f(x)
% z = x.^2 - sin(x);

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
            disp('z = x.^2 - sin(x);');...
diary off;
f(0); % Remark. f.m and golden.m are used for Algorithm 8.1
pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 8.2, page 404.  Use the golden ratio search
% to find a local minimum of the function
% f(x) = x^2 - sin(x)  over the interval [a,b].
%
% A graph of the function will be drawn.
%
% Enter the endpoints a and b of the interval [a,b].

a  = 0;

b  = 1;

pause % Press any key to graph the function.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
hs = (b-a)/150;
Xs = a:hs:b;
Ys = f(Xs);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -0.05;
b =  1.05;
c = -0.25;
d =  0.16;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(Xs,Ys,'g');
xlabel('x');
ylabel('y');
title('To search for the minimum of y = f(x).');
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 8.2, page 404.  Use the golden ratio search
% to find a local minimum of the function
% f(x) = x^2 - sin(x)  over the interval [a,b].
%
% Enter the endpoints a and b of the interval [a,b].
% Enter the tolerance for the abscissas in  delta.
% Enter the tolerance for the ordinates in  epsilon.

a  = 0;
b  = 1;
delta = 1e-5;
epsilon = 1E-7;

[p,yp,dp,dy,A,B,C,D] = golden('f',a,b,delta,epsilon);

pause % Press any key to find the minimum of f(x).

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
hs = (b-a)/150;
Xs = a:hs:b;
Ys = f(Xs);
X1 = A(1:7); Y1 = f(X1);
X2 = B(1:7); Y2 = f(X2);
X3 = C(1:7); Y3 = f(X3);
X4 = D(1:7); Y4 = f(X4);

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a =  0;
b =  1;
c = -0.25;
d =  0.175;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(Xs,Ys,'g',X1,Y1,'or',X2,Y2,'or',X3,Y3,'or',X4,Y4,'or');
xlabel('x');
ylabel('y');
title('The golden search for the minimum of y = f(x).');
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'The results for the golden ratio search.';
Mx2 = 'The solution is [p  f(p)];';
Mx3 = 'The  abscissa  p ';
Mx4 = 'error bound for p';
Mx5 = 'The minimum value f(p)';
Mx6 = 'error bound for f(p)';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(''),...
disp(Mx3),disp(p),disp(Mx4),disp(['~ ',num2str(abs(dp))]),disp(''),...
disp(Mx5),disp(yp),disp(Mx6),disp(['~ ',num2str(abs(dy))]),diary off,echo on
pause % Press any key to see all the iterations.

clc;
% Prepare results
Z = [A;C;D;B]';

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx7 = 'The complete list of iterations:';
Mx8 = '     a(k)      d(x)      d(k)       b(k)';
clc,echo off,diary output,format short,...
disp(''),disp(Mx7),disp(''),disp(Mx8),disp(Z),diary off,echo on
