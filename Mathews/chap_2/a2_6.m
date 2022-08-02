echo on; clc;
%---------------------------------------------------------------------------
%A2_6   MATLAB script file for implementing Algorithm 2.6
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
% Algorithm 2.6 (Secant Method).
% Section	2.4, Newton-Raphson and Secant Methods, Page 85
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program implements the secant method.
%
%
% Define and store the function f(x) in the M-file  f.m
%
% function y = f(x)
% y = x.^3 - 3.*x + 2;

pause % Press any key to continue.

clc;
%.......................................................................
% Begin a section which enters the function(s) necessary for the example
% into M-file(s) by executing the diary command in this script file.
% The preferred programming method is not to use these steps.
% One should enter the function(s) into the M-file(s) with an editor.
delete output
delete f.m
diary  f.m; disp('function y = f(x)');...
            disp('y = x.^3 - 3.*x + 2;');...
diary off;
% Remark. f.m and secant.m are used for Algorithm 2.6
f(0); % Test for file f.m
pause % Press any key to see the graph y = f(x).

clc;
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot y = f(x).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = -2.5;
b =  2.5;
h = (b-a)/150;
X = a:h:b;
Y = f(X);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -2.5;
b =  2.5;
c = -5;
d =  5;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'-g');
xlabel('x');
ylabel('y');
title('Graph of y = f(x).');
grid;
hold off;

figure(gcf); pause % Press any key to perform secant iteration.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 2.13, page 82  Use the secant method for iteration for finding 
% a zero of the function  f(x) = x^3 - 3x + 2.
%
% Enter the starting value in  p0  and  p1
% Enter the abscissa tolerance in  delta
% Enter the ordinate tolerance in  epsilon
% Enter the maximum number of iterations in  max1

p0 = -2.6;
p1 = -2.4;
delta = 1e-12;
epsilon = 1e-12;
max1  = 50;

[p1,y1,err,P] = secant('f',p0,p1,delta,epsilon,max1);

pause % Press any key for the list of iterations.

clc;
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare arrays to graph and print results.
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = -2.7;
b = -1.9;
h = (b-a)/150;
X = a:h:b;
Y = f(X);
max1 = length(P);
clear Vx Vy
for i = 2:max1,
  k1 = 3*i-2;
  k2 = 3*i-1;
  k3 = 3*i;
  Vx(k1) = P(i);
  Vy(k1) = 0;
  Vx(k2) = P(i);
  Vy(k2) = f(P(i));
  Vx(k3) = P(i-1);
  Vy(k3) = f(P(i-1));
end
Z = zeros(1,length(P));

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section for the results.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
a =  -2.7;
b =  -1.9;
c = -10;
d =   2;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'-g',Vx,Vy,'-r',P,Z,'or');
xlabel('x');
ylabel('y');
title('Graphical analysis for the secant method.');
grid;
hold off;

figure(gcf); pause % Press any key to continue.

% .. .. .. .. .. 
% Prepare results
% .. .. .. .. .. 
J = 1:(max1);
Yp = f(P);
points = [J;P;Yp];

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Iterations for the secant method.';
Mx2 = '     k                  p(k)               f(p(k))';
Mx3 = 'The solution is:';
Mx4 = 'The error estimate for p is  ~ ';
clc,echo off, diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(points'),...
disp('Iteration converged with order 1.618 to the simple root.'),...
disp(''),disp(Mx3),disp(''),disp('p = '),...
disp(p1),disp(''),disp('f(p) = '),disp(y1),...
disp([Mx4,num2str(err)]),diary off,echo on
pause % Press any key to perform secant iteration.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 2.13, page 82  Use the secant method for iteration for finding 
% a zero of the function  f(x) = x^3 - 3x + 2.
%
% Enter the starting value in  p0  and  p1
% Enter the abscissa tolerance in  delta
% Enter the ordinate tolerance in  epsilon
% Enter the maximum number of iterations in  max1

p0 = 1.6;
p1 = 1.4;
delta = 1e-12;
epsilon = 1e-12;
max1  = 30;

[p1,y1,err,P] = secant('f',p0,p1,delta,epsilon,max1);

pause % Press any key for the list of iterations.

clc;
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare arrays to graph and print results.
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = 0.95;
b = 1.6;
h = (b-a)/150;
X = a:h:b;
Y = f(X);
max1 = length(P);
clear Vx Vy
for i = 2:max1,
  k1 = 3*i-2;
  k2 = 3*i-1;
  k3 = 3*i;
  Vx(k1) = P(i);
  Vy(k1) = 0;
  Vx(k2) = P(i);
  Vy(k2) = f(P(i));
  Vx(k3) = P(i-1);
  Vy(k3) = f(P(i-1));
end
Z = zeros(1,length(P));

clc; figure(3); clf;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section for the results.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
a =  0.95;
b =  1.6;
c = -0.1;
d =  1.2;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'-g',Vx,Vy,'-r',P,Z,'or');
xlabel('x');
ylabel('y');
title('Graphical analysis for the secant method.');
grid;
hold off;

figure(gcf); pause % Press any key to continue.

% .. .. .. .. .. 
% Prepare results
% .. .. .. .. .. 
J = 1:(max1);
Yp = f(P);
points = [J;P;Yp];

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
clc,echo off, diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(points'),...
disp('Iteration is converging linearly to the double root.'),...
disp(''),disp(Mx3),disp(''),disp('p = '),...
disp(p1),disp(''),disp('f(p) = '),disp(y1),...
disp([Mx4,num2str(err)]),diary off,echo on
