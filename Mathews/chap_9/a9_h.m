echo on; clc;
%---------------------------------------------------------------------------
%A9_h   MATLAB script file for implementing Algorithm 9.h
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
% Algorithm 9.h (Runge-Kutta Method for a higher order).
% Section	9.7, Runge-Kutta Methods, Page 475
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program implements the Runge-Kutta method
% for solving a second-order initial value problem:
%     x'' = f(t,x,x')     with     x(a) = xa  
%                                 x'(a) = ya
%
% Which is equivalent to solving the system:
%      x' = y             with     x(a) = xa
%      y' = f(t,x,y)               y(a) = ya
%
%
% The formula for f(t,x,y) is used to form the
% vector function F(t,Y) which is stored in fn.m 
% function W = fn(t,Z)
% x = Z(1);  y = Z(2);
% W = [y, -5*x-4*y];

pause % Press any key to continue.

clc;
%.......................................................................
% Begin a section which enters the function(s) necessary for the example
% into M-file(s) by executing the diary command in this script file.
% The preferred programming method is not to use these steps.
% One should enter the function(s) into the M-file(s) with an editor.
delete output
delete fn.m
diary fn.m; disp('function W = fn(t,Z)');...
            disp('x = Z(1);  y = Z(2);');...
            disp('W = [y, -5*x-4*y];');...
diary off;
fn(0,[0 0]); % Remark.  fn.m and rks4 are used in Algorithm 9.H
pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 9.16, page 479.  Use the Runge-Kutta method to solve
% the second-order differential equation  x'' + 4x' + 5x = 0.
% 
% Enter the endpoints a and b of the interval a<=t<=b.
% Enter the initial value  Z(a) = [xa ya] in  Za.
% Enter the number of subintervals in  m.

a  = 0;
b  = 5;
Za = [3  -5];
m  = 50;
[T,Z] = rks4('fn',a,b,Za,m);
P = [T;Z(:,1)']';

pause % Press any key to see the list of solution points.

clc;
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
X = Z(:,1);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a =  0;
b =  5;
c = -0.2;
d =  3;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(T,X,'g');
xlabel('t');
ylabel('x');
title('Runge-Kutta solution to x`` = f(t,x,x`)');
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Runge-Kutta solution to x`` = f(t,x,x`).';
Mx2 = '     t(k)               x(k)';
clc,echo off,diary output,...
disp(''),disp(Mx1),...
disp(''),disp(Mx2),disp(P),diary off,echo on
