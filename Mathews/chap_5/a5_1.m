echo on; clc;
%---------------------------------------------------------------------------
%A5_1   MATLAB script file for implementing Algorithm 5.1
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
% Algorithm 5.1 (Least Squares Line).
% Section	5.1, Least-Squares Line, Page 264
%---------------------------------------------------------------------------

clc; clear all; format short;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program finds the least squares line, given a set of
%
% data points { (x , y ), (x , y ) ,..., (x , y ) }.
%                 1   1     2   2          n   n
%
% The abscissas and ordinates are stored in X and Y, respectively.
%
% X = [x , x  ,..., x ];  Y = [y , y  ,..., y ];
%       1   2        n          1   2        n
%
% Remark. lsline.m is used for Algorithm 5.1

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 5.2, page 261.  Find the least squares line.
%
% Enter the abscissas for the points in  X.
%
% Enter the ordinates for the points in  Y.

X = [-1  0  1  2  3  4  5  6];
Y = [10  9  7  5  4  3  0 -1];

[A B] = lsline(X,Y);

pause % Press any key to graph data points.

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = min(X)-0.20; 
b = max(X)+0.20;
c = min(Y)-0.35; 
d = max(Y)+0.35;
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

% .. .. .. .. .. 
% Prepare results
% .. .. .. .. .. 
points = [X;Y]; format short;

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
clc,disp(''),disp('The given x-y data points.'),...
disp('     x     y'),disp(points'),...

pause % Press any key to continue.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = -1;
b =  7;
Xs = [a b];
Ys = A*Xs + B;

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -1;
b =  7;
c = -2;
d = 12;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(X,Y,'or',Xs,Ys,'-g');
xlabel('x');
ylabel('y');
Mx1 = 'Least squares line: f(x) = ';
Mx2 = [Mx1,num2str(A),' x'];
if B > 0,
  Mx3 = [Mx2,' + ',num2str(B)];
else
  Mx3 = [Mx2,' - ',num2str(abs(B))];
end;
title(Mx3);
grid;
hold off;
figure(gcf); pause % Press any key to continue.


% .. .. .. .. .. 
% Prepare results
% .. .. .. .. .. 
points = [X;Y;A*X+B;Y-(A*X+B)]';

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx4 = 'The given x-y data points.';
clc,echo off,diary output,...
disp(''),disp(Mx3),disp(Mx4),...
disp('     x     y'),disp([X;Y]'),diary off, echo on
pause	% Press any key to continue.
Mx5='    x(k)      y(k)      f(x(k))   error';
clc,echo off,diary output,disp(''),disp(Mx3),...
disp(''),disp(Mx5),disp(points),diary off,echo on
