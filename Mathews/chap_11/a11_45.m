echo on; clc;
%---------------------------------------------------------------------------
%A11_45   MATLAB script file for implementing Algorithm 11.4
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
% Algorithm 11.5 (The QL Method with Shifts).
% Section	11.4, Eigenvalues of Symmetric Matrices, Page 581
%---------------------------------------------------------------------------

clc; clear all; format long; delete output;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%   HOUSEHOLDER`S  METHOD  followed by the  QL METHOD
%
%   Assume that A is an n by n real symmetric matrix.
%
% First, A is similar to a tridiagonal matrix C
%
%      C = P*A*P 
%
% Second, C is similar to a diagonal matrix D
%
%      D = Q*C*Q 
%
% Remark. house.m and ql.m are used for Algorithm 11.45

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 11.8, page 580.  Use Householder`s method of iteration
% to find the tridiagonal matrix  B = A    that is similar to  A.
%                                      n-2

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
Ms1 = 'The matrix  A  is:';
Ms2 = 'The similar tridiagonal matrix B is:';
clc,echo off,diary output,disp(' '),disp(Ms1),disp(A),...
disp(Ms2),disp(B),diary off,echo on
pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 11.9, page 584.  Use the QL method of iteration
% to reduce the tridiagonal matrix  B  to diagonal form.
%

epsilon = 1e-10;

D = ql(B,epsilon,1);

pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Householder reduction to tridiagonal form,';
Mx2 = 'followed by the QL method with shifts).';
Mx3 = 'The matrix  B  is:';
Mx4 = 'The similar diagonal matrix is:'
Mx5 = 'The eigenvalues are:';
clc,echo off,diary output,...
disp(' '),disp(Mx1),disp(Mx2),...
disp(' '),disp(Mx3),disp(B),disp(Mx4),...
disp(diag(D)),disp(Mx5),disp(D),diary off,echo on
