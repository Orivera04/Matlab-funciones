echo on; clc;
%---------------------------------------------------------------------------
%A3_g   MATLAB script file for implementing Algorithm 3.g
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
% Algorithm 3.g (Gauss-Jordan method).
% Section	3.4, Gaussian Elimination and Pivoting, Page 148
% See exercise 17 on page 159.
%---------------------------------------------------------------------------

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%     This program solves linear systems AX = B.
%
% The method is essentially Gauss-Jordan elimination. It is short
%
% and illustrates the row operations of Matlab, but it employs the
%
% trivial pivoting strategy.  Methods using a pivoting strategy
%
% should be used for obtaining the best results.
%
% Remark. gaussj.m is used for Algorithm 3.g

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% It is instructive to consider the code for this algorithm.
% It is short and indicates the mathematics behind the solution.
%
%   [n n] = size(A);
%   A = [A';B']';
%   X = zeros(n,1);
%   for p = 1:n,
%     for k = [1:p-1,p+1:n],
%       if A(p,p)==0, break, end
%       mult = A(k,p)/A(p,p);
%       A(k,:) = A(k,:) - mult*A(p,:);
%     end
%   end
%   X = A(:,n+1)./diag(A);

pause % Press any key to continue.

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - -
%
% Example  This involves the same equations
% as those in Exercise 8, page 158
%
% Solve the system AX = B  where:

A = [1   5   4  -3;
     4   8   4   0;
     1   3   0  -2;
     1   4   7   2];

B = [-4; 8; -4; 10];

X = gaussj(A,B);

R = B - A*X;           % Verify that the residual is small.

pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Implementation of Gauss-Jordan elimination.';
Mx2 = 'The matrix is A =';
Mx3 = 'The vector B is displayed as B` =';
Mx4 = 'The solution to AX = B is displayed as X` =';
Mx5 = 'The residual R = B - A*X is displayed as R` = ';
clc,echo off,diary output,
disp(''),disp(Mx1),disp(Mx2),disp(A),...
disp(Mx3),disp(B'),disp(Mx4),disp(X'),...
disp(Mx5),disp(R'),diary off, echo on
pause % Press any key to perform Gauss-Jordan elimination.

clc;

% - - - - - - - - - - - - - - - - - - - - -
%
% Example  This involves slight changes in
% the coefficients in Exercise 8, page 158
%
% Solve the system AX = B  where:

A = [1.01   5.01   4.01  -3.01;
     4.01   8.01   4.01   0.01;
     1.01   3.01   0.01  -2.01;
     1.01   4.01   7.01   2.01];

B = [-4.01; 8.01; -4.01; 10.01];

X = gaussj(A,B);

R = B - A*X;           % Verify that the residual is small.

pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Implementation of Gauss-Jordan elimination.';
Mx2 = 'The matrix is A =';
Mx3 = 'The vector B is displayed as B` =';
Mx4 = 'The solution to AX = B is displayed as X` =';
Mx5 = 'The residual is R = B - A*X is displayed as R` = ';
clc,echo off,diary output,
disp(''),disp(Mx1),disp(Mx2),disp(A),...
disp(Mx3),disp(B'),disp(Mx4),disp(X'),...
disp(Mx5),disp(R'),diary off, echo on
