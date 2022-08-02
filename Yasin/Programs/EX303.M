% A program of type script
% Program name is ex303.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'ex303' in the command window.
clear all
clc
disp(' ')
disp('This program shows you some matrix operations')
disp('----------------------------------------------------------------------')
n=input('Type a number and press Enter    ');
disp(' ')
disp('Two matrices A & B will be shown, to see them press enter')
disp(' ')
pause
clc
A=fix(10*rand(n))
B=fix(10*rand(n))

disp('To find the square of matrix A, press Enter')
pause
clc
A
A^2

disp('To see the square root of matrix A, press Enter')
pause
clc
A
sqrtm(A)

disp('To find the characteristic polynomial of matrix A, press Enter')
pause
clc
A
poly(A)


disp('To find the eigenvalues and the eigen vectors of matrix A, press Enter')
pause
clc
A
[V,E]=eig(A)
disp(' ')

disp('For the first eigenalue and the first eigenvector, to check that A*V(:,1) and V(:,1)*E(1,1) are equal, press Enter')
pause
clc
A
V
disp(' ')
disp('The result of  A*V(:,1) is:')
A*V(:,1)
disp(' ')
disp('The result of  V(:,1)*E(1,1) is:')
V(:,1)*E(1,1)
disp(' ')

disp('To find the right matrix division of A & B , press Enter')
pause
clc
A
B
mrdivide(A,B)


disp('To find the left matrix division of A & B , press Enter')
pause
clc
A
B
mldivide(A,B)


disp('TO CLEAR SCREEN, PRESS ENTER')
pause
clc


