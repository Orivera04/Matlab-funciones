echo on; clc;
%---------------------------------------------------------------------------
%A3_i   MATLAB script file for implementing Algorithm 3.i
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
% Algorithm 3.i (Inverse of a matrix).
% Section	3.5, Matrix Inversion, Page 161
% Section	3.6, Triangular Factorizaton, Page 175
% Uses the result of LU factorization in Section 3.6
%---------------------------------------------------------------------------

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program finds the inverse of a matrix.
%
% The method involves the formation of  PA = LU
%
% Then a loop is used to solve n equations of the form
%
%      AXj = Ej  for j=1,2,...,n
%
% The vectors Xj will be the columns of the inverse matrix.
%
% Remark. lufact.m and lusolv.m are used for Algorithm 3.i

pause % Press any key to continue.

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - -
%
% Example  This is Exercise 6, page 164
%
% Find the inverse of the matrix  A  where:

A = [ 3   -9    27   -81;
     -4   16   -64   256;
      5  -25   125  -625;
     -6   36  -216  1296];

[LU,row] = lufact(A);
[n,n] = size(A);
E = eye(n,n);
for k=1:n,
  C(:,k) = lusolv(LU,E(:,k),row);
end

pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'The LU factorization method is used to invert a matrix.';
Mx2 = 'The matrix is A =';
Mx3 = 'The inverse matrix is C =';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(A),...
disp(''),disp(Mx3),disp(C),...
diary off, echo on
