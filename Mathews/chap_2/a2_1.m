echo on; clc;
%---------------------------------------------------------------------------
%A2_1   MATLAB script file for implementing Algorithm 2.1
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
% Algorithm 2.1  (Fixed Point Iteration).
% Section	2.1,  Iteration for Solving  x = g(x), Page 51
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - -
%
% This program implements fixed point iteration.
%
% Define and store g(x)	in the M-file  g.m
%
%
% function y = g(x)
% y = 1 + x - x.^2 ./4;

pause % Press any key to continue.

clc;
%.......................................................................
% Begin a section which enters the function(s) necessary for the example
% into M-file(s) by executing the diary command in this script file.
% The preferred programming method is not to use these steps.
% One should enter the function(s) into the M-file(s) with an editor.
delete output
delete g.m
diary  g.m; disp('function y = g(x)');...
            disp('y = 1 + x - x.^2 ./4;');...
diary off;
% Remark. g.m and fixpt.m are used for Algorithm 2.1
g(0); % Test for file g.m
pause % Press any key to see the graph y = g(x).

clc;
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot y = g(x).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = 0;
b = 5;
h = (b-a)/150;
X = a:h:b;
Y = g(X);
X1 = [a b];
Y1 = [a b];

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = 0;
b = 5;
c = 0;
d = 3;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X1,Y1,'-r',X,Y,'-g');
xlabel('x');
ylabel('y');
title('The line y = x and the curve y = g(x).');
grid;
hold off;

figure(gcf); pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 2.3, page 49.  Investigate the nature of fixed point
% iteration for the function  g(x) = 1 + x - x^2/4.
%
% Enter the starting value in  p0
%
% Enter the number of iterations in  max1
%
% Enter the tolerance in  delta

p0 = 4.0;
max1  = 100;
delta = 1e-9;

[pc,err,P] = fixpt('g',p0,delta,max1);

pause % Press any key for the list of iterations.

clc;
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare arrays to graph and print the results.
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
max1 = length(P);
for j = 1:max1-1,
  k1 = 2*j-1;
  k2 = 2*j;
  Vx(k1) = P(j);
  Vy(k1) = P(j);
  Vx(k2) = P(j);
  Vy(k2) = P(j+1);
end
Vy(1) = 0;
Z0 = zeros(1,length(P));

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section for the results.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
a = 0;
b = 5;
c = 0;
d = 2;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b 0 2]);
axis(axis);
hold on;
plot(X1,Y1,'-g',X,Y,'-g',Vx,Vy,'-r',P,Z0,'or');
plot([a b],[0 0],'b',[0 0],[c d],'b');
xlabel('x');
ylabel('y');
title('Graphical analysis for fixed point iteration.');
grid;
hold off;

figure(gcf); pause % Press any key to continue.

% .. .. .. .. .. 
% Prepare results
% .. .. .. .. .. 
max1 = length(P);
J = 1:max1;
points = [J;P];

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Computations for the fixed point iteration method.';
Mx2 = '     k                  p(k)';
Mx3 = 'The fixed point is g(p) = p = ';
Mx4 = 'The error estimate for p is  ~ ';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(points'),...
disp(''),disp(Mx3),disp(pc),...
disp([Mx4,num2str(err)]),diary off,echo on
