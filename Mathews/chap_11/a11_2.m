%---------------------------------------------------------------------------
echo on; clc;
%A11_2   MATLAB script file for implementing Algorithm 11.2
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
% Algorithm 11.2 (Shifted Inverse Power Method).
% Section	11.2, The Power Method, Page 558
%---------------------------------------------------------------------------

clc; clear all; format long; delete output;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%         INVERSE POWER METHOD FOR FINDING AN EIGEN-PAIR
%
%     Assume that A is an n by n real matrix and that it
%
% has a full set of eigenvectors  V , V  ,..., V .
%                                  1   2        n
%
% The shifted inverse power method of iteration is used to find an
%
% eigenvalue and its corresponding eigenvector. Iteration will continue
%
% until each coordinate of the eigenvector has converged with an
%
% error less than epsilon or the iteration limit is reached.
%
% Remark. invpow.m lufact.m lusolv.m are used for Algorithm 11.2

pause % Press any key to continue.      

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 11.6, page 555.  Finding an eigenvalue of the matrix A.
%
% Enter the matrix in  A
% Enter the shift  in  alpha
% Enter the starting vector in  X
% Enter the tolerance in   epsilon
% Enter the maximum number of iterations in  max1

A = [ 0    11    -5;
     -2    17    -7;
     -4    26   -10];

[n,n] = size(A);
X = ones(n,1);
alpha = 4.2;
epsilon = 1e-14;
max1 = 50;

[lambda,V] = invpow(A,alpha,X,epsilon,max1,1);

pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Implementation of the shifted inverse power method.';
Mx2 = 'The matrix  A  is: '
Mx3 = 'The initial shift was  alpha = ';
Mx4 = [Mx3,num2str(alpha)];
Mx5 = 'The desired eigenvalue of  A  is: ';
Mx6 = 'The desired eigenvector of  A  is: ';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(A),...
disp(''),disp(Mx4),disp(''),...
disp(Mx5),disp(lambda),disp(Mx6),disp(V),...
diary off,echo on
