echo on; clc;
%---------------------------------------------------------------------------
%A5_3A   MATLAB script file for implementing Algorithm 5.3
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
% Algorithm 5.3 (Non-linear Curve Fitting).
% A detailed look at the exponential curve fit.
% Section	5.2, Curve Fitting, Page 280
%---------------------------------------------------------------------------

clc; clear all; format short;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program performs exponential curve fitting,
%
% by using the method of data linearization. Given a set
%
% of data points { (x , y ), (x , y ) ,..., (x , y ) },
%                    1   1     2   2          n   n
%
% The abscissas and ordinates are stored in X and Y, respectively.
%
% X = [x , x  ,..., x ];  Y = [y , y  ,..., y ];
%       1   2        n          1   2        n

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 5.4, page 269  Find the least squares exponential fit.
%
% Enter the abscissas for the points in  X.
%
% Enter the ordinates for the points in  Y.

X = [0    1    2    3    4];
Y = [1.5  2.5  3.5  5.0  7.5];

pause % Press any key to graph data points.

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -0.1;
b =  4.1;
c = -0.2;
d =  8.2;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'or');
xlabel('x');
ylabel('y');
title('The given x-y data points');
grid;
hold off;
figure(gcf); pause % Press any key to continue.


points = [X;Y];

clc; format short;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
clc,echo off,diary output,disp('The given x-y points:'),...
disp('      x         y'),disp(points'),diary off,echo on
pause % Press any key to "linearize" the data points.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
XT  = X;
YT  = log(Y);
Ya = 1;
p = polyfit(XT,YT,1);
A = p(1);
B = p(2);
Xs = [min(X) max(X)];
Ys = polyval(p,Xs);

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -0.2;
b =  4.2;
c = -0.1;
d =  2.1;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(XT,YT,'or',Xs,Ys,'-g');
xlabel('X');
ylabel('Y');
Mx1 = 'Least squares line: Y = ';
Mx2 = [Mx1,num2str(A),' X'];
if B > 0,
  Mx2 = [Mx2,' + ',num2str(B)];
else
  Mx2 = [Mx2,' - ',num2str(abs(B))];
end;
title(Mx2);
grid;
hold off;
figure(gcf); pause % Press any key to continue.

points = [XT;YT];

clc; format short;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'The transformed points in the X-Y plane.';
Mx3 = '      X         Y';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(Mx2),...
disp(Mx3),disp(points'),diary off, echo on
pause	% Press any key to fit y = C exp(Ax).

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
A = p(1);
B = p(2);
C = exp(B);
h = (max(X)-min(X))/150;
Xs = min(X):h:max(X);
Ys = C*exp(A*Xs);

clc; figure(3); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -0.1;
b =  4.1;
c = -0.2;
d =  8.2;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'or',Xs,Ys,'-g');
xlabel('x');
ylabel('y');
Mx1 = 'The fit f(x) = ';
Mx2 = [Mx1,num2str(C),' exp(',num2str(A),' x)'];
title(Mx2);
grid;
hold off;
figure(gcf); pause % Press any key to continue.

% .. .. .. .. .. 
% Prepare results
% .. .. .. .. .. 
points = [X;Y;C*exp(A*X);Y-C.*exp(A*X)]';

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx3='    x(k)      y(k)      f(x(k))   error';
clc,echo off,diary output,disp(''),disp(Mx2),...
disp(Mx3),disp(points),diary off,echo on
