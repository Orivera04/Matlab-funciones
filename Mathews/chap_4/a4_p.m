echo on; clc;
%---------------------------------------------------------------------------
%A4_P   MATLAB script file for implementing Algorithm 4.p
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
% Algorithm 4.p (Pade rational Approximation).
% Section	4.6, Pade Approximations, Page 249
%---------------------------------------------------------------------------

clc; clear all; format short;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Investigation of a Pade rational approximations.
%                          Pn(x)
%      f(x)  •  Rn,m(x) = -------
%                          Qm(x)
% where the degrees of Pn and Qm are n and m, respectively.
%
% The algorithm requires the Maclaurin coefficients of f(x).
%
%
% Coefficient lists for several functions have been stored in M-files named;
%
% zcos   zsin   ztan  zexp    zacos  zasin    zatan   zcosh
% zsinh  zsqrt  zlog  zsqrt4  zinv   zemx2d2  zcosde  zsinde  zlogq
%
% Remark. pade.m is used for Algorithm 4.p

pause % Press any key continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%       Pade rational approximations for  f(x) = cos(x).
%
% Issue the command  zcos  to load the coefficients
%
% into the array  C.  The function name is loaded
%
% into the variable fun, the degree is loaded into  m.
%
% The endpoints of [a,b] are loaded into  a  and b.
%
% Load the Taylor coefficients.

[fun,dfun,ifun,x0,m,C,Ax] = zcos;

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 4.17, page 250 for f(x) = cos(x)
%
% Enter the degree of Pn(x) in  n
%
% Enter the degree of Qm(x) in  m
%
% Remark. Some combinations of n and m are incompatible.
%         This might result in a singular matrix
%         or division by zero where Qm(x) = 0.

n = 2;
m = 2;
[P,Q] = pade(C,n,m);

pause % Press any key to graph f(x) and Rn,m(x). 

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = -3;
b =  3;
X = a:.05:b;
x = X;
Y = eval(fun);
R = polyval(P,X)./polyval(Q,X);...

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
whitebg('w');
a = -3;
b =  3;
c = -1.5;
d =  1;
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'-g',X,R,'-r');
xlabel('x');
ylabel('y');
Mx1 = ['Comparison of ',fun,' and R'];
Mx2 = [Mx1,num2str(n),',',num2str(m),'(x)'];
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
Mx1 = 'The function is  f(x) = ';
Mx2 = 'The interval is  ';
Mx3 = 'Pn(x) = p(1)x^n + p(2)x^(n-1) + ... + p(n)x + p(n+1)';
Mx4 = 'The degree is  n = ';
Mx5 = ', and the coefficients list  P  is:';
Mx6 = 'Qm(x) = q(1)x^m + q(2)x^(m-1) + ... + q(m)x + q(m+1)';
Mx7 = 'The degree is  m = ';
Mx8 = ', and the coefficients list  Q  is:';
clc,format short e,echo off,diary output,...
disp(''),disp([Mx1,fun]),...
disp([Mx2,'[',num2str(a),' , ',num2str(b),']']),...
disp(Mx3),disp([Mx4,num2str(n),Mx5]),...
for i=1:5:n+1, disp(P([i:min(i+4,n+1)])); end,...
disp(Mx6),disp([Mx7,num2str(m),Mx8]),...
for i=1:5:m+1, disp(Q([i:min(i+4,m+1)])); end,...
diary off, echo on
pause % Press any key to graph f(x) - Rn,m(x).

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = -1;
b =  1;
h = (b-a)/200;
X = a:h:b;
x = X;
Y = eval(fun);
R = polyval(P,X)./polyval(Q,X);

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
whitebg('w');
a = -1;
b =  1;
c = min(Y-R);
d = max(Y-R);
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y-R,'-r');
xlabel('x');
ylabel('y');
Mx1 = ['The error;  ',fun,' - R'];
Mx2 = [Mx1,num2str(n),',',num2str(m),'(x)'];
title(Mx2);
grid;
hold off;

figure(gcf); pause% Press any key for a list of numerical computations.

clc;
a = -1.2;
b =  1.2;
X = a:0.1:b;
x = X;
Y = eval(fun);
R = polyval(P,X)./polyval(Q,X);
points = [X;Y;R;Y-R];

clc; format long;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1=['Pade rational approximation of f(x) = ',fun];
Mx2='     x(k)               f(x(k))            Rn,m(x(k))           error';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(points'),...
diary off,echo on
pause % Press any key to construct a Pade rational approximation.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 4.17, page 250 for f(x) = cos(x)
%
% Enter the degree of Pn(x) in  n
%
% Enter the degree of Qm(x) in  m
%
% Remark. Some combinations of n and m are incompatible.
%         This might result in a singular matrix
%         or division by zero where Qm(x) = 0.

n = 4;
m = 4;
[P,Q] = pade(C,n,m);

pause % Press any key to graph f(x) and Rn,m(x). 

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = -5;
b =  5;
X = a:.05:b;
x = X;
Y = eval(fun);
R = polyval(P,X)./polyval(Q,X);

clc; figure(3); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -5;
b =  5;
c = -1;
d =  1;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'-g',X,R,'-r');
xlabel('x');
ylabel('y');
Mx1 = ['Comparison of ',fun,' and R'];
Mx2 = [Mx1,num2str(n),',',num2str(m),'(x)'];
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
Mx1 = 'The function is  f(x) = ';
Mx2 = 'The interval is  ';
Mx3 = 'Pn(x) = p(1)x^n + p(2)x^(n-1) + ... + p(n)x + p(n+1)';
Mx4 = 'The degree is  n = ';
Mx5 = ', and the coefficients list  P  is:';
Mx6 = 'Qm(x) = q(1)x^m + q(2)x^(m-1) + ... + q(m)x + q(m+1)';
Mx7 = 'The degree is  m = ';
Mx8 = ', and the coefficients list  Q  is:';
clc,format short e,echo off,diary output,...
disp(''),disp([Mx1,fun]),...
disp([Mx2,'[',num2str(a),' , ',num2str(b),']']),...
disp(Mx3),disp([Mx4,num2str(n),Mx5]),...
for i=1:5:n+1, disp(P([i:min(i+4,n+1)])); end,...
disp(Mx6),disp([Mx7,num2str(m),Mx8]),...
for i=1:5:m+1, disp(Q([i:min(i+4,m+1)])); end,...
diary off, echo on
pause % Press any key to graph f(x) - Rn,m(x).

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = -1;
b =  1;
h = (b-a)/200;
X = a:h:b;
x = X;
Y = eval(fun);
R = polyval(P,X)./polyval(Q,X);

clc; figure(4); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -1;
b =  1;
c = min(Y-R);
d = max(Y-R);
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y-R,'-r');
xlabel('x');
ylabel('y');
Mx1 = ['The error;  ',fun,' - R'];
Mx2 = [Mx1,num2str(n),',',num2str(m),'(x)'];
title(Mx2);
grid;
hold off;

figure(gcf); pause % Press any key for a list of numerical computations..

clc;
% Prepare results
a = -1.2;
b =  1.2;
X = a:0.1:b;
x = X;
Y = eval(fun);
R = polyval(P,X)./polyval(Q,X);
points = [X;Y;R;Y-R];

clc; format long;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1=['Pade rational approximation of f(x) = ',fun];
Mx2='     x(k)               f(x(k))            Rn,m(x(k))           error';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(points'),...
diary off,echo on
