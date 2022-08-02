
% A program of type script
% Program name is ex105.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'ex105' in the command window.

clear all
clc
disp(' ');
disp('This program shows you the matrix transpose and inverse operations')
disp('----------------------------------------------------------------------')
n=input('Type a number and press Enter    ');
disp(' ')
disp('A matrix A  will be shown, to see it press enter')
disp(' ')
pause
clc
A=fix(10*rand(n))
disp(' ')
disp('To see its transpose B, press Enter')
pause
clc
A
disp('The Transpose matrix B is:')
B=A'
disp(' ')
disp('To see its Inverse C, press Enter')
 pause
 clc
A
format rat
disp(' The inverse C is:')
C=inv(A)
disp(' ')
disp('To see the product of the matrix and its inverse, press Enter')
pause
clc
disp('The matrix')
A
disp('Its Inverse')
C
disp('Their product')
A*C
 disp(' ')
 disp('TO CLEAR SCREEN, PRESS ENTER')
 pause
format short
 clc
