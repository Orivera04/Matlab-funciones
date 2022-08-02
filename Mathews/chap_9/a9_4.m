echo on; clc;
%---------------------------------------------------------------------------
%A9_4   MATLAB script file for implementing Algorithm 9.4
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
% Algorithm 9.4 (Runge-Kutta Method of Order 4).
% Section	9.5, Runge-Kutta Methods, Page 460
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program implements the Runge-Kutta method
%
% for solving the initial value problem
%
%     y' = f(t,y)    with    y(a) = y0
%
%
%
% Define and store the function f(t,y) in the M-file  f.m 
% function z = f(t,y)
% z = (t-y)/2;

pause % Press any key to continue.

clc;
%.......................................................................
% Begin a section which enters the function(s) necessary for the example
% into M-file(s) by executing the diary command in this script file.
% The preferred programming method is not to use these steps.
% One should enter the function(s) into the M-file(s) with an editor.
delete output
delete f.m
diary  f.m; disp('function z = f(t,y)');...
            disp('z = (t-y)/2;');...
diary off;
f(0,0); % Remark. f.m and rk4.m are used for Algorithm 9.4
pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 9.10, page 454.  Use the Runge-Kutta method to solve
% the differential equation  y' = (t-y)/2.
%
% Enter the endpoints a and b of the interval [a,b].
% Enter the initial value ya = y(a) in  ya.
% Enter the number of subintervals in  m.

a  =  0;
b  =  3;
ya =  1;
m  = 12;
[T,Y] = rk4('f',a,b,ya,m);
points = [T;Y];

pause	% Press any key to see the list of solution points.

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = 0;
b = 3;
c = 0;
d = 1.75;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(T,Y,'g');
if m<=32,
  plot(T,Y,'or');
end;
xlabel('t');
ylabel('y');
title('Runge-Kutta solution to y` = f(t,y)');
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Runge-Kutta solution to y` = f(t,y).';
Mx2 = '     t(k)               y(k)';
clc,echo off,diary output,...
disp(''),disp(Mx1),...
disp(''),disp(Mx2),disp(points'),diary off,echo on
