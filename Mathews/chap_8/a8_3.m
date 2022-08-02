echo on; clc;
%---------------------------------------------------------------------------
%A8_3   MATLAB script file for implementing Algorithm 8.3
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
% Algorithm 8.3 (Local Minimum Search: Quadratic Interpolation).
% Section	8.1, Minimization of a Function, Page 416
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program finds a local minimum of a function f(x).
%
% The method is quadratic interpolation.
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
f(0); % Remark. f.m and quadmin.m are used for Algorithm 8.3
pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example, from page 404.  Use the local minimum search
% involving quadratic interpolation to find a local minimum
% of the function  f(x) = x^2 - sin(x)  over the interval [a,b].
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

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example, from page 404.  Use the local minimum search
% involving quadratic interpolation to find a local minimum
% of the function  f(x) = x^2 - sin(x)  over the interval [a,b].
%
% Enter the endpoints a and b of the interval [a,b].
% Enter the tolerance for the abscissas in  delta.
% Enter the tolerance for the ordinates in  epsilon.

a  = 0;
b  = 1;
delta = 1e-14;
epsilon = 1E-15;

[p,yp,dp,dy,P] = quadmin('f',a,b,delta,epsilon);

pause % Press any key to find the minimum of f(x).

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
hs = (b-a)/150;
Xs = a:hs:b;
Ys = f(Xs);
YP = f(P);

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
plot(Xs,Ys,'g',P,YP,'or');
xlabel('x');
ylabel('y');
title('Searching for the minimum of y = f(x).');
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'The results for a quadratic minimization search.';
Mx2 = 'The solution is [p  f(p)];';
Mx3 = 'The  abscissa  p ';
Mx4 = 'error bound for p';
Mx5 = 'The minimum value f(p)';
Mx6 = 'error bound for f(p)';
Mx7 = 'The list of iterations is:';
Mx8 = '     p(k)               f(p(k))';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(''),...
disp(Mx3),disp(p),disp(Mx4),disp(['~ ',num2str(abs(dp))]),disp(''),...
disp(Mx5),disp(yp),disp(Mx4),disp(['~ ',num2str(abs(dy))]),...
disp(''),disp(Mx7),disp(Mx8),disp([P;YP]'),diary off,echo on
