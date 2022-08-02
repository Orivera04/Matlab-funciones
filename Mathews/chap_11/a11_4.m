echo on; clc;
%---------------------------------------------------------------------------
%A11_4   MATLAB script file for implementing Algorithm 11.4
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
% Algorithm 11.4 (Reduction to Tridiagonal Form).
% Section	11.4, Eigenvalues of Symmetric Matrices, Page 581
%---------------------------------------------------------------------------

clc; clear all; format long; delete output;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%          HOUSEHOLDER`S  METHOD
%
%   Assume that A is an n by n real symmetric matrix.
% Then A is similar to a tridiagonal matrix.
% Starting with  A  = A, Householder`s method will
%                 0
% construct a sequence of orthogonal symmetric matrices
%
% {P } such that A  = P  A    P  ,
%   k             k    k  k-1  k
%
%            for  k = 1,2,...,n-2.
%
% Then  B = A    is the desired tridiagonal matrix.
%            n-2
%
% Remark. house.m is used for Algorithm 11.4

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 11.8, page 580.  Use Householder`s method of iteration
% to find the tridiagonal matrix  B = A    that is similar to  A.
%                                      n-2
%
% Enter the symmetric n by n matrix in  A.

A = [4    2    2    1;
     2   -3    1    1;
     2    1    3    1;
     1    1    1    2];

B = house(A,1);

pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Implementation of Householder`s reduction to tridiagonal form.';
Mx2 = 'The matrix  A  is:';
Mx3 = 'The similar tridiagonal matrix is:';
clc,echo off,diary output,...
disp(' '),disp(Mx1),disp(' '),disp(Mx2),...
disp(A),disp(Mx3),disp(B),...
diary off,echo on
