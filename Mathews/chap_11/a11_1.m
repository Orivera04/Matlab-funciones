%---------------------------------------------------------------------------
echo on; clc;
%A11_1   MATLAB script file for implementing Algorithm 11.1
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
% Algorithm 11.1 (Power Method).
% Section	11.2, The Power Method, Page 557
%---------------------------------------------------------------------------

clc; clear all; format long; delete output;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%        POWER METHOD FOR FINDING AN EIGEN-PAIR
%
% Assume that A is an n by n real matrix and that it
%
% has a full set of eigenvectors  V , V  ,..., V .
%                                  1   2        n
%
% The power method of iteration is used to find the
%
% dominant eigenvalue and its corresponding eigenvector.
%
% Remark. power.m is used for Algorithm 11.1

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 11.5, page 550.  Finding an eigenvalue of the matrix A.
%
% Iteration of the power method will continue until each coordinate
% of the eigenvector has converged with an error less than epsilon
% or the maximum number of iterations is reached.
%
% Enter the matrix in   A
% Enter the starting vector in  X
% Enter the tolerance in   epsilon
% Enter the maximum number of iterations in  max1

A = [ 0    11    -5;
     -2    17    -7;
     -4    26   -10];

[n,n] = size(A);
X = ones(n,1);
epsilon = 1e-14;
max1 = 100;

[lambda,V] = power(A,X,epsilon,max1,1)

pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Implementation of the power method.';
Mx2 = 'The matrix  A  is: ';
Mx3 = 'The dominant eigenvalue of  A  is: ';
Mx4 = 'The dominant eigenvector of  A  is: ';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(A),...
disp(Mx3),disp(lambda),disp(Mx4),disp(V),...
diary off,echo on
