echo on; clc;
%---------------------------------------------------------------------------
%A3_1   MATLAB script file for implementing Algorithm 3.1
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
% Algorithm 3.1 (Back Substitution).
% Section	3.3, Upper-Triangular Linear Systems, Page 145
%---------------------------------------------------------------------------

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program solves upper-triangular linear systems AX = B.
%
% A  is an n x n matrix,  B  is an n-dimensional vector.
%
% Remark. backsub.m is used for Algorithm 3.1

pause % Press any key to continue.

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

%
% Exercise 1, page 164
% Solve the system   AX = B   where

A = [3   -2    1   -1;
     0    4   -1    2;
     0    0    2    3;
     0    0    0    5];

B = [8;  -3;  11;  15];     % Enter B as a column vector.

X = backsub(A,B);

R = B - A*X;                % Verify that the residual is small.

pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Implementation of back substitution.';
Mx2 = 'The matrix is A =';
Mx3 = 'The vector B is displayed as B` =';
Mx4 = 'The solution to AX = B is displayed as X` =';
Mx5 = 'The residual R = B - A*X is displayed as R` = ';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(Mx2),disp(A),...
disp(Mx3),disp(B'),disp(Mx4),disp(X'),...
disp(Mx5),disp(R'),diary off, echo on
pause % Press any key to perform back substitution.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example  This involves slight changes to
% the coefficients in Exercise 1, page 164
%
% Solve the system   AX = B   where

A = [3.01   -2.01    1.01   -1.01;
     0       4.01   -1.01    2.01;
     0       0       2.01    3.01;
     0       0       0       5.01];

B = [8.01;  -3.01;  11.01;  15.01]; % Enter B as a column vector.

X = backsub(A,B);

R = B - A*X;           % Verify that the residual is small.

pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(Mx2),disp(A),...
disp(Mx3),disp(B'),disp(Mx4),disp(X'),...
disp(Mx5),disp(R'),diary off, echo on
pause % Press any key to perform back substitution.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example  This involves slight changes to
% the coefficients in Exercise 1, page 164
%
% Solve the system   AX = B   where

A = [3.005  -2.005   1.005  -1.005;
     0       4.005  -1.005   2.005;
     0       0       2.005   3.005;
     0       0       0       5.005];

B = [8.005; -3.005; 11.005; 15.005]; % Enter B as a column vector.

X = backsub(A,B);

R = B - A*X;           % Verify that the residual is small.

pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(Mx2),disp(A),...
disp(Mx3),disp(B'),disp(Mx4),disp(X'),...
disp(Mx5),disp(R'),diary off, echo on
