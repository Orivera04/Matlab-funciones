echo on; clc;
%---------------------------------------------------------------------------
%A7_2   MATLAB script file for implementing Algorithm 7.2
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
% Algorithm 7.2 (Composite Simpson Rule).
% Section	7.2, Composite Trapezoidal and Simpson's Rule, Page 365
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program implements Simpson's rule.
%
% The function f(x) is integrated over the interval [a,b].
%
%
%
% Define and store the function f(x) in the M-file  f.m
%
% function y = f(x)
% y = 1 + exp(-x).*sin(4*x);

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
            disp('y = 1 + exp(-x).*sin(4*x);');...
diary off;
f(0); % Remark. f.m simprl.m grpoly.m are used for Algorithm 7.2
pause % Press any key to see the graph y = f(x).

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = 0;
b = 1;
h = (b-a)/200;
X = a:h:b;
Y = f(X);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = 0;
b = 1;
c = 0;
d = 2;
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

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example, exercise 1(b), page 365  Use the composite Simpson's rule
%
% to integrate the function  f(x) = 1 + exp(-x)sin(4x)  over  [a,b].
%
% Enter the endpoints a and b of the interval [a,b].
%
% Enter the number of subintervals in  m.

a  = 0;
b  = 1;
m  = 4;

s = simprl('f',a,b,m);

pause % Press any key to continue.

clc;
% Begin section to print the results.
Mx1 = 'Simpson`s rule applied with 2m = ';
Mx2 = [Mx1,num2str(2*m),' subintervals is:'];
clc,disp(''),disp(Mx2),disp(''),disp(s)

pause % Press any key to see a nice graph y = f(x).

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = 0;
b = 1;
c = 0;
d = 2;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'g');
xlabel('x');
ylabel('y');
title('Simpson`s rule.');
if m <= 50,
  grpoly(a,b,m,2);
end;
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
clc,echo off,diary output,...
disp(''),disp(Mx2),disp(''),disp(s),diary off, echo on
