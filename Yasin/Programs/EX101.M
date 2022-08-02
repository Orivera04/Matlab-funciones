
% A program of type script
% Program name is ex101.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'ex101' in the command window.

clear all
clc
disp(' ')
disp('Hello, This program shows you random matrices of different types')
disp('----------------------------------------------------------------------')
n=input('Type a number and press Enter    ');
disp(' ')
disp('To see a row vector, press Enter')
pause
clc
A=fix(10*rand(1,n))
disp('THIS A ROW VECTOR')
disp('    ')
disp('To see a column vector, press Enter')
pause
clc
B=fix(10*rand(n,1))
disp('THIS IS A COLUMN VECTOR')
disp(' ')
disp('To see a square matrix, press Enter')
pause
clc
C=fix(10*rand(n))
disp('THIS IS A SQUARE MATRIX')
disp(' ')
disp('To see a diagonal matrix, press Enter')
pause
clc
D=diag(fix(10*rand(n,1)),0)
disp('THIS IS A DIAGONAL MATRIX')
disp(' ')
disp('To see an upper-triangular matrix, press Enter')
pause
clc
[l,u]=lu(fix(10*rand(n)));
u
disp('THIS IS AN UPPER-TRIANGULAR MATRIX')
disp(' ')
disp('To see a Symmetric matrix, press Enter')
pause
clc
E=pascal(n)
disp('THIS IS A SYMMETRIC MATRIX')
disp(' ')
disp('TO CLEAR SCREEN, PRESS ENTER')
pause
clc









