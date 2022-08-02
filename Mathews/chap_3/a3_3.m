echo on; clc;
%---------------------------------------------------------------------------
%A3_3   MATLAB script file for implementing Algorithm 3.3
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
% Algorithm 3.3 (PA = LU Factorization with Pivoting).
% Section	3.6, Triangular Factorizaton, Page 175
%---------------------------------------------------------------------------

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program solves linear systems AX = B.
%
% The method is LU factorization with pivoting.
%
% 1. Factor  PA = LU 
%
% 2. Get    LUX = PB
%
% 3. Solve   LY = PB  for  Y.
%
% 4. Solve   UX = Y   for  X.
%
% Remark. lufact.m and lusolv.m are used for Algorithm 3.3

pause % Press any key to continue.

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example  This involves the same equations
% as those in Exercise 8, page 158
% Solve the system AX = B  where:

A = [1    5    4   -3;
     4    8    4    0;
     1    3    0   -2
     1    4    7    2];

B = [-4;  8;  -4;  10];     % Enter B as a column vector.

[LU,row,det1] = lufact(A);

[X,Y] = lusolv(LU,B,row);

R = B - A*X;                % Verify that the residual is small.

pause % Press any key to continue.

clc;
[n n] = size(A);
I = eye(n);
for k = 1:n,
  P(k,:) = I(row(k),:);
end
L = I;
for c = 1:n-1,
    L(c+1:n,c) = A(row(c+1:n),c);
end
U = zeros(n,n);
for c = 1:n,
    U(1:c,c) = A(row(1:c),c);
end

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Implementation of the LU factorization method.';
Mx2 = 'The matrix is A =';
Mx3 = 'The vector B is displayed as B` =';
Mx4 = 'The solution to AX = B is displayed as X` =';
Mx5 = 'The permutation matrix is P =';
Mx6 = 'The lower-triangular matrix is L =';
Mx7 = 'The transformed vector PB is displayed as (PB)`';
Mx8 = 'The solution to LY = PB is displayed as Y` =';
Mx9 = 'The upper-triangular matrix is U =';
Mx10= 'The vector Y is displayed as Y` =';
Mx11= 'The solution to UX = Y  is displayed as X` =';
Mx12 = 'The residual R = B - A*X is displayed as R` = ';
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(A),disp(Mx3),disp(B'),...
disp(Mx4),disp(X'),diary off,...
disp('Press any key to continue.'),pause,diary on,...
clc,disp(Mx5),disp(P),disp(Mx6),disp(L),disp(Mx7),disp((P*B)'),...
disp(Mx8),disp(Y'),diary off,...
disp('Press any key to continue.'),pause,diary on,...
clc,disp(''),disp(Mx9),disp(U),disp(Mx10),disp(Y'),...
disp(Mx11),disp(X'),disp(Mx12),disp(R'),diary off, echo on
pause % Press any key to perform LU factorization with pivoting.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Solve the system AX = B  where:
%
% A is the matrix from the previous example.
%
% Notice that we do not need to re-enter matrix A.
%
% The LU factorization is used and not recomputed.

B = [-5;  4;  -3;  7];      % Enter B as a column vector.

[X,Y] = lusolv(LU,B,row);

R = B - A*X;                % Verify that the residual is small.

pause % Press any key to continue.

clc;
[n n] = size(A);
I = eye(n);
for k = 1:n,
  P(k,:) = I(row(k),:);
end
L = I;
for c = 1:n-1,
    L(c+1:n,c) = A(row(c+1:n),c);
end
U = zeros(n,n);
for c = 1:n,
    U(1:c,c) = A(row(1:c),c);
end

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(A),disp(Mx3),disp(B'),...
disp(Mx4),disp(X'),diary off,...
disp('Press any key to continue.'),pause,diary on,...
clc,disp(Mx5),disp(P),disp(Mx6),disp(L),disp(Mx7),disp((P*B)'),...
disp(Mx8),disp(Y'),diary off,...
disp('Press any key to continue.'),pause,diary on,...
clc,disp(''),disp(Mx9),disp(U),disp(Mx10),disp(Y'),...
disp(Mx11),disp(X'),disp(Mx12),disp(R'),diary off, echo on
pause % Press any key to perform LU factorization with pivoting.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 22, page 160
% Test this program with a Hilbert matrix.
%
% Experiment with n=4,5,... keep n small.

n = 4;
A = hilb(n);

B = ones(n,1);              % Enter B as a column vector.

[LU,row,det1] = lufact(A);

[X,Y] = lusolv(LU,B,row);

R = B - A*X;                % Investigate the residual.

pause % Press any key to continue.

clc;
[n n] = size(A);
I = eye(n);
for k = 1:n,
  P(k,:) = I(row(k),:);
end
L = I;
for c = 1:n-1,
    L(c+1:n,c) = A(row(c+1:n),c);
end
U = zeros(n,n);
for c = 1:n,
    U(1:c,c) = A(row(1:c),c);
end

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),disp(A),disp(Mx3),disp(B'),...
disp(Mx4),disp(X'),diary off,...
disp('Press any key to continue.'),pause,diary on,...
clc,disp(Mx5),disp(P),disp(Mx6),disp(L),disp(Mx7),disp((P*B)'),...
disp(Mx8),disp(Y'),diary off,...
disp('Press any key to continue.'),pause,diary on,...
clc,disp(''),disp(Mx9),disp(U),disp(Mx10),disp(Y'),...
disp(Mx11),disp(X'),disp(Mx12),disp(R'),diary off, echo on
