
% A program of type script
% Program name is Q608.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'Q608' in the command window.

clear all
clc
disp(' ');
disp('This program answers question 8 of chapter 6')
disp(' ')
disp('----------------------------------------------------------------------')
disp(' ')
disp('To see A and B matrices that are describing the system, press Enter')
pause
disp(' ')
A=[9 8 -5;7 5 6;5 7 3;2 1 4]
B=[3 11 10 8]'

disp('The system is overdetermined, to see the least squares solution , press Enter')
pause
X=A\B
disp('TO CLEAR SCREEN, PRESS ENTER')
pause
clc
