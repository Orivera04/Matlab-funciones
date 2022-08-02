echo on; clc;
%---------------------------------------------------------------------------
%A4_1A   MATLAB script file for implementing Algorithm 4.1
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
% Algorithm 4.1 (Evaluation of a Taylor Series).
% Section	4.1, Taylor Series and Calculation of Functions, Page 203
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program investigatges Taylor polynomial approximations.
%
% Pn(x) = c(1) + c(2)x + c(2)x^2 + ... + c(n+1)x^n
%
%
% Coefficient lists for several functions have been stored in M-files named;
%
% zcos   zsin   ztan  zexp    zacos  zasin    zatan   zcosh
% zsinh  zsqrt  zlog  zsqrt4  zinv   zemx2d2  zcosde  zsinde  zlogq

C = [1/120,0,-1/6,0,1,0];

fun = 'sin(x)';

pause % Press any key to graph f(x) and Pn(x).

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
n = length(C)-1;
X = 0:0.01:pi;
x = X;
Y = eval(fun);
P = polyval(C,X);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -0.1;
b =  3.2;
c = -0.1;
d =  1.05;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'-g',X,P,'-r');
xlabel('x');
ylabel('y');
Mx1 = ['Comparison of ',fun,' and P'];
Mx2 = [Mx1,num2str(n),'(x) over ['];
Mx3 = [Mx2,num2str(a),',',num2str(b),'].'];
title(Mx3);
grid;
hold off;

figure(gcf); pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'The function is  f(x) = ';
Mx2 = 'Pn(x) = c(1)x^n + c(2)x^(n-1) + ... + c(n)x + c(n+1)';
Mx3 = 'The degree is  n = ';
Mx4 = ', and the coefficients list  c  is:';
clc,echo off,format short,diary output,...
disp(''),disp([Mx1,fun]),...
disp(Mx2),disp([Mx3,num2str(n),Mx4]),...
for i=1:5:n+1, disp(C([i:min(i+4,n+1)])); end,...
diary off,echo on,format long
pause % Press any key to graph f(x) - Pn(x).

clc; figure(2); clf;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Begin graphics section
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = -0.1;
b =  1.0;
c = -0.0002;
d =  0.00001;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y-P,'-r');
xlabel('x');
ylabel('y');
Mx1 = ['The error: ',fun,' - P'];
Mx2 = [Mx1,num2str(n),'(x) over ['];
Mx3 = [Mx2,num2str(a),',',num2str(b),'].'];
title(Mx3);
grid;
hold off;

figure(gcf); pause % Press any key for a list of numerical computations.

clc;
% Prepare results
X = 0:0.05:1;
x = X;
Y = eval(fun);
P = polyval(C,X);
points = [X;Y;P;Y-P];

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1=['Taylor polynomial approximation of f(x) = ',fun];
Mx2='     x(k)               f(x(k))            Pn(x(k))           error';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(points'),...
diary off, echo on
pause % Press any key for another Taylor polynomial.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% The coefficient list for the Taylor polynomial of degree
%
% n = 9  for  f(x) = exp(x)  is stored in the vector  C
%
% The function  exp(x)  is stored in the string variable  fun

C = [1/362880,1/40320,1/5040,1/720,1/120,1/24,1/6,1/2,1,1];

fun = 'exp(x)';

X = -8:0.05:8;
x = X;
Y = eval(fun);
P = polyval(C,X);

pause % Press any key to graph f(x) and Pn(x).

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
n = length(C)-1;

clc; figure(3); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a =   -8;
b =    8;
c = -200;
d = 2000;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'-g',X,P,'-r');
xlabel('x');
ylabel('y');
Mx1 = ['Comparison of ',fun,' and P'];
Mx2 = [Mx1,num2str(n),'(x) over ['];
Mx3 = [Mx2,num2str(a),',',num2str(b),'].'];
title(Mx3);
grid;
hold off;

figure(gcf); pause% Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'The function is  f(x) = ';
Mx2 = 'Pn(x) = c(1)x^n + c(2)x^(n-1) + ... + c(n)x + c(n+1)';
Mx3 = 'The degree is  n = ';
Mx4 = ', and the coefficients list  c  is:';
clc,echo off,format short,diary output,...
disp(''),disp([Mx1,fun]),...
disp(Mx2),disp([Mx3,num2str(n),Mx4]),...
for i=1:5:n+1, disp(C([i:min(i+4,n+1)])); end,...
diary off, echo on,format long
pause % Press any key to graph f(x) - Pn(x).

clc; figure(4); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -1.0;
b =  1.0;
c = -0.00000001;
d =  0.0000003;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y-P,'-r');
xlabel('x');
ylabel('y');
Mx1 = ['The error: ',fun,' - P'];
Mx2 = [Mx1,num2str(n),'(x) over ['];
Mx3 = [Mx2,num2str(a),',',num2str(b),'].'];
title(Mx3);
grid;
hold off;

figure(gcf); pause % Press any key for a list of numerical computations.

clc;
% Prepare results
X = -1:0.1:1;
x = X;
Y = eval(fun);
P = polyval(C,X);
points = [X;Y;P;Y-P];

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1=['Taylor polynomial approximation of f(x) = ',fun];
Mx2='     x(k)               f(x(k))            Pn(x(k))           error';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(points'),...
diary off, echo on
