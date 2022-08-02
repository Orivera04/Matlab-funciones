echo on; clc;
%---------------------------------------------------------------------------
%A2_7  MATLAB script file for implementing Algorithm 2.7
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
% Algorithm 2.7 (Steffensen's Acceleration).
% Section	2.5, Aitken's Process & Steffensen's & Muller's Methods, Page 96
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - -
%
% This program implements the Steffensen method.
%
%
% Define and store the functions f(x) and f'(x)
% in the M-files  f.m  and  df.m, respectively.
%
% function y = f(x)
% y = x.^3 - 3.*x + 2;
%
% function y1 = df(x)
% y1 = 3*x.^2 - 3;

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
delete df.m
diary df.m; disp('function y1 = df(x)');...
            disp('y1 = 3*x.^2 - 3;');...
diary off;
% Remark. f.m, df.m and steff.m are used for Algorithm 2.7
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

figure(gcf); pause % Press any key to perform Steffensen iteration.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 2.16, page 95  Use Steffensen method of iteration for finding
% a zero of the function  f(x) = x^3 - 3x + 2.
%
% Enter the starting value in  p0
% Enter the abscissa tolerance in  delta
% Enter the ordinate tolerance in  epsilon
% Enter the number of iterations in  max1

p0  = -2.4;
delta = 1e-12;
epsilon = 1e-12;
max1 = 5;

[p,yp,err,Q] = steff('f','df',p0,delta,epsilon,max1);

pause % Press any key for the list of iterations.

clc;
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare arrays to graph and print results.
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = -2.42;
b = -1.97;
h = (b-a)/150;
X = a:h:b;
Y = f(X);
max1 = length(Q);
n0 = min(6,max1);
X0 = Q(1:n0);
Z0 = zeros(1,n0);

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section for the results.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
a = -2.42;
b = -1.97;
c = -5.0;
d =  0.5;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'-g',X0,Z0,'or');
xlabel('x');
ylabel('y');
title('Graphical analysis for Steffensen`s method.');
grid;
hold off;

figure(gcf); pause % Press any key to continue.

% .. .. .. .. .. 
% Prepare results
% .. .. .. .. .. 
J = 1:max1;
Yq = f(Q);
points = [J;Q;Yq];

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Iterations for Steffensen`s method.';
Mx2 = ['     k                  p(k)               f(p(k))'];
Mx3 = 'The solution is:';
Mx4 = 'The error estimate for p is  ~ ';
clc,echo off,diary output,
disp(''), disp(Mx1),disp(''), disp(Mx2), disp(points'),...
disp('Iteration converged quadratically to the root.'),...
disp(''),disp(Mx3),disp(''),disp('p = '),...
disp(p),disp(''),disp('f(p) = '),disp(yp),...
disp([Mx4,num2str(err)]),diary off,echo on
pause % Press any key to perform Steffensen iteration.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 2.16, page 95  Use Steffensen method of iteration for finding
% a zero of the function  f(x) = x^3 - 3x + 2.
%
% Enter the starting value in  p0
% Enter the abscissa tolerance in  delta
% Enter the ordinate tolerance in  epsilon
% Enter the number of iterations in  Max

p0  = 1.2;
delta = 1e-12;
epsilon = 1e-12;
max1 = 5;

[p,yp,err,Q] = steff('f','df',p0,delta,epsilon,max1);

pause % Press any key for the list of iterations.

clc;
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare arrays to graph and print results.
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = 0.975;
b = 1.225;
h = (b-a)/150;
X = a:h:b;
Y = f(X);
max1 = length(Q);
n0 = min(6,max1);
X0 = Q(1:n0);
Z0 = zeros(1,n0);

clc; figure(3); clf;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section for the results.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
a =  0.975;
b =  1.225;
c = -0.02;
d =  0.14;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'-g',X0,Z0,'or');
xlabel('x');
ylabel('y');
title('Graphical analysis for Steffensen`s method.');
grid;
hold off;

figure(gcf); pause % Press any key to continue.

% .. .. .. .. .. 
% Prepare results
% .. .. .. .. .. 
J = 1:max1;
Yq = f(Q);
points = [J;Q;Yq];

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
clc,echo off,diary output,
disp(''), disp(Mx1),disp(''), disp(Mx2), disp(points'),...
disp('Iteration converged quadratically to the root.'),...
disp(''),disp(Mx3),disp(''),disp('p = '),...
disp(p),disp(''),disp('f(p) = '),disp(yp),...
disp([Mx4,num2str(err)]),diary off,echo on
