echo on; clc;
%---------------------------------------------------------------------------
%A4_5   MATLAB script file for implementing Algorithm 4.5
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
% Algorithm 4.5 (Newton Interpolation Polynomial).
% Section	4.4, Newton Polynomials, Page 234
%---------------------------------------------------------------------------

clc; clear all; format short;

% - - - - - - - - - - - - - - - - - - - - - - - -
%
% Investigation a Newton polynomial approximation.
%
% The n+1 are points needed to construct Pn(x).
%
% The abscissas are stored in  X.
%
% The ordinates are stored in  Y.
%
% The points are counted  k=1,2,...,n+1.
%
% Remark. newpoly.m is used for Algorithm 4.5

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 4.13, page 231 for  f(x) = cos(x)
% Newton polynomial approximation Pn(x) of f(x) over [a,b].
%
% Enter the degree of approximation in  n.
% Enter the left endpoint in  a.
% Enter the right endpoint in b.
% Enter the 'string expression' for f(x) in  fun.

n = 4;
a = 0;
b = 4;

fun = 'cos(x)';

pause % Press any key to form the coefficient polynomials.

clc;
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%
% The Newton interpolating polynomial is being constructed.

h = (b-a)/n;

X = a:h:b;

x = X;
Y = eval(fun);

[C,D] = newpoly(X,Y);

pause % Press any key to continue.

clc; format short;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Construction of a Newton approximation polynomial.';
Mx2 = 'The abscissas are:';
Mx3 = 'The ordinates are:';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(X),disp(Mx3),disp(Y),...
diary off, echo on
pause % Press any key for the divided difference table.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx = 'The divided difference table is:';
clc,echo off,diary output,...
disp(' '),disp(Mx),disp(D),diary off,echo on
pause % Press any key to graph the Newton approximation.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = min(X);
b = max(X);
h = (b-a)/150;
X1 = a:h:b;
Y1 = polyval(C,X1);
x = X1;
Y2 = eval(fun);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
whitebg('w');
a =  0;
b =  4;
c = -1.05;
d =  1.05;
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'or',X1,Y1,'-r',X1,Y2,'-g');
xlabel('x');
ylabel('y');
Mx1 = ['Comparison of ',fun,' and P'];
Mx2 = [Mx1,num2str(n),'(x).'];
title(Mx2);
grid;
hold off;

figure(gcf); pause	% Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1='The Newton polynomial has been rearranged in ordinary polynomial form.';
Mx2='This ordinary polynomial looks like:';
Mx3='Pn(x) = c(1)x^n + c(2)x^(n-1) + ... + c(n)x + c(n+1)';
Mx4 = 'The degree is  n = ';
Mx5 = ', and the coefficients list  C  is:';
clc,echo off, diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(''),...
disp(Mx3),disp(''),disp([Mx4,num2str(n-1),Mx5]),disp(''),...
for i=1:5:n+1, disp(C([i:min(i+4,n)])); end,...
diary off, echo on
pause % Press any key to view f(x) - Pn(x).

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
Z = zeros(1,length(X));

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
whitebg('w');
a = 0;
b = 4;
c = min(Y2-Y1);
d = max(Y2-Y1);
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Z,'or',X1,Y2-Y1,'-r');
xlabel('x');
ylabel('y');
Mx1 = ['The error: ',fun,' - P'];
Mx2 = [Mx1,num2str(n),'(x).'];
title(Mx2);
grid;
hold off;

figure(gcf); pause % Press any key for a list of numerical computations.

clc;
% Prepare results
X = a:0.25:b;
x = X;
Y = eval(fun);
P = polyval(C,X);
points = [X;Y;P;Y-P];

clc; format long;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1=['Newton polynomial approximation of f(x) = ',fun];
Mx2='     x(k)               f(x(k))            Pn(x(k))           error';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(points'),...
diary off,echo on
