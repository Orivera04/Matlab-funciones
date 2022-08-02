echo on; clc;
%---------------------------------------------------------------------------
%A5_5   MATLAB script file for implementing Algorithm 5.5
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
% Algorithm 5.5 (Trigonometric Polynomials).
% Section	5.4, Fourier Series and Trigonometric Polynomials, Page 311
%---------------------------------------------------------------------------

clc; clear all; format short;

% - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program finds the trigonometric polynomial
%
% for periodic data in the interval [-pi,pi].
%
%
% Remark. tpcoeff.m and tp.m are used for Algorithm 5.5

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 5.14, page 310  Find the trigonomtric polynomial(s).
%
% The computer will place the abscissas in  X
% The computer will place the ordinates in  Y
%
% Enter the f(x) in the 'string function'  fun
%
% Enter the number of points in  n.
%
% Enter the order of the trig. poly. in  m

fun = 'x/2';
n = 12;
m = 5;

h = 2*pi/n;
X = -pi:h:pi;
x = X;
Y = eval(fun);

[A,B] = tpcoeff(X,Y,m);

pause % Press any key to find the trigonometric polynomial.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
hs = 2*pi/150;
Xs = -pi:hs:pi;
Ys = tp(A,B,Xs,m);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -3.5;
b =  3.5;
c = -2;
d =  2;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
plot(X,Y,'or',Xs,Ys,'-g');
xlabel('x');
ylabel('y');
Mx1 = 'Trigonometric polynomial: y = P';
Mx2 = [Mx1,num2str(m),'(x)'];
title(Mx2);
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc; format short e;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'The trigonometric polynomial has been determined.';
Mx2 = 'The degree is  m = ';
Mx3 = [Mx2,num2str(m)];
Mx4 = 'The coefficients a(n) for cos(nx) are:';
Mx5 = 'The coefficients b(n) for sin(nx) are:';
clc,echo off,diary output,...
disp(Mx1),disp(''),disp(Mx3),disp(''),...
disp(Mx4),disp(''),for i=1:5:m+1,disp(A([i:min(i+4,m+1)]));end,...
disp(Mx5),disp(''),for i=1:5:m+1,disp(B([i:min(i+4,m+1)]));end,...
diary off,echo on

pause % Press any key to continue.

% .. .. .. .. .. 
% Prepare results
% .. .. .. .. .. 
points = [X;Y;tp(A,B,X,m);Y-tp(A,B,X,m)]';

clc; format short;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx6 = '    x(k)      y(k)      P(x(k))   error';
clc,echo off,diary output,...
disp(''),disp(Mx6),disp(points),diary off,echo on
pause % Press any key to find another trigonometric polynomial.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 5.14, page 310  Find the trigonomtric polynomial(s).
%
%
% Enter the order of the trig. poly. in  m

m = 2;

[A,B] = tpcoeff(X,Y,m);

% Remark. Now the degree is only m = 2.

pause % Press any key to continue.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
hs = 2*pi/150;
Xs = -pi:hs:pi;
Ys = tp(A,B,Xs,m);

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -3.5;
b =  3.5;
c = -2;
d =  2;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'or',Xs,Ys,'-g');
xlabel('x');
ylabel('y');
Mx1 = 'Trigonometric polynomial: y = P';
Mx2 = [Mx1,num2str(m),'(x)'];
title(Mx2);
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc; format short e;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'The trigonometric polynomial has been determined.';
Mx2 = 'The degree is  m = ';
Mx3 = [Mx2,num2str(m)];
Mx4 = 'The coefficients a(n) for cos(nx) are:';
Mx5 = 'The coefficients b(n) for sin(nx) are:';
clc,echo off,diary output,...
disp(Mx1),disp(''),disp(Mx3),disp(''),...
disp(Mx4),disp(''),for i=1:5:m+1,disp(A([i:min(i+4,m+1)]));end,...
disp(Mx5),disp(''),for i=1:5:m+1,disp(B([i:min(i+4,m+1)]));end,...
diary off,echo on

pause % Press any key to continue.

% .. .. .. .. .. 
% Prepare results
% .. .. .. .. .. 
points = [X;X;tp(A,B,X,m);Y-tp(A,B,X,m)]';

clc; format short;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx6 = '    x(k)      y(k)      P(x(k))   error';
clc,echo off,diary output,...
disp(''),disp(Mx6),disp(points),diary off,echo on
