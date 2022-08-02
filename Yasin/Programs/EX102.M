
% A program of type script
% Program name is ex102.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'ex102' in the command window.

clear all
clc
disp(' ')
disp('This program shows you some simple matrix operations')
disp('----------------------------------------------------------------------')
n=input('Type a number and press Enter    ');
disp(' ')
disp('Three matrices A ,  B & C will be shown, to see them press enter')
disp(' ')
pause
clc
A=fix(10*rand(n))
B=fix(10*rand(n))
C=A

disp('NOTE THAT MATRICES A & C ARE EQUAL')
 disp('    ')
 disp('To see A and B and their sum D, press Enter')
 pause
 clc
 A
 B
 D=A+B
 disp('    ')
 disp(' ')
 disp('D = A + B')
 disp(' ')
 disp('To see A and B and the difference (E=A-B), press Enter')
 pause
 clc
 A
 B
 E=A-B
disp('    ')
 disp(' ')
 disp('E = A - B')
 disp(' ')
 disp(' ')
disp('To see the result of multiplying a  matrix by a number, press Enter')
pause
clc
disp('This is the matrix to be multiplied')

A
x=input('Enter a number by which to multiply this matrix    ');

disp('Press Enter to see the result of this multiplication')
pause
clc
disp('The matrix, the Number and the Result of multiplication are:')

A
disp(' ')
x
disp(' ')
disp(' F = x * A ')
F=x*A
disp(' ')
disp('TO CLEAR SCREEN, PRESS ENTER')
pause
clc


