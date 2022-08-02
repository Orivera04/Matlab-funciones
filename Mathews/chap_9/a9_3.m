echo on; clc;
%---------------------------------------------------------------------------
%A9_3   MATLAB script file for implementing Algorithm 9.3
%
% NUMERICAL METHODS: MATLAB Programs, (c) John H. Mathews 1994
% To accompany the text:
% NUMERICAL METHODS for Mathematics, Science and Engineering, 2nd Ed, 1992
% Prentice Hall, Englewood Cliffs, New Jersey, 07632, U.S.A.
% Prentice Hall, Inc.; USA, Canada, Mexico ISBN 0-13-624990-6
% Prentice Hall, International Editions:   ISBN 0-13-625047-5
% This free software is compliments of the author.
% E-mail address:      in%"mathews@fullerton.edu"
%
% Algorithm 9.3 (Taylor's Method of Order 4).
% Section	9.4, Taylor Series Method, Page 448
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - -
%
% This program implements Taylor's method
%
% for solving the initial value problem
%
%     y' = f(t,y)    with    y(a) = y0
%
%
% Define and store the function d1 = f(t,y)	
% and formulas for the next three derivatives
% of  f(t,y)  in the M-file  df.m 
% function z = df(t,y)
% d1 = (t - y)/2;
% d2 = (2 - t + y)/4;
% d3 = (- 2 + t - y)/8;
% d4 = (2 - t + y)/16;
% z = [d1 d2 d3 d4];

pause % Press any key to continue.

clc;
%.......................................................................
% Begin a section which enters the function(s) necessary for the example
% into M-file(s) by executing the diary command in this script file.
% The preferred programming method is not to use these steps.
% One should enter the function(s) into the M-file(s) with an editor.
delete output
delete df.m
diary df.m; disp('function z = df(t,y)');...
            disp('d1 = (t - y)/2;');...
            disp('d2 = (2 - t + y)/4;');...
            disp('d3 = (- 2 + t - y)/8;');...
            disp('d4 = (2 - t + y)/16;');...
            disp('z = [d1 d2 d3 d4];');...
diary off;
df(0,0); % Remark. df.m and taylor.m are used for Algorithm 9.3
pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 9.8, page 445.  Use Taylor's method to solve
% the differential equation  y' = (t-y)/2.
%
% Enter the endpoints a and b of the interval [a,b].
% Enter the initial value y(a) in  ya.
% Enter the number of subintervals in  m.

a  =  0;
b  =  3;
ya =  1;
m  = 12;

[T,Y] = taylor('df',a,b,ya,m);
points = [T;Y];

pause % Press any key to see the list of solution points.

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
if m<=30,
  plot(T,Y,'or');
end;
xlabel('t');
ylabel('y');
title('Taylor`s solution to y` = f(t,y)');
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Taylor`s solution to y` = f(t,y).';
Mx2 = '     t(k)               y(k)';
clc,echo off,diary output,...
disp(''),disp(Mx1),...
disp(''),disp(Mx2),disp(points'),diary off,echo on
