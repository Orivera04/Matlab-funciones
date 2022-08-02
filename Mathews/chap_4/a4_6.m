echo on; clc;
%---------------------------------------------------------------------------
%A4_6   MATLAB script file for implementing Algorithm 4.6
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
% Algorithm 4.6 (Chebyshev Approximation).
% Section	4.5, Chebyshev Polynomials, Page 246
%---------------------------------------------------------------------------

clc; clear all; format short;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Investigation of a Chebyshev polynomial approximations.
%
% n+1 are points needed to construct Pn(x).
%
% The abscissas are stored in  X.
%
% The ordinates are stored in  Y.
%
% The points are counted k=1,2,...,n+1.
%
%
% Coefficient lists for several functions have been stored in M-files named;
%
% zcos   zsin   ztan  zexp    zacos  zasin    zatan   zcosh
% zsinh  zsqrt  zlog  zsqrt4  zinv   zemx2d2  zcosde  zsinde  zlogq
%
% Remark. cheby.m and tch.m are used for Algorithm 4.6

pause % Press any key to construct the Chebyshev coefficients.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 4.14, page 241 for  f(x) = exp(x)
% Chebyshev polynomial approximation Pn(x) of f(x) over [-1,1].
%
% Enter the degree of approximation in  n.
% Enter the left endpoint in  a.
% Enter the right endpoint in b.
% Enter the 'string expression' for f(x) in  fun.

n =  4;
a = -1;
b =  1;

fun = 'exp(x)';

[C,X,Y] = cheby(fun,n,a,b);

pause % Press any key to form the coefficient polynomials.

clc; format short;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Construction of a Chebyshev approximation polynomial.';
Mx2 = 'The abscissas are:';
Mx3 = 'The ordinates are:';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(X),disp(Mx3),disp(Y),...
diary off, echo on
pause % Press any key to graph the Chebyshev approximation.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
h = (b-a)/150;
X1 = a:h:b;
x = X1;
Y1 = eval(fun);
P = tch(C,n,x,a,b);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -1;
b =  1;
c =  0;
d =  2.8;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'or',X1,P,'-g',X1,Y1,'-r');
xlabel('x');
ylabel('y');
Mx1 = 'Comparison of exp(x) and P';
Mx2 = [Mx1,num2str(n),'(x)'];
title(Mx2);
grid;
hold off;

figure(gcf); pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1='The Chebyshev polynomial has been rearranged in ordinary polynomial form.';
Mx2='This ordinary polynomial looks like:';
Mx3='Pn(x) = c(1)x^n + c(2)x^(n-1) + ... + c(n)x + c(n+1)';
Mx4 = 'The degree is  n = ';
Mx5 = ', and the coefficients list  C  is:';
clc,echo off, diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(''),...
disp(Mx3),disp(''),disp([Mx4,num2str(n),Mx5]),disp(''),...
for i=1:5:n+1, disp(C([i:min(i+4,n+1)])); end,...
diary off, echo on
pause % Press any key to graph the error for the approximation.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
Z = zeros(1,n+1);

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -1;
b =  1;
c = min(Y1-P);
d = max(Y1-P);
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Z,'or',X1,Y1-P,'-g');
xlabel('x');
ylabel('y');
Mx1 = ['The error: ',fun,' - P'];
Mx2 = [Mx1,num2str(n),'(x)'];
title(Mx2);
grid;
hold off;

figure(gcf); pause % Press any key to continue.

clc;
% Prepare results
X = -1:0.2:1;
x = X;
Y = eval(fun);
P = tch(C,n,x,a,b);
points = [X;Y;P;Y-P];

clc; format short e;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1=['Chebyshev polynomial approximation of f(x) = ',fun];
Mx2='     x(k)         f(x(k))      Pn(x(k))     error';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(points'),...
diary off,echo on
