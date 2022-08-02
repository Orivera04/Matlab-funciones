echo on; clc;
%---------------------------------------------------------------------------
%A10_4   MATLAB script file for implementing Algorithm 10.4
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
% Algorithm 10.4 (Dirichlet Method for Laplace's Equation).
% Section	10.3, Elliptic Equations, Page 531
%---------------------------------------------------------------------------

clc; clear all; format short;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%           ELLIPTIC EQUATIONS.
%
% Dirichlet solution for the heat equation
%
%            u  (x,y)  +   u  (x,y)  =  0
%             xx            yy
%
% with the boundary values:'
%
% u(x,0) = f1(x), u(x,b) = f2(x)   for 0 <= x <= a,
%
% u(0,y) = f3(y), u(a,y) = f4(y)   for 0 <= y <= b,
%
% A numerical approximation is computed over the rectangle
%
%         0 <= x <= a ,   0 <= y <= b.

pause % Press any key to continue.

clc;
% Store f1(x),f2(x),f3(y),f4(y) in f1.m f2.m f3.m f4.m
% function z = f1(x)
% z =  20;
% function z = f2(x)
% z = 180;
% function z = f3(y)
% z =  80;
% function z = f4(y)
% z =   0;
pause % Press any key to continue.

clc;
%.......................................................................
% Begin a section which enters the function(s) necessary for the example
% into M-file(s) by executing the diary command in this script file.
% The preferred programming method is not to use these steps.
% One should enter the function(s) into the M-file(s) with an editor.
delete output
delete f1.m
diary  f1.m; disp('function z = f1(x)');...
             disp('z = 20;');...
diary off;
delete f2.m
diary  f2.m; disp('function z = f2(x)');...
             disp('z = 180;');...
diary off;
delete f3.m
diary  f3.m; disp('function z = f3(y)');...
             disp('z = 80;');...
diary off;
delete f4.m
diary  f4.m; disp('function z = f4(y)');...
             disp('z = 0;');...
diary off;
% Remark. f1.m f2.m f3.m f4.m dirich.m are used for Algorithm 10.4
f1(0); f2(0); f3(0); f4(0);
pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 10.7, page 528.  Use the Dirichlet iterative method 
% to solve Laplace's equation  u  (x,y) +  u  (x,y) = 0.
%                               xx          yy
% Place the endpoint of [0,a] in  a,  i.e. 0 <= x <= a.
% Place the endpoint of [0,b] in  b,  i.e. 0 <= y <= b.
% Place the step size in  h.
% Place the tolerance in  tol.
% Place the maximum number of iterations in  max1.

a  =    4.0;
b  =    4.0;
h  =    0.5;
tol =   0.001;
max1 = 25;

% Proceeding with the iteration.

U = dirich('f1','f2','f3','f4',a,b,h,tol,max1);

pause % Press any key to see the solution. 

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
[X,Y] = meshgrid(0:h:a,0:h:b);
W = rot90(U);
W = flipud(W);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
whitebg('w');
meshz(X,Y,W);
xlabel('x');
ylabel('y');
zlabel('u');
view([1 -1 1]);
Mx1 = 'The solution to Laplace`s equation.';
title(Mx1);
figure(gcf); pause % Press any key to continue.

% .. .. .. .. .. 
% Prepare results
% .. .. .. .. .. 
W = rot90(U);

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
clc,echo off,diary output,...
disp(' '),disp(Mx1),disp(' '),disp(W),...
diary off,echo on
