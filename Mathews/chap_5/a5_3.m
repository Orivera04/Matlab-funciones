echo on; clc;
%---------------------------------------------------------------------------
%A5_3   MATLAB script file for implementing Algorithm 5.3
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
% Section	5.2, Curve Fitting, Page 280
%---------------------------------------------------------------------------

clc; clear all; format short;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program performs curve fitting, by using
%
% the method of data linearization. Given a set of
%
% data points { (x , y ), (x , y ) ,..., (x , y ) }.
%                 1   1     2   2          n   n
%
% The abscissas and ordinates are stored in X and Y, respectively.
%
% X = [x , x  ,..., x ];  Y = [y , y  ,..., y ];
%       1   2        n          1   2        n
%
% Remark. crvfit.m crvfun.m crvnam.m are used for Algorithm 5.3

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example, page 280  Find the least squares curve(s).
%
% Enter the abscissas for the points in  X.
%
% Enter the ordinates for the points in  Y.

X = [0.0001  1.0  2.0  3.0  4.0];
Y = [1.5000  2.5  3.5  5.0  7.5];

pause	% Press any key to graph data points.

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = min(X)-0.2; 
b = max(X)+0.2;
c = min(Y)-1.0; 
d = max(Y)+1.0;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'or');
xlabel('x');
ylabel('y');
title('The given x-y data points.');
grid;
hold off;
figure(gcf); pause % Press any key to continue.


points = [X;Y];

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
clc,disp('The given x-y points:'),...
disp('      x         y'),disp(points')
pause % Press any key for the menu of curves.

clc;
Mx1='    Available curves are:';
Mx2='(1) y = A/x + B         (2) y = D/(x + C)         (3) y = 1/(Ax + B)';
Mx3='(4) y = x/(A + Bx)      (5) y = A ln(X) + B       (6) y = C exp(Ax)';
Mx4='(7) y = C x^A           (8) y = 1/(Ax + B)^2';
Mx5='(9) y = C x exp(-Dx)   (10) y = L/(1 + C exp(Ax))';
clc,disp(''),disp(Mx1),disp(''),disp(Mx2),disp(''),...
disp(Mx3),disp(''),disp(Mx4),disp(''),disp(Mx5),...
ct = input('   Enter the curve type <1-10> ');

pause % Press any key to fit the curve.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
if length(ct)==0, ct=2; end
Clist = crvfit(X,Y,ct);
h = (b-a)/200;
Xs = a:h:b;
Ys = crvfun(Clist,ct,Xs);

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'or',Xs,Ys,'-g');
xlabel('x');
ylabel('y');
title(crvnam(Clist,ct)); end;
grid;
hold off;
figure(gcf); pause % Press any key to continue.

% .. .. .. .. .. 
% Prepare results
% .. .. .. .. .. 
points = [X;Y;crvfun(Clist,ct,X);Y-Crvfun(Clist,ct,X)]';

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = crvnam(Clist,ct);
Mx2 = 'The given x-y points:';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),...
disp('      x         y'),disp(points'),diary off,echo on
pause	% Press any key to continue.
Mx3='    x(k)      y(k)      f(x(k))   error';
clc,echo off,diary output,disp(''),...
disp(['    ',Mx1]),disp(Mx3),disp(points),diary off, echo on
