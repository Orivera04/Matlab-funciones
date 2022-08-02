echo on; clc;
%---------------------------------------------------------------------------
%A4_2   MATLAB script file for implementing Algorithm 4.2
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
% Algorithm 4.2 (Polynomial Calculus).
% Section	4.2, Introduction to Interpolation, Page 212
%---------------------------------------------------------------------------

clc; clear all; format short;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%      Investigation of synthetic division for
%
% evaluating  Pn(x),  P'n(x)  and  int Pn(x)dx  where
%
% Pn(x) = c(1)x^n + c(2)x^(n-1) + ... + c(n)x + c(n+1)
%
% It is assumed that the constant K of integration is K = 0.
%
% Pn(x), P'n(x) and int Pn(x)dx are evaluated by invoking the Matlab
%
% subroutine polyval(C,X) polyval(Cd,X) polyval(Ci,X), respectively.

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Coefficient lists for several functions have been stored in M-files named;
%
% zcos   zsin   ztan  zexp    zacos  zasin    zatan   zcosh
% zsinh  zsqrt  zlog  zsqrt4  zinv   zemx2d2  zcosde  zsinde  zlogq
%
%      The user must determine the appropriate formula
%
% for  f'(x)  in order to graph  f'(x)  and  P'n(x).
%
% The user must also determine the formula for int f(x)dx
%
% in order to graph  int f(x)dx  and  int Pn(x)dx.

pause % Press any key continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% The algorithms are illustrated with the coefficients of the
%
% Taylor polynomial of degree  n = 11 for  f(x) = ln(1+x).
%
% Issue the command  zlog  to load the coefficients
%
% into the array  C.  The function name is loaded
%
% into the variable fun, the maximum degree is loaded into N.
%
% For graphing over [a,b] the endpoints are in  a  and  b.
%
% Load the Taylor coefficients.

[fun,dfun,ifun,x0,m,C,Ax] = zlog;

pause % Press any key continue.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = Ax(1,1);       % You can change the endpoint a.
b = Ax(1,2);       % You can change the endpoint b.
n = 11;            % You can change the degree n.
C = flipud(C);
C = C(1:n+1);
C = flipud(C);
h = (b-a)/200;
X = a:h:b;
x = X;
Y = eval(fun);
Z = polyval(C,X);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = Ax(1,1);       % You can change the endpoint a.
b = Ax(1,2);       % You can change the endpoint b.
c = Ax(1,3);       % You can change the lower value c.
d = Ax(1,4);       % You can change the upper value d.
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'-g',X,Z,'-r');
xlabel('x');
ylabel('y');
Mx1 = [fun,'  and  P'];
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
Mx1 = 'The function is  f(x) = ';
Mx2 = 'The interval is  ';
Mx3 = 'Pn(x) = c(1)x^n + c(2)x^(n-1) + ... + c(n)x + c(n+1)';
Mx4 = 'The degree is  n = ';
Mx5 = ', and the coefficients list  c  is:';
clc,echo off,diary output,...
disp(''),disp([Mx1,fun]),...
disp([Mx2,'[',num2str(a),' , ',num2str(b),']']),...
disp(Mx3),disp([Mx4,num2str(n),Mx5]),...
for i=1:5:n+1, disp(C([i:min(i+4,n+1)])'); end,...
diary off, echo on
pause % Press any key to graph f`(x) and P`n(x).

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
x = X;
Y = eval(dfun);
Dv = zeros(n,1);
for j=1:n,
  Dv(j) = n-j+1;            % Form vector [n,n-1,...,1]
end
Cd = C(1:n).*Dv;            % Coefficients for Pn`(x).
Z = polyval(Cd,X);

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = Ax(2,1);       % You can change the endpoint a.
b = Ax(2,2);       % You can change the endpoint b.
c = Ax(2,3);       % You can change the lower value c.
d = Ax(2,4);       % You can change the upper value d.
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'-g',X,Z,'-r');
xlabel('x');
ylabel('y');
Mx1 = [dfun,'  and  P`'];
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
Mx1 = 'The function is  f`(x) = ';
Mx2 = 'The interval is  ';
Mx3 = 'P`n(x) = d(1)x^n + d(2)x^(n-1) + ... + d(n)x + d(n+1)';
Mx4 = 'The degree is  n = ';
Mx5 = ', and the coefficients list  Cd  is:';
clc,echo off,diary output,...
disp(''),disp([Mx1,dfun]),...
disp([Mx2,'[',num2str(a),' , ',num2str(b),']']),...
disp(Mx3),disp([Mx4,num2str(n-1),Mx5]),...
for i=1:5:n, disp(Cd([i:min(i+4,n)])'); end,
diary off, echo on

pause % Press any key to graph int f(x)dx and int Pn(x)dx.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
x = X;
Y = eval(ifun);
Iv = zeros(n+1,1);
for j=1:n+1,
  Iv(j) = 1/(n-j+2);        % Form vector [1/(n+1),...,1/2,1]
end
Ci = C(1:n+1).*Iv;          % Coefficients for int Pn(x)dx.
Ci = [Ci;0];
Z = polyval(Ci,X);

clc; figure(3); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = Ax(3,1);       % You can change the endpoint a.
b = Ax(3,2);       % You can change the endpoint b.
c = Ax(3,3);       % You can change the lower value c.
d = Ax(3,4);       % You can change the upper value d.
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
hold on;
plot(X,Y,'-g',X,Z,'-r');
xlabel('x');
ylabel('y');
Mx1 = [ifun,'  and  int P'];
Mx2 = [Mx1,num2str(n),'(x)dx'];
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
Mx1 = 'The function is  int f(x)dx = ';
Mx2 = 'The interval is  ';
Mx3 = 'ŸPn(x)dx = a(1)x^n + a(2)x^(n-1) + ... + a(n)x + 0';
Mx4 = 'The degree is  n = ';
Mx5 = ', and the coefficients list  Ci  is:';
clc,echo off,diary output,...
disp(''),disp([Mx1,ifun]),...
disp([Mx2,'[',num2str(a),' , ',num2str(b),']']),...
disp(Mx3),disp([Mx4,num2str(n+1),Mx5]),...
for i=1:5:n+2, disp(Ci([i:min(i+4,n+2)])'); end,
diary off, echo on
