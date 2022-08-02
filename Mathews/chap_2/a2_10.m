%---------------------------------------------------------------------------
echo on; clc;
%A2_10   MATLAB script file for implementing
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
% Algorithm 2.10 (Newton-Raphson Method in 2-Dimensions).
% Section	2.7,  Newton's Method for Systems, Page 116
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program implements the Newton-Raphson method
% for solving    0 = f1(x,y)  and  0 = f2(x,y).
% Use the vector notation X = (x y).
%
% Define and store the functions f1(X) and f2(X) and
% define and store the functions  F(X) and  J(X) in the
% M-files  f1.m   f2.m   F.m   and   J.m   respectively.
% function z = f1(x,y)
% z = x.^2 - 2.*x - y + 0.5;
% function z = f2(x,y)
% z = x.^2 + 4.*y.^2 - 4;
% function Z = F(X)
% x = X(1); y = X(2);
% Z = [f1(x,y);  f2(x,y)];
% function W = J(X)
% x = X(1); y = X(2);
% W = [(2.*x - 2)  (-1);
%      (2.*x)      (8.*y)];

pause % Press any key to continue.

clc;
%.......................................................................
% Begin a section which enters the function(s) necessary for the example
% into M-file(s) by executing the diary command in this script file.
% The preferred programming method is not to use these steps.
% One should enter the function(s) into the M-file(s) with an editor.
delete output
delete f1.m
diary  f1.m; disp('function z = f1(x,y)');...
             disp('z = x.^2 - 2.*x - y + 0.5;');...
diary off;
delete f2.m
diary  f2.m; disp('function z = f2(x,y)');...
             disp('z = x.^2 + 4.*y.^2 - 4;');...
diary off;
delete F.m
diary  F.m; disp('function Z = F(X)');...
            disp('x = X(1); y = X(2);');...
            disp('Z = [f1(x,y); f2(x,y)];');...
diary off;
delete J.m
diary  J.m; disp('function W = J(X)');...
            disp('x = X(1); y = X(2);');...
            disp('W = [(2.*x - 2)  (-1);');...
            disp('     (2.*x)      (8.*y)];');...
diary off;
% Remark. f1.m, f2.m, F.m, J.m and new2dim.m are used for Algorithm 2.10
f1(0,0); f2(0,0); F([0 0]); J([0 0]); % Test for files f1.m f2.m F.m J.m
pause % Press any key to graph 0 = f1(x,y) and 0 = f2(x,y).

clc;
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot 0 = f1(x,y) and 0 = f2(x,y).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = -2.0;
b =  2.5;
c = -1.0;
d =  1.5;
hx = (b-a)/31;
hy = (d-c)/31;
[X Y] = meshgrid(a:hx:b, c:hy:d);
Z = f1(X,Y);
W = f2(X,Y);

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
title('Implicit plot of 0 = f1(x,y) and 0 = f2(x,y).');
grid;
hold off;

figure(gcf); pause % Press any key to perform Newton-Raphson iteration.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 2.20, page 114  Use Newton's iteration in 2 dimensions
% to solve  F(X) = 0.  The system of equations is
%             (x^2 - y + 0.5)/2  =  0
%     (- x^2 - 4y^2 + 8y + 4)/8  =  0
% Enter the starting value in  [p0 q0]
% Enter the tolerance for P in delta
% Enter the tolerance for F(P) in epsilon
% Enter the maximum number of iterations in  max1

p0 = 2.0;
q0 = 0.25;
P0 = [p0 q0];
delta = 1e-12;
epsilon = 1e-12;
max1  = 40;

[P0,F0,err,P] = new2dim('F','J',P0,delta,epsilon,max1);

pause % Press any key for the list of iterations.

clc;
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare arrays to graph and print results.
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = 1.86;
b = 2.02;
c = 0.24;
d = 0.34;
hx = (b-a)/20;
hy = (d-c)/20;
[X Y] = meshgrid(a:hx:b, c:hy:d);
Z = f1(X,Y);
W = f2(X,Y);
X0 = P(:,1);
Y0 = P(:,2);

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section for the results.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
a = 1.86;
b = 2.02;
c = 0.24;
d = 0.34;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
contour(X,Y,Z,[0 0],'-g');
contour(X,Y,W,[0 0],'-g');
plot(X0,Y0,'or');
title('Graphical presentation of the Newton-Raphson iteration.');
grid;
hold off;

figure(gcf); pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Iterations for Newton`s method.';
Mx2 = '     p(k)               q(k)';
Mx3 = 'The solution is:';
Mx4 = 'The error estimate for P is ';
Mx5 = num2str(err);
Mx6 = [Mx4,'[~ ',Mx5,', ~ ',Mx5,']'];
clc,echo off, diary output,...
disp(''), disp(Mx1),disp(''), disp(Mx2),disp(P),...
disp('Iteration converged to the root.'),...
disp(''),disp(Mx3),disp(''),disp('P = '),...
disp(P0),disp('F(P) = '),disp(F0),...
disp(''),disp([Mx6]),diary off,echo on
pause % Press any key to perform Newton-Raphson iteration.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
%
% Example 2.20, page 114  Use Newton's iteration in 2 dimensions
% to solve  F(X) = 0.  The system of equations is
%             (x^2 - y + 0.5)/2  =  0
%     (- x^2 - 4y^2 + 8y + 4)/8  =  0
% Enter the starting value in  [p0 q0]
% Enter the tolerance for P in delta
% Enter the tolerance for F(P) in epsilon
% Enter the maximum number of iterations in  max1

p0 = -0.1;
q0 =  0.9;
P0 = [p0 q0];
delta = 1e-12;
epsilon = 1e-12;
max1  = 40;

[P0,F0,err,P] = new2dim('F','J',P0,delta,epsilon,max1);

pause % Press any key for the list of iterations.

clc;
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare arrays to graph and print results.
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = -0.26;
b = -0.08;
c =  0.88;
d =  1.02;
hx = (b-a)/20;
hy = (d-c)/20;
[X Y] = meshgrid(a:hx:b, c:hy:d);...
Z = f1(X,Y);
W = f2(X,Y);
X0 = P(:,1);
Y0 = P(:,2);

clc; figure(3); clf;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section for the results.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
a = -0.26;
b = -0.08;
c =  0.88;
d =  1.02;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
contour(X,Y,Z,[0 0],'-g');
contour(X,Y,W,[0 0],'-g');
plot(X0,Y0,'or');
title('Graphical presentation of the Newton-Raphson iteration.');
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
disp('Iteration converged to the root.'),...
disp(''),disp(Mx3),disp(''),disp('P = '),...
disp(P0),disp('F(P) = '),disp(F0),...
disp(''),disp([Mx6]),diary off,echo on
