echo on; clc;
%---------------------------------------------------------------------------
%A5_2   MATLAB script file for implementing Algorithm 5.2
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
% Algorithm 5.2 (Least Squares Polynomial).
% Section	5.2, Curve Fitting, Page 278
%---------------------------------------------------------------------------

clc; clear all; format short;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program finds the least squares polynomial Pm(x), given
%
% a set of data points { (x , y ), (x , y ) ,..., (x , y ) }.
%                          1   1     2   2          n   n
%
% The abscissas and ordinates are stored in X and Y, respectively.
%
% X = [x , x  ,..., x ];  Y = [y , y  ,..., y ];
%       1   2        n          1   2        n
%
% Remark. lspoly.m is used for Algorithm 5.2

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example, page 277  Find the least squares quadratic polynomial.
%
% Enter the abscissas for the points in  X.
%
% Enter the ordinates for the points in  Y.
%
% Enter the degree of the polynomial in  m.

X = [-3  -2  -1   0  1   2   3  4];
Y = [ 3   2  1.5  1  1  1.5  3  5];

m = 2;

C = lspoly(X,Y,m);

pause % Press any key to find the least squares polynomial.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = -4;
b = 5;
h = (b-a)/150;
Xs = a:h:b;
Ys = polyval(C,Xs);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -4;
b =  5;
c =  0;
d =  6;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'or',Xs,Ys,'-g');
xlabel('x');
xlabel('x');
ylabel('y');
Mx1 = 'Least squares polynomial: y = P';
Mx2 = [Mx1,num2str(m),'(x).'];
title(Mx2);
grid;
hold off;
figure(gcf); pause % Press any key to continue.


points1 = [X;Y]; 


clc; format short;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1='y = P(x) = c(1)x^m + c(2)x^m-1 +...+ c(m)x + c(m+1)';
Mx2=['A polynomial of degree m = ',num2str(m),' has been fit.'];
Mx3='The coefficients are stored in the array  C = ';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(Mx2),disp(Mx3),...
disp(''),disp(C'),disp('The given x-y points:'),...
disp('      x         y'),disp(points1'),diary off,echo on
pause % Press any key to analyze the results.

% .. .. .. .. .. 
% Prepare results
% .. .. .. .. .. 
points2 = [X;Y;polyval(C,X);Y-polyval(C,X)]';

clc; format short;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx4='    x(k)      y(k)      P(x(k))   error';
clc,echo off,diary output,...
disp(''),disp(Mx4),disp(points2),diary off,echo on
pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example, page 278  Find the least squares cubic polynomial.
%
% Enter the abscissas for the points in  X.
%
% Enter the ordinates for the points in  Y.
%
% Enter the degree of the polynomial in  m.

X = [-3  -2  -1   0  1   2   3  4];
Y = [ 3   2  1.5  1  1  1.5  3  5];
m = 3;

C = lspoly(X,Y,m);

pause % Press any key to find the least squares polynomial.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = -4;
b = 5;
h = (b-a)/150;
Xs = a:h:b;
Ys = polyval(C,Xs);

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -4;
b =  5;
c =  0;
d =  6;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'or',Xs,Ys,'-g');
xlabel('x');
xlabel('x');
ylabel('y');
Mx1 = 'Least squares polynomial: y = P';
Mx2 = [Mx1,num2str(m),'(x).'];
title(Mx2);
grid;
hold off;
figure(gcf); pause % Press any key to continue.

% .. .. .. .. .. 
% Prepare results
% .. .. .. .. .. 
points1 = [X;Y]; format short;

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1='y = P(x) = c(1)x^m + c(2)x^m-1 +...+ c(m)x + c(m+1)';
Mx2=['A polynomial of degree m = ',num2str(m),' has been fit.'];
Mx3='The coefficients are stored in the array  C = ';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(Mx2),disp(Mx3),...
disp(''),disp(C'),disp('The given x-y points:'),...
disp('      x         y'),disp(points1'),diary off,echo on
pause % Press any key to analyze the results.

% .. .. .. .. .. 
% Prepare results
% .. .. .. .. .. 
points2 = [X;Y;polyval(C,X);Y-polyval(C,X)]';

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx4='    x(k)      y(k)      P(x(k))   error';
clc,echo off,diary output,...
disp(''),disp(Mx4),disp(points2),diary off,echo on
