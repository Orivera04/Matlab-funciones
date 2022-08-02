echo on; clc;
%---------------------------------------------------------------------------
%A9_S   MATLAB script file for implementing Algorithm 9.s
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
% Algorithm 9.s (Runge-Kutta Method for a System).
% Section	9.7, Runge-Kutta Methods, Page 475
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program implements the Runge-Kutta method
% for solving the initial value problem
%
%     Z' = F(t,Z)     with    Z(a) = Za
%
% where the vector notation is equivalent to:
%
%     x' = f(t,x,y)   with    x(a) = xa
%     y' = g(t,x,y)           y(a) = ya
%
% Formulas for f(t,x,y) and g(t,x,y) are used to form
% the vector function F(t,Y) which is stored in  Fn.m 
%
% function W = fn(t,Z)
% x = Z(1);  y = Z(2);
% W = [(x - x*y - x^2/10), (x*y - y - y^2/20)];

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
            disp('W = [(x - x*y - x^2/10), (x*y - y - y^2/20)];');...
diary off;
fn(0,[0 0]); % Remark. fn.m and rks4 are used in Algorithm 9.S
pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example for figure 9.1, page 423.
% Use the Runge-Kutta method on pages 476-477
% to solve the system of differential equations
%     x' = x - xy - x^2/10
%     y' = xy - y - y^2/20
%
% Enter the endpoints a and b of the interval [a,b].
% Enter the initial value Za = Z(a) in Za.
% Enter the number of subintervals in  m.

a  =  0;
b  = 15;
Za = [2  1];
m  = 150;
[T,Z] = rks4('fn',a,b,Za,m);
P = [T;Z']';
points = P(1:10:length(P),:);

pause % Press any key to see the list of solution points.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
X = Z(:,1);
Y = Z(:,2);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = 0;
b = 2.1;
c = 0;
d = 1.8;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'g');
xlabel('X');
ylabel('Y');
title('Runge-Kutta solution to Z` = F(t,Z)');
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Runge-Kutta solution to Z` = F(t,Z).';
Mx2 = '     t(k)               x(k)               y(k)';
clc,echo off,diary output,...
disp(''),disp(Mx1),...
disp(''),disp(Mx2),disp(points),diary off,echo on
