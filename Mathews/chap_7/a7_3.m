echo on; clc;
%---------------------------------------------------------------------------
%A7_3   MATLAB script file for implementing Algorithm 7.3
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
% Algorithm 7.3 (Recursive Trapezoidal Rule).
% Section	7.3, Recursive Rules and Romberg Integration, Page 378
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program implements the recursive trapezoidal rule.
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
f(0); % Remark. f.m rctrap.m grpoly.m are used for Algorithm 7.3
pause % Press any key to see the graph y = f(x).

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = 0;
b = 1;
h = (b-a)/200;
x0 = a:h:b;
y0 = f(x0);

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
plot(x0,y0,'g');
xlabel('x');
ylabel('y');
title('The curve y = f(x) over [a,b].');
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example, exercise 1(b), page 365  Use the recursive trapezoidal rule
%
% to integrate the function  f(x) = 1 + exp(-x)sin(4x)  over  [a,b].
%
% Enter the endpoints a and b of the interval [a,b].
%
% Enter the number of times to bisect [a,b] in  N.

a  = 0;
b  = 1;
n  = 6;

T = rctrap('f',a,b,n);

pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
for i=0:n, J(i+1) = 2^i; end
values = [J;T];
Mx1 = 'The recursive trapezoidal rule results: ';
Mx2 = '   # subintervals     trapezoidal rule';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(values'),diary off,echo on

pause % Press any key to see a nice graph y = f(x).

clc;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
for i=1:(n+1),
  if J(i) <= 16,
    clc; figure(i+1); clf;
    a = 0;
    b = 1;
    c = 0;
    d = 2;
    whitebg('w');
    plot([a b],[0 0],'b',[0 0],[c d],'b');
    axis([a b c d]);
    axis(axis);
    hold on;  
    grpoly(a,b,J(i),1);
	xlabel('x');
    ylabel('y');
    title('The recursive trapezoidal rule.');
	grid;
	hold off;
  end
end;
pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'The recursive trapezoidal rule was applied with ';
Mx2 = [Mx1,num2str(n),' recursions.'];
Mx3 = 'The approximate value of the integral is:';
clc,echo off,diary output,disp(''),disp(Mx2),...
disp(''),disp(Mx3),disp(T(n+1)),diary off, echo on
