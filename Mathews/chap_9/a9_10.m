echo on; clc;
%---------------------------------------------------------------------------
%A9_10   MATLAB script file for implementing Algorithm 9.10
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
% Algorithm 9.10. (Finite-Difference Method).
% Section	9.9, Finite-Difference Method, Page 496
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program implements the finite difference
% method for solving the boundary value problem
%
%       x`` = p(t)x`(t) + q(t)x(t) + r(t)    
% with  x(a) = alpha, x(b) = beta
%
%
% Store p(t),q(t), r(t) in the M-files p.m  q.m  r.m 
% function z = p(t)
% z = 2*t/(1 + t^2);
% function z = q(t)
% z = - 2/(1 + t^2);
% function z = r(t)
% z = 1;

pause % Press any key to continue.

clc;
%.......................................................................
% Begin a section which enters the function(s) necessary for the example
% into M-file(s) by executing the diary command in this script file.
% The preferred programming method is not to use these steps.
% One should enter the function(s) into the M-file(s) with an editor.
delete p.m
diary  p.m; disp('function z = p(t)');...
            disp('z = 2*t/(1 + t^2);');...
diary off;
delete q.m
diary  q.m; disp('function z = q(t)');...
            disp('z = - 2/(1 + t^2);');...
diary off;
delete r.m
diary  r.m; disp('function z = r(t)');...
            disp('z = 1;');...
diary off;
% Remark. p.m  q.m  r.m findiff.m trisys.m are used for Algorithm 9.10
p(0); q(0); r(0);
pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 9.18, page 493. Use the finite difference method to solve the 
% boundary value problem  x''  =  2t/(1+t^2) x'  -  2/(1+t^2)  + 1
% with  x(0) = 1.25  and  x(4) = -0.95.
%
% Enter the endpoints a and b of the interval [a,b].
% Enter the initial  value x(a) in  alpha.
% Enter the terminal value x(b) in  beta.
% Enter the number of subintervals in  n.

a  = 0;
b  = 4;
alpha =  1.25;
beta  = -0.95;
n  = 20;

[T,X] = findiff('p','q','r',a,b,alpha,beta,n);
points = [T;X];

pause % Press any key to see the solution points.

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = 0;
b = 4;
c = min(X)-0.2;
d = max(X)+0.2;
whitebg('w');
axis([a b c d]);
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis(axis);
hold on;
plot(T,X,'-g');
if n<=30,
  plot(T,X,'or');
end;
xlabel('t');
ylabel('x');
Mx1 = 'The finite difference solution to x`` = f(t,x,x`).';
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
Mx2 = '     t(k)               x(k)'; clc;
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(points'),...
diary off,echo on
pause % Press any key to perform extrapolation.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 9.18, page 493. Use the finite difference method to solve the 
% boundary value problem  x''  =  2t/(1+t^2) x'  -  2/(1+t^2)  + 1
% with  x(0) = 1.25  and  x(4) = -0.95.
%
% Enter the endpoints a and b of the interval [a,b].
% Enter the initial  value x(a) in  alpha.
% Enter the terminal value x(b) in  beta.
% Enter the number of subintervals in  n.

a  = 0;
b  = 4;
alpha =  1.25;
beta  = -0.95;
n  = 20;

[T,X1] = findiff('p','q','r',a,b,alpha,beta,n);
[T,X2] = findiff('p','q','r',a,b,alpha,beta,2*n);
X2 = X2(1:2:length(X2));
[T,X3] = findiff('p','q','r',a,b,alpha,beta,4*n);
X3 = X3(1:4:length(X3));
T = T(1:4:length(T));
Z1 = (4*X2-X1)/3;
Z2 = (4*X3-X2)/3;
X = (16*Z2-Z1)/15;
points = [T;Z1;Z2;X];
pause % Press any key to see the solution points.

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = 0;
b = 4;
c = min(X)-0.2;
d = max(X)+0.2;
whitebg('w');
axis([a b c d]);
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis(axis);
hold on;
plot(T,X,'-g');
if n<=30,
  plot(T,X,'or');
end;
xlabel('t');
ylabel('x');
Mx1 = 'The finite difference solution to x`` = f(t,x,x`).';
title(Mx1);
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc; format long;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx2 = 'Extrapolated solutions z1(k), z2(k) and x(k).';
Mx3 = '     t(k)               z1(k)              z2(k)              x(k)';
clc,echo off,diary output,...
disp(''),
disp(''),disp(Mx1),disp(''),disp(Mx2),...
disp(''),disp(Mx3),disp(points'),...
diary off,echo on
