echo on; clc;
%---------------------------------------------------------------------------
%A3_2   MATLAB script file for implementing Algorithm 3.2
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
% Algorithm 3.2 (Upper-Triangularization Followed by Back Substitution).
% Section	3.4, Gaussian Elimination and Pivoting, Page 156
%---------------------------------------------------------------------------

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program solves linear systems AX = B.
%
% A is an n x n matrix, B is an n-dimensional vector.
%
% The augmented matrix [A,B] is formed with B in column n+1.
%
% Upper triangularization is followed by back substitution.
%
% Remark. uptrbk.m is used for Algorithm 3.2

pause % Press any key to continue.

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example  This involves the same equations
% as those in Exercise 8, page 158
%
% Solve the system AX = B where the augmented matrix [A,B] is:

A = [1   5   4  -3;
     4   8   4   0;
     1   3   0  -2;
     1   4   7   2];

B = [-4; 8; -4; 10];       % Enter B as a column vector.

X = uptrbk(A,B);

R = B - A*X;               % Verify that the residual is small.

pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Upper-triangularization followed by back substitution.';
Mx2 = 'The matrix is A =';
Mx3 = 'The vector B is displayed as B` =';
Mx4 = 'The solution to AX = B is displayed as X` =';
Mx5 = 'The residual R = B - A*X is displayed as R` = ';
clc,echo off, diary output,...
disp(''),disp(Mx1),disp(Mx2),disp(A),disp(Mx3),...
disp(B'),disp(Mx4),disp(X'),disp(Mx5),disp(R'),diary off, echo on
      % Press any key to perform Upper-triangularization 
pause %followed by back substitution.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example  This involves slight changes in
% the coefficients in Exercise 8, page 158
%
% Solve the system AX = B where the augmented matrix [A,B] is:

A = [1.001   5.001   4.001  -3.001;
     4.001   8.001   4.001   0.001;
     1.001   3.001   0.001  -2.001;
     1.001   4.001   7.001   2.001];

B = [-4.001; 8.001; -4.001; 10.001];

X = uptrbk(A,B);

R = B - A*X;               % Verify that the residual is small.

pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Upper-triangularization followed by back substitution.';
Mx2 = 'The matrix is A =';
Mx3 = 'The vector B is displayed as B` =';
Mx4 = 'The solution to AX = B is displayed as X` =';
Mx5 = 'The residual R = B - A*X is displayed as R` = ';
clc,echo off, diary output,...
disp(''),disp(Mx1),disp(Mx2),disp(A),disp(Mx3),...
disp(B'),disp(Mx4),disp(X'),disp(Mx5),disp(R'),diary off, echo on
