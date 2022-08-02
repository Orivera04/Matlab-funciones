echo on; clc;
%---------------------------------------------------------------------------
%A7_6   MATLAB script file for implementing Algorithm 7.6
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
% Algorithm 7.6 (Gauss-Legendre Quadrature).
% Section	7.5, Gauss-Legendre Integration, Page 397
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program implements Gaussian quadrature.
%
% The function f(x) is integrated over the interval [a,b].
%
%
%
% Define and store the function f(x) in the M-file  f.m
%
% function y = f(x)
% y = 13.*(x - x.^2).*exp(-3.*x./2);

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
            disp('y = 13.*(x - x.^2).*exp(-3.*x./2);');...
diary off;
f(0); % Remark. f.m gauss.m gauraw.m gauaw.mat are used for Algorithm 7.6
% The abscissas and weights are loaded from the file gauaw.mat
% gauraw.m contains the instructions to read this file.
pause % Press any key to see the graph y = f(x).

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = 0;
b = 4;
h = (b-a)/200;
X1 = a:h:b;
Y1 = f(X1);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a =  0;
b =  4;
c = -1.5;
d =  2;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X1,Y1,'g');
xlabel('x');
ylabel('y');
title('The curve y = f(x) over [a,b].');
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc;
% - - - - - - - - - - - - - - - - - -
%
% Be patient for a moment.
%
% Loading the abscissas and weights.

[A,W] = gauraw;

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 7.16, page 387  Use Gaussian quadrature to integrate
%
% the function  f(x) = 13(x - x^2)exp(-3x/2)  over  [a,b].
%
% Enter the endpoints a and b of the interval [a,b].
%
% Enter the tolerance in toler.

a  = 0;
b  = 4;
toler = 0.00001;

[Q,N,X,quad,err] = gauss('f',a,b,A,W,toler);

pause % Press any key to continue.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
Y = f(X);
Z = zeros(1,length(X));

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a =  0;
b =  4;
c = -1.5;
d =  2;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X1,Y1,'g',X,Y,'or',X,Z,'+r');
xlabel('x');
ylabel('y');
title('Gaussian quadrature.');
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc;
% Prepare results
values = [N;Q];

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'The Gaussian quadrature approximations: ';
Mx2 = '     No. of nodes       quadrature value';
Mx3 = 'The approximate value of the integral is:';
Mx4 = '   quadrature value   +- error bound';
clc,echo off,diary output,...
disp(Mx1),disp(''),disp(Mx2),disp(values'),...
disp(Mx3),disp(Mx4),disp([quad err]),,diary off,echo on
