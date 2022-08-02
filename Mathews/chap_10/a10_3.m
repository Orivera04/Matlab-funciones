echo on; clc;
%---------------------------------------------------------------------------
%A10_3   MATLAB script file for implementing Algorithm 10.3
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
% Algorithm 10.3 (Crank-Nicholson Method for the Heat Equation).
% Section	10.2, Parabolic Equations, Page 517
%---------------------------------------------------------------------------

clc; clear all; format short;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%                 PARABOLIC EQUATIONS.
%
% Crank-Nicholson solution for the heat equation
%
%                          2
%            u (x,t)   =  c  u  (x,t)
%             t               xx
%
%  u(x,0) = f(x)   for  0 < x < a     and
%
%  u(0,t) = g1(t) and u(a,t) = g2(t)  for  0 <= t <= b
%
% A numerical approximation is computed over the rectangle
%
%         0 <= x <= a ,   0 <= t <= b.

pause % Press any key to continue.

clc;
% Store f(x), g1(x), g2(x)  in  f.m  g1.m  g2.m
% function z = f(x)
% z = sin(pi*x) + sin(3*pi*x);
% function z = g1(t)
% z = 0;
% function z = g2(t)
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
            disp('z = sin(pi*x) + sin(3*pi*x);');...
diary off;
delete g1.m
diary  g1.m; disp('function z = g1(t)');...
             disp('z = 0;');...
diary off;
delete g2.m
diary  g2.m; disp('function z = g2(t)');...
             disp('z = 0;');...
diary off;
% Remark. f.m g1.m g2.m crnich.m trisys.m are used for Algorithm 10.3
f(0); g1(0); g2(0);
pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 10.4, page 515. Use the crank-Nicholson method
% to solve the heat equation  u (x,t) = u  (x,t).
%                              t         xx
% Place the endpoint of [0,a] in  a,  i.e. 0 <= x <= a.
% Place the endpoint of [0,b] in  b,  i.e. 0 <= t <= b.
% Enter the constant  c  for the heat equation.
% Enter the number of grid points  n  over the interval [0,a].
% Enter the number of grid points  m  over the interval [0,b].

a  =   1.0;
b  =   0.1;
c  =   1;
n  =  11;
m  =  11;

U = crnich('f','g1','g2',a,b,c,n,m);

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
meshz(T,X,U);
xlabel('t');
ylabel('x');
zlabel('u');
view([1 1 1]);
Mx1 = 'The Crank-Nicholson solution to the heat equation.';
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
