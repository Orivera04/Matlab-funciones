echo on; clc;
%---------------------------------------------------------------------------
%A8_4   MATLAB script file for implementing Algorithm 8.4
%
% NUMERICAL METHODS: MATLAB Programs, (c) John H. Mathews 1995
% To accompany the text:
% NUMERICAL METHODS for Mathematics, Science and Engineering, 2nd Ed, 1992
% Prentice Hall, Englewood Cliffs, New Jersey, 07632, U.S.A.
% This free software is compliments of the author.
% E-mail address:      in%"mathews@fullerton.edu"
%
% Algorithm 8.4, (Steepest Descent or Gradient Method).
% Section	8.1, Minimization of a Function, Page 418
%---------------------------------------------------------------------------

clc; clear all; format short;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program finds the minimum of a function Fn(X),
% where X is an n-dimensional vector.
% The technique is the gradient method for n-dimensions.
% The function  Fn(X)  is to be placed in two M-files.
% The function f.m is for graphing and Fn.m is for computing.
% The gradient of Fn(X) is to be placed in the M-file Gn.m
%
% function z = f(x,y)
% z = x.^2 - 4.*x + y.^2 - y - x.*y;
% function z = Fn(X)
% x = X(1); y = X(2);
% z = x^2 - 4*x + y^2 - y - x*y;
% function Z = Gn(X)
% x = X(1); y = X(2);
% G = [2*x-4-y, 2*y-1-x];
% if norm(G)~=0,
%   Z = -G/norm(G);
% else
%   Z = -G;
% end;

pause % Press any key to continue.

clc;
%.......................................................................
% Begin a section which enters the function(s) necessary for the example
% into M-file(s) by executing the diary command in this script file.
% The preferred programming method is not to use these steps.
% One should enter the function(s) into the M-file(s) with an editor.
delete output
delete f.m
diary  f.m; disp('function z = f(x,y)');...
            disp('z = x.^2 - 4.*x + y.^2 - y - x.*y;');...
diary off;
delete Fn.m
diary  Fn.m; disp('function z = Fn(X)');...
             disp('x = X(1); y = X(2);');...
             disp('z = x^2 - 4*x + y^2 - y - x*y;');...
diary off;
delete Gn.m
diary  Gn.m; disp('function Z = Gn(X)');...
             disp('x = X(1); y = X(2);');...
             disp('G = [2*x-4-y, 2*y-1-x];');...
             disp('if norm(G)~=0,');...
             disp('  Z = -G/norm(G);');...
             disp('else');...
             disp('  Z = -G;');...
             disp('end;');...
diary off;
% Remark. f.m Fn.m Gn.m grads.m are used for Algorithm 8.4
% Remark. f(x,y) is used only to graph 2-dimensional functions.
f(0,0); Fn([0 0]); Gn([0 0]);
pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example, from page 409.  Use the steepest descent or gradient method
% to find a local minimum of the function  f(x,y) = x^2 - 4x + y^2 - y - xy.
%
% The example is 2-dimensional, hence a surface z = f(x,y)
% can be graphed. (Omit this section for higher dimensions.)
%
% Enter the endpoints of the rectangle [a,b] x [c,d].
% Enter the maximum number of iterations in  max1   
% Enter the tolerances in  delta  and  epsilon.

a = 0;
b = 4;
c = 0;
d = 4;
max1 = 50;
delta = 1e-5;
epsilon = 1e-7;

pause % Press any key to continue.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = 0;
b = 4;
c = 0;
d = 4;
hs = (b-a)/16;
ks = (d-c)/16;
[Xs,Ys] = meshgrid(a:hs:b, c:ks:d);
Zs = f(Xs,Ys);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
whitebg('w');
mesh(Zs);
title('To search for a minimum of z = f(x,y).');
figure(gcf); pause % Press any key to enter the starting vertices.

clc;
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example, from page 409.  Use the steepest descent or gradient method
% to find a local minimum of the function  f(x,y) = x^2 - 4x + y^2 - y - xy.
%
% The gradient method is used to find the minimum
% of the n-dim function Fn(X). for convenience,
%
% For convenience, Fn(X) can be expressed using
% X = (x1,x2,x3,x4,x5,x6)  and the variables
% x = x1 , y = x2 , z = x3 , u = x4 , v = x5 , w = x6 
%
% You must supply the starting point P0(1:n)

P0 = [0.0   0.0];

% The subroutine grads('Fn','Gn',P0,max1,delta,epsilon,1);
% will be executed after the following graphics displsy.

pause % Press any key to find the minimum of Fn(X).

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a0 = 0;
b0 = 3.5;
c0 = 0;
d0 = 2.5;
whitebg('w');
plot([a0 b0],[0 0],'b',[0 0],[c0 d0],'b');
axis([a0 b0 c0 d0]);
axis(axis);
hold on;
plot(P0(1),P0(2),'o');
xlabel('x');
ylabel('y');
title('Iteration points for the gradient method.');
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc;
% Now execute the subroutine grads.
% Prepare printed and graphics results.
[P0,y0,h,err,P,Y] = grads('Fn','Gn',P0,max1,delta,epsilon,1);

clc; format long;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'The coordinates of the point  P  are:';
Mx2 = 'Error bound for the coordinates of  P:';
Mx3 = 'The minimum value  F(P)  is:';
Mx4 = 'Error bound for  F(P)  is:';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(P0),disp(Mx2),...
disp(['~ ',num2str(h),'      ~ ',num2str(h)]),disp(''),...
disp(Mx3),disp(y0),disp(Mx4),disp(['~ ',num2str(err)]),...
diary off,echo on
