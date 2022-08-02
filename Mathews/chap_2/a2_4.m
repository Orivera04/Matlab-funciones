echo on; clc;
%---------------------------------------------------------------------------
%A2_4   MATLAB script file for implementing Algorithm 2.4
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
% Algorithm 2.4 (Approximate Location of Roots).
% Section	2.3, Initial Approximations & Convergence Criteria, Page 70
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% To approximately locate the roots of f(x) = 0  over [a,b].
%
%
% Define and store f(x) in the M-file  f.m
%
% function y = f(x)
% y = exp(-x./10) + sin(x);

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
            disp('y = exp(-x./10) + sin(x);');...
diary off;
% Remark. f.m and approot.m are used for Algorithm 2.4
f(0); % Test for file f.m
pause % Press any key to see the graph y = f(x).

clc;
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot y = f(x).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a =   0;
b =  30;
n = 100;
h = (b-a)/n;
X = a:h:b;
Y = f(X);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a =  0;
b = 30;
c = -1;
d =  2;
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

% - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example  Find the approximate location of the
% zeros of the function  f(x) = exp(-x/10) + sin(x)
% on an interval.
%
% Enter the abscissas in the vector  X.
% Enter the ordinates in the vector  Y.
% Enter the tolerance for a zero in epsilon.

a =   0;
b =  30;
n = 100;
h = (b-a)/n;

X = a:h:b;
Y = f(X);
epsilon  = 1e-2;

R = approot(X,Y,epsilon);

pause % Press any key to see the approximate root locations.

clc;
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare arrays to graph and print results.
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a =  0;
b = 30;
points = [R;f(R)];
n0 = length(R);
Z0 = zeros(1,n0);

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section for the results.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
a =  0;
b = 30;
c = -1;
d =  2;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'-g',R,Z0,'o');
xlabel('x');
ylabel('y');
Mx1 = 'Approximate location of the zeros.';
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
Mx1='The search interval is  [';
Mx2='Number of subintervals used is n = ';
Mx3=[Mx1,num2str(a),',',num2str(b),'].'];
Mx4=[Mx2,num2str(n)];
Mx5 = 'The approximate location of the zeros are:';
Mx6 = ['     x(k)               f(x(k))'];
clc,echo off, diary output,...
disp(''),disp(Mx3),disp(''),disp(Mx4),disp(''),disp(Mx5),...
disp(''),disp(Mx6),disp(points'),diary off, echo on
