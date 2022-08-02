
% A program of type script
% Program name is Q610.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'Q610' in the command window.

clear all
clc
disp(' ');
disp('This program answers question 10 of chapter 6')
disp(' ')
disp('To run this program, the file def610.m, that defines the error function, must be in the work-directory')
disp(' ')
disp('----------------------------------------------------------------------')
disp(' ')
disp('To see the initial values, press Enter')
pause
V=[0 0]
disp('to find the solution, press Enter')
pause
X=fminsearch(@def610,V)
disp(' ')
disp('TO CLEAR SCREEN, PRESS ENTER')
pause
clc
