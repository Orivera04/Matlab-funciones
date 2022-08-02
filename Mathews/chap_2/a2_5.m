echo on; clc;
%---------------------------------------------------------------------------
%A2_5   MATLAB script file for implementing Algorithm 2.5
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
% Algorithm 2.5 (Newton-Raphson Iteration).
% Section	2.4, Newton-Raphson and Secant Methods, Page 84
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program implements the Newton-Raphson method.
%
%
% Define and store the functions  f(x)  and  f'(x)
% in the M-files  f.m  and  df.m   respectively.
%
% function y = f(x)
% y = x.^3 - x - 3;
%
% function y1 = df(x)
% y1 = 3*x.^2 - 1;

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
            disp('y = x.^3 - x - 3;');...
diary off;
delete df.m
diary  df.m; disp('function y1 = df(x)');...
             disp('y1 = 3*x.^2 - 1;');...
diary off;
% Remark. f.m, df.m and newton.m are used for Algorithm 2.5
f(0); df(0); % Test for files f.m, df.m
pause % Press any key to see the graph y = f(x).

clc;
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot y = f(x).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = -3.0;
b =  3.0;
h = (b-a)/150;
X = a:h:b;
Y = f(X);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a =  -3.0;
b =   3.0;
c = -10;
d =  10;
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

figure(gcf); pause % Press any key to perform Newton-Raphson iteration.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example, page 79  Use Newton-Raphson iteration for finding 
% a zero of the function  f(x) = x^3 - x - 3.
%
% Enter the starting value in  p0
% Enter the abscissa tolerance in  delta
% Enter the ordinate tolerance in  epsilon
% Enter the maximum number of iterations in  max1

p0 = 2.0;
delta = 1e-12;
epsilon = 1e-12;
max1  = 50;

[p0,y0,err,P] = newton('f','df',p0,delta,epsilon,max1);

pause % Press any key for the list of iterations.

clc;
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare arrays to graph and print results.
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = 1.6;
b = 2.05;
h = (b-a)/150;
X = a:h:b;
Y = f(X);
max1 = length(P);
clear Vx Vy
for i = 1:max1,
  k1 = 2*i-1;
  k2 = 2*i;
  Vx(k1) = P(i);
  Vy(k1) = 0;
  Vx(k2) = P(i);
  Vy(k2) = f(P(i));
end
Z0 = zeros(1,length(P));

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section for the results.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
a =  1.6;
b =  2.05;
c = -0.5;
d =  3.5;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'-g',Vx,Vy,'-r',P,Z0,'or');
xlabel('x');
ylabel('y');
title('Graphical analysis for Newton`s method.');
grid;
hold off;

figure(gcf); pause	% Press any key to continue.

% .. .. .. .. .. 
% Prepare results
% .. .. .. .. .. 
J = 1:max1;
Yp = f(P);
points = [J;P';Yp'];

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Iterations for Newton`s method.';
Mx2 = '     k                  p(k)               f(p(k))';
Mx3 = 'The solution is:';
Mx4 = 'The error estimate for p is  ~ ';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(points'),...
disp('Iteration converged quadratically to the root.'),...
disp(''),disp(Mx3),disp(''),disp('p = '),...
disp(p0),disp('f(p) = '),disp(y0),...
disp([Mx4,num2str(err)]),diary off,echo on
pause % Press any key to perform Newton-Raphson iteration.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example, page 79  Use Newton-Raphson iteration for finding 
% a zero of the function  f(x) = x^3 - x - 3.
%
% Enter the starting value in  p0
% Enter the abscissa tolerance in  delta
% Enter the ordinate tolerance in  epsilon
% Enter the maximum number of iterations in  max1

p0 = 0.0;
delta = 1e-12;
epsilon = 1e-12;
max1  = 12;

[p0,y0,err,P] = newton('f','df',p0,delta,epsilon,max1);

pause % Press any key for the list of iterations.

clc;
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare arrays to graph and print results.
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = -3.5;
b =  0.5;
h = (b-a)/100;
X = a:h:b;
Y = f(X);
max1 = length(P);
clear Vx Vy
for i = 1:max1,
  k1 = 2*i-1;
  k2 = 2*i;
  Vx(k1) = P(i);
  Vy(k1) = 0;
  Vx(k2) = P(i);
  Vy(k2) = f(P(i));
end
Z0 = zeros(1,length(P));

clc; figure(3); clf;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section for the results.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
a =  -3.5;
b =   0.5;
c = -30;
d =   5;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'-g',Vx,Vy,'-r',P,Z0,'or');
xlabel('x');
ylabel('y');
title('Graphical analysis for Newton`s method.');
grid;
hold off;

figure(gcf); pause % Press any key to continue.

% .. .. .. .. .. 
% Prepare results
% .. .. .. .. .. 
J = 1:max1;
Yp = f(P);
points = [J;P';Yp'];

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Iterations for Newton`s method.';
Mx2 = '     k                  p(k)               f(p(k))';
clc,echo off, diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(points'),...
disp('Iteration did not occur.  This is a case of "cycling."'),...
diary off, echo on
