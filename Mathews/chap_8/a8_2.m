echo on; clc;
%---------------------------------------------------------------------------
%A8_2   MATLAB script file for implementing Algorithm 8.2
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
% Algorithm 8.2 (Nelder-Mead's Minimization Method).
% Section	8.1, Minimization of a Function, Page 414
%---------------------------------------------------------------------------

clc; clear all; format short;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program finds the minimum of a function Fn(X),
% where X is an n-dimensional vector.
% The technique is the Nelder-Mead method for n-dimensions.
% The function  Fn(X)  is to be placed in two M-files 
% The function f.m is for graphing and Fn.m is for computing.
%
%
%
% function z = f(x,y)
% z = x.^2 - 4.*x + y.^2 - y - x.*y;
% function z = Fn(X)
% x = X(1); y = X(2);
% z = x^2 - 4*x + y^2 - y - x*y;

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
% Remark. f.m and Fn.m nelder.m are used for Algorithm 8.2
% Remark. f(x,y) is used only to graph 2-dimensional functions.
f(0,0); Fn([0 0]);
pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 8.4, page 409.  Use the Nelder-Mead method to find a
% local minimum of the function  f(x,y) = x^2 - 4x + y^2 - y - xy.
%
% The example is 2-dimensional, hence a surface z = f(x,y)
% can be graphed. (Omit this section for higher dimensions.)
% The endpoints of the rectangle [a,b] x [c,d] are a,b,c,d.

a = 0;
b = 4;
c = 0;
d = 3;

pause % Press any key to graph the 2-dim function.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a  = 0;
b  = 4;
c  = 0;
d  = 3;
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
title('To search for the minimum of z = f(x,y).');
figure(gcf); pause % Press any key to enter the starting vertices.

clc;
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% The Nelder-Mead simplex method or "polytope method is used to
% find the minimum of the n-dim function Fn(X), for convenience,
% Fn(X) can be expressed using  X = (x1,x2,x3,x4,x5,x6)  and the
% variables x = x1 , y = x2 , z = x3 , u = x4 , v = x5 , w = x6 
% You must supply  n+1 linearly independent starting points:
% For n=2, supply: V(1,1:n), V(2,1:n), V(3,1:n)
% For n=3, supply: V(1,1:n), V(2,1:n), V(3,1:n), V(4,1:n)
% Enter the minimum and maximum number of iterations
%       in min1 and max1, respectively.    
% Enter the tolerance in  epsilon.

a = 0;
b = 4;
c = 0;
d = 3;
min1 = 8;
max1 = 80;
epsilon = 1e-6;
n = 2;
V(1,1:n) = [0.0   0.0];
V(2,1:n) = [1.2   0.0];
V(3,1:n) = [0.0   0.8];

% The subroutine nelder('Fn',V,min1,max1,epsilon,1);
% will be executed after the following graphics displsy.

pause % Press any key to continue.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
XS = V(1:n+1,1)'; XSL = [XS,XS(1)];
YS = V(1:n+1,2)'; YSL = [YS,YS(1)];

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a0  = 0;
b0  = 4;
c0  = 0;
d0  = 3;
whitebg('w');
plot([a0 b0],[0 0],'b',[0 0],[c0 d0],'b');
axis([a0 b0 c0 d0]);
axis(axis);
hold on;
plot(XS,YS,'or',XSL,YSL,'-g');
xlabel('x');
ylabel('y');
title('The simplex vertices for Nelder-Mead`s method.');
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc;
% Now execute the subroutine nelder.
% Prepare printed and graphics results.
[V0,y0,dV,dy,P,Q] = nelder('Fn',V,min1,max1,epsilon,1);

clc; format long;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'The coordinates of the point P are:';
Mx2 = 'Error bound for the coordinates of  P:';
Mx3 = 'The minimum value  F(P)  is:';
Mx4 = 'Error bound for  F(P)  is:';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(V0),disp(Mx2),...
disp(['~ ',num2str(dV),'      ~ ',num2str(dV)]),disp(''),...
disp(Mx3),disp(y0),disp(Mx4),disp(['~ ',num2str(dy)]),...
diary off,echo on
