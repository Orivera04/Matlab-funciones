echo on; clc;
%---------------------------------------------------------------------------
%A6_3   MATLAB script file for implementing Algorithm 6.3
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
% Algorithm 6.3 (Differentiation Based on N+1 Nodes).
% Section	6.2, Numerical Differentiation Formulas, Page 342
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program differentiates a Newton polynomial approximation.
% n+1  are points needed to construct  Pn(x).
%
% The abscissas are stored in  X.
% The ordinates are stored in  Y.
% The points are counted k = 1,2,...,n+1.
%
% The example investigates f(x) = cos(x) using 5 nodes.
%
% The derivative is approximated at X(1).
%
% The function f(x) is stored in the M-file  f.m
% function z = f(x)
% z = cos(x);

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
            disp('z = cos(x);');...
diary off;
f(0); % Remark. f.m and diffnew.m are used for Algorithm 6.3
pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example, page 339-342  Use a Newton polynomial P(x) to approximate
% the function  f(x) = cos(x)  and then approximate  f'(x)  with  P'(x).
%
% Enter the abscissa for differentiation in x0.
%
% Enter the endpoints interval [a0,b0] about x0 in a0 and b0.

x0 = 0.8;

a0  = 0;

b0  = pi/2;

pause % Press any key to graph the function.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
y0 = f(x0);
hs = (b0-a0)/100;
Xs = a0:hs:b0;
Ys = f(Xs);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = 0;
b = 1.6;
c = 0;
d = 1.1;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(x0,y0,'o',Xs,Ys);
xlabel('x');
ylabel('y');
title('y = f(x) and the given point');
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example, page 339-342  Use a Newton polynomial P(x) to approximate
% the function  f(x) = cos(x)  and then approximate  f'(x)  with  P'(x).
%
% Enter the abscissa for differentiation in  x0.
%
% Enter the number of points in  n.
%
% Enter the step size in  h.

x0 = 0.8;
n = 5;
h = 0.01;
X = x0:h:x0+(n-1)*h;
Y = f(X);

[A,df] = diffnew(X,Y);

pause % Press any key to continue.


clc; format short;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx0 = 'Approximating the derivative by differentiating a Newton polynomial.';
Mx1 = 'First construct the Newton approximation polynomial.';
Mx2 = 'The abscissas are:';
Mx3 = 'The ordinates are:';
Mx4 ='The coefficients for the Newton polynomial are:';
Mx5 = 'The centers for the Newton polynomial are:';
clc,echo off,diary output,...
disp(''),disp(Mx0),disp(''),disp(Mx1),disp(''),disp(Mx2),disp(X),...
disp(Mx3),disp(Y),disp(''),disp(Mx4),format short,disp(A),...
disp(Mx5),disp(X(1:n-1)),diary off, echo on,format long

pause % Press any key to see the approximate derivative.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
X1 = [a b];
C = [df f(x0)];
Y1 = polyval(C,X1-x0);

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(x0,y0,'or',Xs,Ys,'-g',X1,Y1,'-r');
xlabel('x');
ylabel('y');
title('The tangent line has slope m = f`(x0).');
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc; format short;
% Begin section to print the results.
Mx1 = 'Numerical approximation for the derivative.';
Mx2 =  ['f`(',num2str(X(1)),')'];
Mx3 =  ['P`(',num2str(X(1)),')'];
Mx4 = [Mx2,' ~ ',Mx3,' = '];
clc,disp(''),disp(Mx1),...
disp(''),disp(Mx4),disp(df)

pause % Press any key to zoom in.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = min(X)-3*h;
b = max(X)+3*h;
c = min(Y)-3*h;
d = max(Y)+3*h;
X1 = [a b];
C = [df f(x0)];
Y1 = polyval(C,X1-x0);
X0 = X(2:n);
Y0 = Y(2:n);

clc; figure(3); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(x0,y0,'or',X0,Y0,'og',Xs,Ys,'-g',X1,Y1,'-r');
xlabel('x');
ylabel('y');
title('The tangent line has slope m = f`(x0).');
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc; format short;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Numerical approximation for the derivative.';
Mx2 =  ['f`(',num2str(X(1)),')'];
Mx3 =  ['P`(',num2str(X(1)),')'];
Mx4 = [Mx2,' ~ ',Mx3,' = '];
clc,echo off,diary output,...
disp(''),disp(Mx1),...
disp(''),disp(Mx4),disp(df),diary off,echo on
