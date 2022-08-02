echo on; clc;
%---------------------------------------------------------------------------
%A3_5   MATLAB script file for implementing Algorithm 3.5
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
% Algorithm 3.5 (Gauss-Seidel Iteration).
% Section	3.7, Iterative Methods for Linear Systems, Page 187
%---------------------------------------------------------------------------

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program solves a linear system AX = B.
%
% Where A is diagonally dominant.
%
% A is an n x n matrix, B is an n-dimensional vector.
%
% The method is Gauss-Seidel iteration.
%
% Remark. gseid.m is used for Algorithm 3.5

pause % Press any key to perform Gauss-Seidel iteration.

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 3.27, page 183
%
% Use Gauss-Seidel iteration to solve the linear system A*X = B:

A = [ 4   -1    1;
      4   -8    1;
     -2    1    5];

B = [ 7; -21;  15];         % Enter B as a column vector.

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 3.27, page 183
% Use Gauss-Seidel iteration to solve the linear system.
%
% Enter the starting vector in  P
% Enter the tolerance in  delta
% Enter the number of iterations in  max1

P = [ 1;   2;   2];         % Enter P as a column vector.
delta = 1e-12;
max1 = 50;

[X,dX,Pm] = gseid(A,B,P,delta,max1);

pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Computations for Gauss-Seidel iteration.';
Mx2 = '     x                  y                  z';
Mx3 = 'The matrix is A =';
Mx4 = 'The vector B is displayed as B` =';
Mx5 = 'The solution X is displayed as X`  = ';
Mx6 = 'The accuracy is  +- dX,  where dX` = ';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(Mx2),disp(Pm),...
diary off,echo on
pause % Press any key to continue.
clc,echo off,diary output,...
disp(Mx3),disp(A),disp(Mx4),disp(B'),...
disp(Mx5),disp(X'),disp(Mx6),disp(dX'),...
disp('Iteration is converging linearly to the solution.'),...
diary off,echo on
pause % Press any key to perform Gauss-Seidel iteration.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 3.27*, page 180
%
% Use Gauss-Seidel iteration on the linear system A*X = B:

A = [-2    1    5;
      4   -8    1;
      4   -1    1];

B = [15; -21;   7];         % Enter B as a column vector.

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 3.27*, page 180
% Use Gauss-Seidel iteration on the linear system A*X = B.
%
% Enter the starting vector in  P
% Enter the tolerance in  delta
% Enter the number of iterations in  max1

P = [ 1;   2;   2];         % Enter P as a column vector.
delta = 1e-12;
max1 = 4;

[X,dX,Pm] = gseid(A,B,P,delta,max1);

pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(Mx2),disp(Pm),...
diary off,echo on
pause % Press any key to continue.
clc,echo off,diary output,...
disp(Mx3),disp(A),disp(Mx4),disp(B'),...
disp(Mx5),disp(X'),disp(Mx6),disp(dX'),...
disp('Iteration is diverging to infinity.'),...
disp('Notice the "scale factor" for the output.'),...
diary off,echo on
