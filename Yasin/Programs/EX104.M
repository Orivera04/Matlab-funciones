
% A program of type script
% Program name is ex104.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'ex104' in the command window.

clear all
clc
disp(' ')
disp('This program shows you some vector and matrix operations')
disp('----------------------------------------------------------------------')
n=input('Type a number and press Enter    ');
disp(' ')
disp('A row vector V , a column vector  W,  and  a matrix A  will be shown, to see them press enter')
disp(' ')
pause
clc
V=fix(10*rand(1,n))
W=fix(10*rand(n,1))
A=fix(10*rand(n))
disp(' ')
disp('To see the product K=V*W , press Enter')
pause
clc
disp('The product K=V*W is:')
V
W
K=V*W
disp(' ')
disp('To see the product M=W*V , press Enter')
pause
clc
disp('The product M=W*V is:')
W
V
M=W*V
disp('To see the product L=V*A , press Enter')
pause
clc
disp('The product L=V*A is:')
V
A
L=V*A
disp('To see the product R=A*W , press Enter')
pause
clc
disp('The product R=A*W is:')
A
W
R=A*W

disp(' ')
disp('TO CLEAR SCREEN, PRESS ENTER')
pause
clc
