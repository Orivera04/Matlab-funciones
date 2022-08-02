echo on; clc;
%---------------------------------------------------------------------------
%A4_1B   MATLAB script file for implementing Algorithm 4.1
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
%      This program investigatges Taylor approximations.
%
% Pn(x) = c(1) + c(2)x + c(2)x^2 + ... + c(n+1)x^n
%
% where the degree n of approximation is large  (n ~ 25).
%
%
% Coefficient lists for several functions have been stored in M-files named;
%
% zcos   zsin   ztan  zexp    zacos  zasin    zatan   zcosh
% zsinh  zsqrt  zlog  zsqrt4  zinv   zemx2d2  zcosde  zsinde  zlogq

pause % Press any key continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%       Approximations for  tan(x)
%
% Issue the command  ztan  to load the coefficients
%
% into the array  C.  The function name is loaded
%
% into the variable fun, the degree is loaded into  m.
%
% The endpoints of [a,b] are loaded into  a  and b.
%
% Load the Taylor coefficients.

[fun,dfun,ifun,x0,m,C,Ax] = ztan;

pause % Press any key continue.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
n = m;          % You can change the degree n.
C = flipud(C);
C = C(1:n+1);
C = flipud(C);
a = Ax(1,1);    % You can change the left  endpoint a.
b = Ax(1,2);    % You can change the right endpoint b.
h = (b-a)/200;
X = a:h:b;
x = X; 
Y = eval(fun);
P = polyval(C,X);

clc; figure(1); clf;
%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = Ax(1,1);    % You can change the left  endpoint a.
b = Ax(1,2);    % You can change the right endpoint b.
c = Ax(1,3);    % You can change the lower value c.
d = Ax(1,4);    % You can change the upper value d.
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'-g',X,P,'-r');
xlabel('x');
ylabel('y');
Mx1 = ['Comparison of ',fun,' and P'];
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
Mx5 = ', and the coefficients list  C  is:';
clc,format short e,echo off,diary output,...
disp(''),disp([Mx1,fun]),...
disp([Mx2,'[',num2str(a),' , ',num2str(b),']']),...
disp(Mx3),disp([Mx4,num2str(n),Mx5]),...
for i=1:5:n+1, disp(C([i:min(i+4,n+1)])'); end,...
diary off, echo on
pause % Press any key to graph f(x) - Pn(x).

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
P = polyval(C,X);
c = min(Y-P);
d = max(Y-P);

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -1;
b =  1;
c = min(Y-P);
d = max(Y-P);
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y-P,'-r');
xlabel('x');
ylabel('y');
Mx1 = ['The error;  ',fun,' - P'];
Mx2 = [Mx1,num2str(n),'(x)'];
title(Mx2);
grid;
hold off;

figure(gcf); pause % Press any key for a list of numerical computations.

clc;
% Prepare results
a = -1.2;
b =  1.2;
X = a:0.1:b;
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
Mx1=['Taylor polynomial approximation of f(x) = ',fun];
Mx2='     x(k)               f(x(k))            Pn(x(k))           error';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(points'),...
diary off,echo on
