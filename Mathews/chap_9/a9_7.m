echo on; clc;
%---------------------------------------------------------------------------
%A9_7   MATLAB script file for implementing Algorithm  9.7
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
% Algorithm  9.7 (Milne-Simpson Method).
% Section	9.6, Predictor-Corrector Method, Page 472
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program implements Milne-Simpson method
%
% for solving the initial value problem
%
%     y' = f(t,y)    with    y(a) = y0
%
%
%
% Define and store the function f(t,y) in the M-file  f.m 
% function z = f(t,y)
% z = 30 - 5*y;

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
            disp('z = 30 - 5*y;');...
diary off;
f(0,0); % Remark.  f.m rk4.m milne.m are used for Algorithm 9.7
pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example for figure 9.13(b), page 471.  
% Use the Milne-Simpson method
% to solve the differential equation  y' = 30 - 5y.
%
% Enter the endpoints a and b of the interval [a,b].
% Enter the initial value y(a) in  ya.
% Enter the number of subintervals in  n.

a  =   0;
b  =  10;
ya =   1;
n  = 110;

pause % Press any key to continue. 

clc;
% Set up the step size, and vectors T and Y.
h  = (b - a)/n;
T = zeros(1,n+1);
Y = zeros(1,n+1);

% Generate three starting values using the Runge-Kutta method.
[Ts,Ys] = rk4('f',a,a+3*h,ya,6);
T(1:4) = Ts(1:2:7);
Y(1:4) = Ys(1:2:7);

% Proceed with the Milne-Simpson method.
[T,Y] = milne('f',T,Y);
points = [T;Y];

pause % Press any key to see the list of solution points.

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a =  0;
b = 10;
c =  0;
d =  7;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(T,Y,'-r');
xlabel('t');
ylabel('y');
Mx1 = 'Milne-Simpson solution to y` = f(t,y).';
title(Mx1);
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx2 = '     t(k)               y(k)';
Mx3 = 'The Milne-Simpson method is stable';
Mx4 = ['for  n = ',num2str(n),'  and  h = '];
Mx5 = [Mx4,num2str(h),' because'];
Mx6 = '     h < 0.45/|f (t,y)|';
Mx7 = '                y';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(points'),...
disp(Mx3),disp(Mx5),disp(''),disp(Mx6),disp(Mx7),...
diary off, echo on
pause % Press any key to perform the Milne-Simpson method.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example for figure 9.13(b), page 471.  
% Use the Milne-Simpson method
% to solve the differential equation  y' = 30 - 5y.
%
% Enter the endpoints a and b of the interval [a,b].
% Enter the initial value y(a) in  ya.
% Enter the number of subintervals in  n.

a  =  0;
b  = 10;
ya =  1;
n  = 93;

pause % Press any key to continue. 

clc;
% Set up the step size, and vectors T and Y.
h  = (b - a)/n;
T = zeros(1,n+1);
Y = zeros(1,n+1);

% Generate three starting values using the Runge-Kutta method.
[Ts,Ys] = rk4('f',a,a+3*h,ya,6);
T(1:4) = Ts(1:2:7);
Y(1:4) = Ys(1:2:7);

% Proceed with the Milne-Simpson method.
[T,Y] = milne('f',T,Y);
points = [T;Y];

pause % Press any key to see the list of solution points.

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a =  0;
b = 10;
c =  0;
d =  7;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(T,Y,'-g');
xlabel('t');
ylabel('y');
Mx1 = 'An unstable Milne-Simpson solution to y` = f(t,y).';
title(Mx1);
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx3 = 'The Milne-Simpson method is unstable';
Mx4 = ['for  n = ',num2str(n),'  and  h = '];
Mx5 = [Mx4,num2str(h),' because'];
Mx6 = '     0.45/|f (t,y)| < h';
Mx7 = '            y';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(points'),...
disp(Mx3),disp(Mx5),disp(''),disp(Mx6),disp(Mx7),...
diary off, echo on
