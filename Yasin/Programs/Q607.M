
% A program of type script
% Program name is Q607.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'Q607' in the command window.

clear all
clc
disp(' ');
disp('This program answers question 7 of chapter 6')
disp(' ')
disp('----------------------------------------------------------------------')
disp(' ')
disp('To see A and B matrices that are describing the system, press Enter')
pause
disp(' ')
A=[1 1 1;7 2 -5;6 1 -6]
B=[1 5 0]'

disp('To see the augmentd matrix, press Enter')
pause
[A B]
disp(' ')
disp('To see the reduced row echelon form of the system, press Enter')
pause
rref([A B])
disp(' ')

disp('This indicates that the system has no exact solution.')
disp(' ')
disp(' To see the least squares solution, press Enter')
pause
X=pinv(A)*B
disp('TO CLEAR SCREEN, PRESS ENTER')
pause
clc
