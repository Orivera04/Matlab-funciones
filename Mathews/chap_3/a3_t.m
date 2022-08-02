echo on; clc;
%---------------------------------------------------------------------------
%A3_t   MATLAB script file for implementing Algorithm 3.t
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
% Algorithm 3.t (Tri-Diagonal System).
% Section	3.4, Gaussian Elimination and Pivoting, Page 148
% See exercise 15 on page 159.
%---------------------------------------------------------------------------

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%     This program solves a tri-diagonal linear system AX = B.
%
% The diagonal is an n dimensional vector  D
%
% The sub diagonal is an n-1 dimensional vector  A
%
% The super diagonal is an n-1 dimensional vector  C
%
% The right side is an n dimensional vector  B
%
% Remark. trisys.m is used for Algorithm 3.t

pause % Press any key to continue.

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example  This is a short version of Exercise 12, page 189
%
% For this example the matrix A is 12 by 12.
%
% Solve the tri-diagonal system AX = B  where:

n = 12;
D = 4*ones(1,n);
A = 1*ones(1,n-1);
C = 1*ones(1,n-1);

B = 3*ones(n,1);

X = trisys(A,D,C,B);

pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Solution of a tri-diagonal system.';
Mx2 = 'The matrix is A is displayed as [C;D;A]';
Mx3 = 'The vector B is displayed as B` =';
Mx4 = 'The solution to AX = B is displayed as X` =';
clc,echo off,diary output,
disp(''),disp(Mx1),disp(Mx2),...
for i=1:12:n-1, disp(C([i:min(i+11,n-1)])); end,...
for i=1:12:n, disp(D([i:min(i+11,n)])); end,...
for i=1:12:n-1, disp(A([i:min(i+11,n-1)])); end,...
disp(Mx3),for i=1:12:n, disp(B([i:min(i+11,n)])'); end,...
disp(Mx4),disp(X'),diary off, echo on
