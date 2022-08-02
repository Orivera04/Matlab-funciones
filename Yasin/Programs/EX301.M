% A program of type script
% Program name is ex301.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'ex301' in the command window.
clear all
clc
disp(' ')
disp('This program shows you some column-oriented  operations')
disp('----------------------------------------------------------------------')
n=input('Type a number and press Enter    ');
disp(' ')
disp('A matrix A  will be shown, to see it press enter')
disp(' ')
pause
clc
A=fix(10*rand(n))
disp('To see the sum of the columns of A , press Enter')
pause
clc
A
sum(A)
disp('    ')
disp(' ')
disp('To see the cumulative sum of the columns of A, press Enter')
pause
clc
A
cumsum(A)
disp('To see the product of the columns of A, press Enter')
pause
clc
A
prod(A)
disp('To see the cumulative product of the columns of A, press Enter')
pause
clc
A
cumprod(A)
disp('To see the maximum of the columns of A, press Enter')
pause
clc
A
max(A)
disp('To see the mean value for the columns of A, press Enter')
pause
clc
A
mean(A)

 
 disp('TO CLEAR SCREEN, PRESS ENTER')
pause
clc


