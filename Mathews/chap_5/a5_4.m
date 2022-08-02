echo on; clc;
%---------------------------------------------------------------------------
%A5_4   MATLAB script file for implementing Algorithm 5.4
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
% Algorithm 5.4 (Cubic Splines).
% Section	5.3, Interpolation by Spline Functions, Page 297
%---------------------------------------------------------------------------

clc; clear all; format short;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
%
% This program finds the cubic spline interpolant.
%
% Given a set of data points
%
%      { (x , y ), (x , y ) ,..., (x , y ) }.
%          1   1     2   2          n   n
%
% The abscissas and ordinates are stored in X and Y, respectively.
%
% X = [x , x  ,..., x ];  Y = [y , y  ,..., y ];
%       1   2        n          1   2        n
%
% Remark. csfit.m  and cs.m  are used for Algorithm 5.4

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 5.7-5.11, pages 292-295  Find the cubic spline(s).
%
% Enter the abscissas for the points in  X.
%
% Enter the ordinates for the points in  Y.

X = [0   1    2    3 ];
Y = [0  0.5  2.0  1.5];

pause % Press any key to graph data points.

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = min(X)-0.2; 
b = max(X)+0.2;
c = min(Y)-0.2; 
d = max(Y)+0.2;
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
clc,disp('The given x-y points:'),...
disp('      x         y'),disp(points')

pause % Press any key for the menu of spline curves.

clc; 
Mx1='     Available curves are:';
Mx2='(1)  Clamped Spline';
Mx3='(2)  Natural Spline';
Mx4='(3)  Extrapolated Spline (Cubic runout spline)';
Mx5='(4)  Parabolically Terminated Spline';
Mx6='(5)  Endpoint Curvature Adjusted Spline';
clc,disp(''),disp(Mx1),disp(''),disp(Mx2),disp(''),disp(Mx3),,...
disp(''),disp(Mx4),disp(''),disp(Mx5),disp(''),disp(Mx6),...
ct = input('Enter the spline type <1-5> ');...
if length(ct)==0, ct=2; end;...
disp('');...
S = csfit(X,Y,ct);

pause % Press any key to fit the spline curve.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
hs = (max(X)-min(X))/200;
Xs = min(X):hs:max(X);
Ys = cs(S,X,Xs);

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
title('The cubic spline: y = S(x)');
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 ='The given x-y points:';
Mx2 = '      x         y';
if ct==1,Mx='clamped spline';end
if ct==2,Mx='natural spline';end
if ct==3,Mx='extrapolated spline (cubic runout spline)';end
if ct==4,Mx='parabolically terminated spline';end
if ct==5,Mx='endpoint curvature adjusted spline';end
Mx3 = ['The ',Mx,' was determined.'];
Mx4 = 'The spline coefficients are:'; 
clc,echo off,diary output,...
disp(Mx1),disp(Mx2),disp([X;Y]'),...
disp(Mx3),disp(Mx4),disp(''),...
[n1 n2] = size(S);...
for k = 1:n1,
  Mx5 = ['S',num2str(k),'(x):'];
  disp(Mx5);disp(S(k,4:-1:1));
end,diary off,echo on

pause % Press any key to continue.

% .. .. .. .. .. 
% Prepare results
% .. .. .. .. .. 
points = [X;Y;CS(S,X,X);Y-CS(S,X,X)]';

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx5 = '    x(k)      y(k)      S(x(k))   error';
clc,echo off,diary output,...
disp(''),disp(Mx5),disp(points),diary off,echo on
