echo on; clc;
%---------------------------------------------------------------------------
%A2_9   MATLAB script file for implementing Algorithm 2.9
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
% Algorithm 2.9* (Fixed Point Iteration in higher dimensions).
% Section	2.6, Iteration for Nonlinear Systems, Page 108
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - -
%
% This program implements fixed point iteration
% in 2-dimensions for solving  X = G(X).
% Use the vector notation X = (x y).
%
% Define and store the functions g1(X) and g2(X) and
% define and store the function   G(X) in the
% M-files   g1.m   g2.m   and   G.m   respectively.
%
% function z = g1(x,y)
% z = (x.^2 - y + 0.5)./2;
% function z = g2(x,y)
% z = (- x.^2 - 4.*y.^2 + 8.*y + 4)./8;
% function Z = G(X)
% x = X(1); y = X(2);
% Z = [g1(x,y)  g2(x,y)];

pause % Press any key to continue.

clc;
%.......................................................................
% Begin a section which enters the function(s) necessary for the example
% into M-file(s) by executing the diary command in this script file.
% The preferred programming method is not to use these steps.
% One should enter the function(s) into the M-file(s) with an editor.
delete output
delete g1.m
diary  g1.m; disp('function z = g1(x,y)');...
             disp('z = (x.^2 - y + 0.5)./2;');...
diary off;
delete g2.m
diary  g2.m; disp('function z = g2(x,y)');...
             disp('z = (- x.^2 - 4.*y.^2 + 8.*y + 4)./8;');...
diary off;
delete G.m
diary  G.m; disp('function Z = G(X)');...
            disp('x = X(1); y = X(2);');...
            disp('Z = [g1(x,y)  g2(x,y)];');...
diary off;
% Remark. g1.m, g2.m, G.m and fix2dim.m are used for Algorithm 2.9
g1(0,0); g2(0,0); G([0 0]); % Test for files g1.m g2.m G.m
pause % Press any key to graph x = g1(x,y) and y = g2(x,y).


clc;
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot x = g1(x,y) and y = g2(x,y).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = -2.0;
b =  2.5;
c = -1.0;
d =  1.5;
hx = (b-a)/31;
hy = (d-c)/31;
[X Y] = meshgrid(a:hx:b, c:hy:d);
Z = g1(X,Y) - X;
W = g2(X,Y) - Y;

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -2.0;
b =  2.5;
c = -1.0;
d =  1.5;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
contour(X,Y,Z,[0 0],'-g');
contour(X,Y,W,[0 0],'-g');
grid;
title('Implicit plot of x = g1(x,y) and y = g2(x,y).');
hold off;

figure(gcf); pause % Press any key to perform fixed point iteration.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example, page 101  Use fixed point iteration in 2 dimensions
% to solve  X = G(X).  The system of equations is
%
%        x  =  (x^2 - y + 0.5)/2
%        y  =  (- x^2 - 4y^2 + 8y + 4)/8
%
% Enter the starting value in  [p0 q0]
% Enter the tolerance in  delta
% Enter the number of iterations in  max1

p0 = 0.0;
q0 = 1.0;
P0 = [p0 q0];
delta = 1e-12;
max1  = 50;

[P0,err,P] = fix2dim('G',P0,delta,max1);

pause % Press any key for the list of iterations.

clc;
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare arrays to graph and print results.
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = -0.275;
b =  0.025;
c =  0.99;
d =  1.002;
hx = (b-a)/20;
hy = (d-c)/20;
[X Y] = meshgrid(a:hx:b, c:hy:d);
Z = g1(X,Y) - X;
W = g2(X,Y) - Y;
X0 = P(:,1);
Y0 = P(:,2);

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section for the results.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
a = -0.275;
b =  0.025;
c =  0.99;
d =  1.002;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
contour(X,Y,Z,[0 0],'-g');
contour(X,Y,W,[0 0],'-g');
plot(X0,Y0,'or');
title('Graphical presentation of the fixed point iteration.');
grid;
hold off;

figure(gcf); pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Computations for the fixed point iteration method.';
Mx2 = '     p(k)               q(k)';
Mx3 = 'The solution is:';
Mx4 = 'The error estimate for P is ';
Mx5 = num2str(err);
Mx6 = [Mx4,'[~ ',Mx5,', ~ ',Mx5,']'];
clc,echo off,diary output,...
disp(''), disp(Mx1),disp(''), disp(Mx2),disp(P),...
disp('Iteration is converging linearly to the root.'),...
disp(''),disp(Mx3),disp(''),disp('G(P) = P = '),disp(P0),...
disp(''),disp([Mx6]),diary off,echo on

pause % Press any key to perform fixed point iteration.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example, page 101  Use fixed point iteration in 2 dimensions
% to solve  X = G(X).  The system of equations is
%
%        x  =  (x^2 - y + 0.5)/2
%        y  =  (- x^2 - 4y^2 + 8y + 4)/8
%
% Enter the starting value in  [p0 q0]
% Enter the tolerance in  delta
% Enter the number of iterations in  max1

p0 = 2.0;
q0 = 0.0;
P0 = [p0 q0];
delta = 1e-12;
max1  = 6;

[P0,err,P] = fix2dim('G',P0,delta,max1);

pause % Press any key for the list of iterations.

clc;
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare arrays to graph and print results.
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a =  -2;
b =  10;
c =  -3;
d =   1;
hx = (b-a)/31;
hy = (d-c)/31;
[X Y] = meshgrid(a:hx:b, c:hy:d);
Z = g1(X,Y) - X;
W = g2(X,Y) - Y;

clc; figure(3); clf;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section for the results.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
a =  -2;
b =  10;
c =  -3;
d =   1;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
contour(X,Y,Z,[0 0],'-g');
contour(X,Y,W,[0 0],'-g');
X0 = P(:,1);
Y0 = P(:,2);
plot(X0,Y0,'or');
plot([a b],[0 0],'b',[0 0],[c d],'b');
title('Graphical presentation of the fixed point iteration.');
grid;
hold off;

figure(gcf); pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
clc,echo off, diary output,...
disp(''), disp(Mx1),disp(''), disp(Mx2),disp(P),...
disp('Iteration is diverging to "infinity".'),...
disp('Note the "scale factor" for the table of computations.'),...
diary off, echo on
