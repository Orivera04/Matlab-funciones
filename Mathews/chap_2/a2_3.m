echo on; clc;
%---------------------------------------------------------------------------
%A2_3   MATLAB script file for implementing
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
% Algorithm 2.3 (False position or Regula Falsi Method).
% Section	2.2, Bracketing Methods for Locating a Root, Page 62
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program implements the Regula Falsi method.
%
%
% Define and store the function f(x) in the M-file f.m
%
% function y = f(x)
% y = x.*sin(x) - 1;

pause % Press any key to continue.

clc;
%.......................................................................
% Begin a section which enters the function(s) necessary for the example
% into M-file(s) by executing the diary command in this script file.
% The preferred programming method is not to use these steps.
% One should enter the function(s) into the M-file(s) with an editor.
delete output
delete f.m
diary  f.m; disp('function y = f(x)');...
            disp('y = x.*sin(x) - 1;');...
diary off;
% Remark. f.m and regula.m are used for Algorithm 2.3  
f(0); % Test for file f.m
pause % Press any key to see the graph y = f(x).

clc;
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot y = f(x).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = 0;
b = 2;
h = (b-a)/150;
X = a:h:b;
Y = f(X);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a =  0;
b =  2;
c = -1;
d =  1;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'-g');
xlabel('x');
ylabel('y');
title('Graph of y = f(x).');
grid;
hold off;

figure(gcf); pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 2.7, page 60.  Use the method of false position to locate 
% a zero of the function  f(x) = x sin(x) - 1.
%
% Enter the starting endpoints for [a,b] in a  and  b
% Enter the abscissa tolerance in  delta
% Enter the ordinate tolerance in  epsilon
% Enter the maximum number of iterations in  max1

a =  0;
b =  2;
delta = 1e-6;
epsilon = 1e-6;
max1 = 50;
 
[p,yp,err,P] = regula('f',a,b,delta,epsilon,max1);

pause % Press any key for the list of iterations.

clc;
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare arrays to graph and print results.
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
[m1 m2] = size(P);
n0 = min(7,m1);
Xa = P(1:n0,1); Xa = [a,Xa',b];
Xb = P(1:n0,2); Xb = [a,Xb',b];
Z0 = zeros(1,n0+2);


clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section for the results.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
a =  0;
b =  2;
c = -1;
d =  1;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'-g',Xa,Z0,'or',Xb,Z0,'or');
xlabel('x');
ylabel('y');
title('Graphical analysis for the Regula Falsi method.');
grid;
hold off;

figure(gcf); pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Iterations for the Regula-Falsi method.';
Mx2 = '     a                  b';
Mx3 = 'The approximate root is:';
Mx4 = 'The error estimate for p is  ~ ';
clc,echo off, diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(P),...
disp(''),disp(Mx3),disp(''),disp('p = '),disp(p),...
disp('f(p) = '),disp(yp),disp(''),...
disp([Mx4,num2str(err)]),diary off, echo on
