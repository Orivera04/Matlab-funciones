echo on; clc;
%---------------------------------------------------------------------------
%A11_5   MATLAB script file for implementing Algorithm 11.5
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
% Algorithm 11.5 (The QL Method with Shifts).
% Section	11.4, Eigenvalues of Symmetric Matrices, Page 587
%---------------------------------------------------------------------------

clc; clear all; format long; delete output;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%            THE QL ALGORITHM
%
%     Assume that A  = A is real, symmetric and tridiagonal.
%                  1
% The QL method constructs orthogonal matrices {Q } so that
%                                                k
%     A  = Q L  where L  is lower-triangular, and
%      k    k k        k
%
%     A     =  Q  A  Q    for k = 1,2, ... .
%      k+1      k  k  k
%
% Then    lim  A  = D,   where D is a diagonal matrix 
%        k->oo  k
%
% with the same eigenvalues as the original matrix A.
%
% Remark. ql.m is used for Algorithm 11.5

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 11.9, page 584.  Use the QL method of iteration
% to reduce the tridiagonal matrix  A  to diagonal form.
% A  must be symmetric and tridiagonal.
%
% Enter the matrix in  A.
% Enter the tolerance in  epsilon

A = [ 4  -3                  0                  0;
     -3   2                  3.16227766016838   0;
      0   3.16227766016838  -1.4               -0.2;
      0   0                 -0.2                1.4];
	  
epsilon = 1e-10;

D = ql(A,epsilon,1);

pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Implementation of the QL method with shifts.';
Mx2 = 'The matrix  A  is:';
Mx3 = 'The similar diagonal matrix is:'
Mx4 = 'The eigenvalues are:';
clc,echo off,diary output,...
disp(' '),disp(Mx1),disp(' '),disp(Mx2),disp(A),disp(Mx3),...
disp(diag(D)),disp(Mx4),disp(D),...
diary off,echo on
