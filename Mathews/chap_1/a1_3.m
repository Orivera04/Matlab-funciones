echo on; clc;
%---------------------------------------------------------------------------
%A1_3   MATLAB script file for investigating Theorem 1.3
%
% NUMERICAL METHODS: MATLAB Programs, (c) John H. Mathews 1995
% To accompany the text:
% NUMERICAL METHODS for Mathematics, Science and Engineering, 2nd Ed, 1992
% Prentice Hall, Englewood Cliffs, New Jersey, 07632, U.S.A.
% Prentice Hall, Inc.; USA, Canada, Mexico ISBN 0-13-624990-6
% Prentice Hall, International Editions:   ISBN 0-13-625047-5
% This free software is compliments of the author.
% E-mail address:       in%"mathews@fullerton.edu"
%
% Theorem 1.3  (Extreme Value Theorem for a Continuous Function).
% Section 1.1,  Review of Calculus, Page 5
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Theorem 1.3  (Extreme Value Theorem for a Continuous Function).
%
% Assume that  f  is a continuous function on the interval [a,b].
%
% Then there exists a lower bound  M  and an upper bound  M  and
%                                   1                      2
% two numbers  x  , x  in  [a,b] such that
%               1    2
%     M  = f(x ) <= f(x) <= f(x ) = M     whenever   a <= x <= b.
%      1      1                2     2
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%                                                    2      3
% Example for page 5.  Let  f(x) = 35 + 59.5x - 66.5x  + 15x .
%
% Find the minimum and maximum of f(x) over the interval [0,3].
%
% Solution 1.  Sample f(x) at the n+1 equally spaced points
%
%              0 = x  < x  < ... < x  = 3
%                   0    1          n
%              and find approximations for the extreme values.

f = '35 + 59.5*x - 66.5*x.^2 + 15*x.^3';
x = 0:0.01:3;
y = eval(f);
% Compute approximations for the minimum and maximum of f over [0,3]:
ymin = min(y)
ymax = max(y)

pause % Press any key to continue.

clc;

% Solution 2.  Since the given function f(x) is also differentiable,
%
%              locate the critical values where  f'(x) = 0.

f = '35 + 59.5*x - 66.5*x^2 + 15*x^3';
diff(f,'x')
df = '59.5-133.0*x+45*x^2';
solve('59.5-133.0*x+45*x^2=0','x')
x1 = (133.0 - sqrt(133.0^2 - 4*45*59.5))/(2*45);
x  = x1
y1 = eval(f);
x2 = (133.0 + sqrt(133.0^2 - 4*45*59.5))/(2*45);
x  = x2
y2 = eval(f);

pause % Press any key to continue.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot y = f(x).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = 0;
b = 3;
F = '35 + 59.5*X - 66.5*X.^2 + 15*X.^3';
h = (b-a)/100;
X = a:h:b;
Y = eval(F);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = 0;
b = 3;
c = 0;
d = 52;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
title('The extreme value theorem for y = f(x).'); figure(gcf);
% fplot(f,[a b],'-g'); figure(gcf);
plot(X,Y,'-g'); figure(gcf);
plot(x1,y1,'or');
plot([x1-0.5 x1+0.5],[y1 y1],'-r');
plot(x2,y2,'or');
plot([x2-0.5 x2+0.5],[y2 y2],'-r');
plot([x1 x2],[0 0],'+r');
xlabel('x');
ylabel('y');
grid;
hold off;
figure(gcf);

clc;

%....................................
% Begin section to print the results.
%....................................
clc;disp(' ');disp('The maximum value for the function f(x):');...
disp(' ');disp(['f(x) = ' f]); ...
disp(' ');disp(['x1 = ' num2str(x1)]);...
disp(' ');disp(['max f(x) = f(x1) = y1 = ' num2str(y1)]);

[x1 y1]
pause % Press any key to continue.

clc;disp(' ');disp('The minimum value for the function f(x):');...
disp(' ');disp(['f(x) = ' f]);...
disp(' ');disp(['x2 = ' num2str(x2)]);...
disp(' ');disp(['min f(x) = f(x2) = y2 = ' num2str(y2)]);

[x2 y2]


