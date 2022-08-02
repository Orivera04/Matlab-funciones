echo on; clc;
%---------------------------------------------------------------------------
%A4_1C   MATLAB script file for implementing Algorithm 4.1
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

clc; clear all; format short;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%      This program animates Taylor approximations.
%
% Pn(x) = c(1) + c(2)x + c(2)x^2 + ... + c(n+1)x^n
%
% where the degree n of approximation is large  (n ~ 25).
%
% Coefficient lists for several functions have been stored in M-files named;
%
% zcos   zsin   ztan  zexp    zacos  zasin    zatan   zcosh
% zsinh  zsqrt  zlog  zsqrt4  zinv   zemx2d2  zcosde  zsinde  zlogq

pause % Press any key continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Approximations for  tan(x)
%
% Issue the command  ztan  to load the coefficients
%
% into the array  C.  The function name is loaded
%
% into the variable fun, the degree is loaded into N.
%
% The endpoints of [a,b] are loaded into  a  and b.
%
% Load the Taylor coefficients.

[fun,dfun,ifun,x0,m,C,Ax] = ztan;

pause % Press any key continue.


% .. .. .. .. .. 
% Prepare results
% .. .. .. .. .. 
a = Ax(1,1);    % You can change the endpoint a.
b = Ax(1,2);    % You can change the endpoint b.
n = m;          % You can change the degree n.

clc;
% Begin section to print the results.
Mx1 = 'The function is  f(x) = ';
Mx2 = 'The interval is  ';
Mx3 = 'Pn(x) = c(1)x^n + c(2)x^(n-1) + ... + c(n)x + c(n+1)';
Mx4 = 'The degree is up to  n = ';
Mx5 = ', and the coefficients list  C  is:';
clc,format short e,...
disp(''),disp([Mx1,fun]),...
disp([Mx2,'[',num2str(a),' , ',num2str(b),']']),...
disp(Mx3),disp([Mx4,num2str(n),Mx5]),...
for i=1:5:n+1, disp(C([i:min(i+4,n+1)])'); end
pause % Press any key continue.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = Ax(1,1);    % You can change the left  endpoint a.
b = Ax(1,2);    % You can change the right endpoint b.
h = (b-a)/200;
X = a:h:b;
x = X;
Y = eval(fun);

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
hold on;
plot(X,Y,'-g');
title(['Comparison of ',fun,' and Pk(x).']);
xlabel('x');
ylabel('y');
for k = 3:n+1,
  Ck = flipud(C);
  Ck = Ck(1:k);
  Ck = flipud(Ck);
  P = polyval(Ck,X);
  plot(X,P,'-r');
end;
grid;
hold off;

figure(gcf); pause % Press any key to continue.

clc, format short e;
% Begin section to print the results.
disp(''),disp([Mx1,fun]),...
disp([Mx2,'[',num2str(a),' , ',num2str(b),']']),...
disp(Mx3),disp([Mx4,num2str(n),Mx5]),...
for i=1:5:n+1, disp(C([i:min(i+4,n+1)])'); end
