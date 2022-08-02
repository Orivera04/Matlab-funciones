echo on; clc;
%---------------------------------------------------------------------------
%A10_1   MATLAB script file for implementing Algorithm 10.1
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
% Algorithm 10.1 (Finite-Difference Solution for the Wave Equation).
% Section	10.1, Hyperbolic Equations, Page 507
%---------------------------------------------------------------------------

clc; clear all; format short;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%                    HYPERBOLIC PDE's.
%
%  Finite difference solution for the wave equation
%
%                         2
%          u  (x,t)   =  c  u  (x,t)     with
%           tt               xx
%
%   u(0,t) = 0     and   u(a,t) = 0      for 0 <= t <= b.
%
%   u(x,0) = f(x)  and  u (x,0) = g(x)   for  0 < x < a.
%                        t
%
% A numerical approximation is computed over the rectangle
%
%         0 <= x <= a ,   0 <= t <= b.

pause % Press any key to continue.

clc;
% Store f(x) and g(x) in the M-files f.m and g.m respectively.
% function z = f(x)
% z = sin(pi*x) + sin(2*pi*x);
% function z = g(x)
% z = 0;
pause % Press any key to continue.

clc;
%.......................................................................
% Begin a section which enters the function(s) necessary for the example
% into M-file(s) by executing the diary command in this script file.
% The preferred programming method is not to use these steps.
% One should enter the function(s) into the M-file(s) with an editor.
delete output
delete f.m
diary  f.m; disp('function z = f(x)');...
            disp('z = sin(pi*x) + sin(2*pi*x);');...
diary off;
delete g.m
diary  g.m; disp('function z = g(x)');...
            disp('z = 0;');...
diary off;
% Remark. f.m  g.m finedif.m are used for Algorithm 10.1
f(0); g(0);
pause % Press any key to continue.

clc;
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 10.1, page 504.  Use the finite difference method to solve
% the wave equation  u  (x,t)  =  4u  (x,t).
%                     tt            xx
% Enter the endpoint of [0,a] in  a,   i.e.  0 <= x <= a
% Enter the endpoint of [0,b] in  b,   i.e.  0 <= t <= b.
% Enter the constant  c  for the wave equation.
% Enter the number of grid points  n  over the interval [0,a].
% Enter the number of grid points  m  over the interval [0,b].

a  =   1;
b  =   0.5;
c  =   2;
n  =  11;
m  =  11;

U = finedif('f','g',a,b,c,n,m);

pause % Press any key to see the solution. 

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
h = a/(n-1);
k = b/(m-1);
[X,T] = meshgrid(0:h:a,0:h:b);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
whitebg('w');
meshz(T,X,U);
xlabel('t');
ylabel('x');
zlabel('u');
view([1 1 1]);
Mx1='The finite difference solution to the wave equation.';
title(Mx1);
figure(gcf); pause % Press any key to continue.

% .. .. .. .. .. 
% Prepare results
% .. .. .. .. .. 
W = U';
points = W(:,2:n-1);

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
clc,echo off,diary output,...
disp(' '),disp(Mx1),disp(' '),disp(points),...
diary off,echo on
