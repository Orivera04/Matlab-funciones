echo on; clc;
%---------------------------------------------------------------------------
%A7_5   MATLAB script file for implementing Algorithm 7.5
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
% Algorithm 7.5 (Adaptive Quadrature Using Simpson's Rule).
% Section	7.4, Adaptive Quadrature, Page 389
% This program is to be used for pedagogical purposes.
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program implements adaptive quadrature.
%
%
%
% Define and store the function f(x) in the M-file  f.m
%
% function y = f(x)
% y = 13.*(x - x.^2).*exp(-3.*x./2);

pause % Press any key to continue.

clc;
%.......................................................................
% Begin a section which enters the function(s) necessary for the example
% into M-file(s) by executing the diary command in this script file.
% The preferred programming method is not to use these steps.
% One should enter the function(s) into the M-file(s) with an editor.
delete output
delete f.m
diary  f.m; disp('function y = f(x)');...
            disp('y = 13.*(x - x.^2).*exp(-3.*x./2);');...
diary off;
f(0); % Remark. f.m adapt.m srule.m are used for Algorithm 7.5
pause % Press any key to see the graph y = f(x).

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = 0;
b = 4;
h = (b-a)/200;
X = a:h:b;
Y = f(X);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a =  0;
b =  4;
c = -1.5;
d =  2;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'g');
xlabel('x');
ylabel('y');
title('The curve y = f(x) over [a,b].');
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 7.16, page 387  Use adaptive quadrature to integrate
%
% the function  f(x) = 13(x - x^2)exp(-3x/2)  over  [a,b].
%
% Enter the endpoints a and b of the interval [a,b].
%
% Enter the tolerance in  toler.

a  = 0;
b  = 4;
toler = 0.00001;

[SRmat,quad,err] = adapt('f',a,b,toler);

pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'The adaptive quadrature approximation is: ';
Mx2 = '   quadrature value   +- error bound';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),...
disp(Mx2),disp([quad err]),diary off,echo on
pause % Press any key to continue.

clc;
X0 = [SRmat(:,1)',b];
Y0 = f(X0);
Z0 = zeros(1,length(X0));

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a =  0;
b =  4;
c = -1.5;
d =  2;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'g',X0,Y0,'or',X0,Z0,'+r');
xlabel('x');
ylabel('y');
title('Adaptive quadrature.');
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx3 = 'Quadrature over each subinterval:';
Mx4 = '   a(k)               b(k)               S(a(k),b(k))';
clc,echo off,diary output,disp(''),disp(Mx3),disp(''),...
disp(Mx4),disp(SRmat(:,[1 2 4])),...
disp(['   sum S(a(k),b(k))      sum error(k)']),...
disp(Mx2),disp([quad err]),diary off,echo on
