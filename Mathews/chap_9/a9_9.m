echo on; clc;
%---------------------------------------------------------------------------
%A9_9   MATLAB script file for implementing Algorithm 9.9
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
% Algorithm 9.9 (Linear Shooting Method).
% Section	9.8, Boundary Value Problems, Page 488
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program implements the linear shooting method
%
% for solving the boundary value problem
%
%       x'' = p(t)x'(t) + q(t)x(t) + r(t)
%
% over [a,b]  with  x(a) = alpha  and  x(b) = beta
%
% Use the change of variable  y = x'  and the  
%
% functions   p(t)x'(t) + q(t)x(t) + r(t)
%
%             p(t)x'(t) + q(t)x(t) 
%
% to form  fn1.m  and  fm2.m

pause % Press any key to continue.

clc;
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Apply the Runge-Kutta Method for a higher order to solve:
%
%     u'' = p(t)u'(t) + q(t)u(t) + r(t)
%     with  u(a) = alpha  and  u'(a) = 0
%
%     v'' = p(t)v'(t) + q(t)v(t)
%     with  v(a) = 0  and  v'(a) = 1
%
% Define and store the function fn1(t,Z) and fn2(t,Z)
% in the M-files  fn1.m  and  fn2.m
% function W = fn1(t,Z)
% x = Z(1);  y = Z(2);
% W = [y, (2*t*y/(1 + t^2) - 2*x/(1 + t^2) + 1)];
% function W = fn2(t,Z)
% x = Z(1);  y = Z(2);
% W = [y, (2*t*y/(1 + t^2) - 2*x/(1 + t^2))];
pause % Press any key to continue.

clc;
%.......................................................................
% Begin a section which enters the function(s) necessary for the example
% into M-file(s) by executing the diary command in this script file.
% The preferred programming method is not to use these steps.
% One should enter the function(s) into the M-file(s) with an editor.
delete output
delete fn1.m
diary fn1.m; disp('function W = fn1(t,Z)');...
             disp('x = Z(1);  y = Z(2);');...
             disp('W = [y, (2*t*y/(1 + t^2) - 2*x/(1 + t^2) + 1)];');...
diary off;
delete fn2.m
diary fn2.m; disp('function W = fn2(t,Z)');...
             disp('x = Z(1);  y = Z(2);');...
             disp('W = [y, (2*t*y/(1 + t^2) - 2*x/(1 + t^2))];');...
diary off;
% Remark. fn1.m fn2.m rks4.m are used for Algorithm 9.9
fn1(0,[0,0]);  fn2(0,[0,0]);
pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 9.17, page 486. Use the linear shooting method to solve the 
% boundary value problem  x''  =  2t/(1+t^2) x'  -  2/(1+t^2)  + 1
% with  x(0) = 1.25  and  x(4) = -0.95.
%
% Enter the endpoints a and b of the interval [a,b].
% Enter the initial  value  x(a)  in  alpha.
% Enter the terminal value  x(b)  in  beta.
% Enter the number of subintervals in  m.

a  = 0;
b  = 4;
alpha =  1.25;
beta  = -0.95;
m  = 20;

pause % Press any key to continue. 

clc;
% - - - - - - - - - - - - - - - - - - - - - - - -
%
%     Solving   u'' = p(t)u'(t) + q(t)u(t) + r(t)
%        with  u(a) = alpha
%        and  u'(a) = 0

Za = [alpha 0];
[T,Z] = rks4('fn1',a,b,Za,m);
U = Z(:,1)';

%     Solving   v'' = p(t)v'(t) + q(t)v(t)
%        with  v(a) = 0
%       and   v'(a) = 1
Za = [0 1];
[T,Z] = rks4('fn2',a,b,Za,m);
V = Z(:,1)';

%     Form the liear combination for  x(t).
X = U + (beta - U(m+1))*V/V(m+1);
points = [T;X];

pause % Press any key to see the list of solution points.

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a =  0;
b =  4;
c = -1.25;
d =  1.75;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(T,X,'-g');
if m<=30,
  plot(T,X,'or');
end;
xlabel('t');
ylabel('x');
Mx1 = 'The linear shooting solution to x`` = f(t,x,x`).';
title(Mx1);
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx2 = '     t(k)               x(k)';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(points'),...
diary off, echo on
