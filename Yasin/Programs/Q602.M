
% A program of type script
% Program name is Q602.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'Q602' in the command window.

clear all
clc
disp(' ');
disp('This program answers question 2 of chapter 6')
disp(' ')
disp('----------------------------------------------------------------------')
disp(' ')
disp('To see how this function is presented in MATLAB, press Enter')
pause
disp(' ')
y=inline('x^3+4*x^2-10')
disp(' ')
disp('To see the root of the equation x^2+4*x^2-10=0, that is in the interval [1 2], press Enter')
pause
disp(' ')
x=fzero(y,[1 2])


disp('TO CLEAR SCREEN, PRESS ENTER')
pause
clc
