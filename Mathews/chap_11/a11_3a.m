echo on; clc;
%---------------------------------------------------------------------------
%A11_3A   MATLAB script file for implementing Algorithm 11.3
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
% Algorithm 11.3 (Jacobi Iteration for Eigenvalues and Eigenvectors).
% Section	11.3, Jacobi's Method, Page 571
%---------------------------------------------------------------------------

clc; clear all; format long; delete output;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%        JACOBI METHOD FOR FINDING EIGEN-PAIRS
%
% Assume that A is an n by n symmetric real matrix, thus
%
% it has a full set of eigenvectors  V , V  ,..., V .
%                                     1   2        n
%
% The original Jacobi`s method of iteration is used
%
%  to find all of the eigen-pairs.
%
% Remark. jacobi1.m is used for Algorithm 11.3a

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%             JACOBI`S  METHOD FOR EIGENVECTORS
%      Assume that A is an n by n real symmetric matrix.
% Then A has a full set of eigenvectors: V , V ,..., V
%                                         1   2       n
% Jacobi`s method of iteration is used to find all the
% eigenvalues and eigenvectors of  A.   Let  A = A , 
%                                                 1
% and construct a sequence of orthogonal matrices
%                     T
% {R }  where  D  =  R  A  R    and  { D  } converges
%   j           j     j  j  j           j
%
%  to the diagonal matrix D, of eigenvalues, and
%
% {V  = R R ...R } converges to the matrix of eigenvectors.
%   j    1 2    j

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%     We use Jacobi`s original strategy for selecting the off
% diagonal element to annihilate in the construction process.
%
% Select p,q so that   |a  |  =  max |a  |.
%                        pq      i<j   ij  
%
%      For each sweep throughout the matrix, the computed
% value t is the [R.M.S.] average of the diagonal elements
% of A.  The user must supply the error tolerance for
% annihilating the off diagonal elements
%
%        |d   |  >  t*epsilon       for all  q > p.
%          p,q

pause % Press any key to continue.

clc;
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 11.7, page 569.  Finding all eigenvalues of the matrix A.
%
% Enter the matrix in  A
%
% Enter the tolerance in   epsilon

A = [ 8   -1    3   -1;
     -1    6    2    0;
      3    2    9    1;
     -1    0    1    7];

epsilon = 1e-16;

[V,D] = jacobi1(A,epsilon,1);

pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Implementation of the original Jacobi method.';
Mx2 = 'The matrix  A  is:';
Mx3 = 'The eigenvalues of  A  are:';
Mx4 = 'The eigenvectors of  A  are:';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(A),
disp(Mx3),disp(diag(D)),disp(Mx4),disp(V),...
diary off,echo on
