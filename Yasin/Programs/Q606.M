
% A program of type script
% Program name is Q606.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'Q606' in the command window.

clear all
clc
disp(' ');
disp('This program answers question 6 of chapter 6')
disp(' ')
disp('----------------------------------------------------------------------')
disp(' ')
disp('To see A and B matrices that are describing the system, press Enter')
pause
disp(' ')
A=[5 4 -2;4 5 -1;6 3 -3]
B=[38 40 36]'

disp('To see the augmentd matrix, press Enter')
pause
[A B]
disp(' ')
disp('To see the solution of the system, press Enter ')
pause
X=A\B
disp('This indicates that the system has no solution or infinite number of solutions.')
warning off MATLAB:singularMatrix
disp(' ')
disp('To check the case see the reduced echelon form of the system, press Enter')
disp(' ')
pause
disp('The reduced row echelon form of the system is:')
rref([A B])
disp(' ')
disp(' The system has infinite number of solutions, to see one of them, press Enter')
pause
X=pinv(A)*B
disp('TO CLEAR SCREEN, PRESS ENTER')
pause
clc
