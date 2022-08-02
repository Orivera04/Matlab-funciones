
% A program of type script
% Program name is Q603.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'Q603' in the command window.

clear all
clc
disp(' ');
disp('This program answers question 3 of chapter 6')
disp(' ')
disp('----------------------------------------------------------------------')
disp(' ')
disp('To see x and f(x) vectors, press Enter')
pause
disp(' ')
x=0:3
y=[5 11 15 24]
disp(' ')
disp('To find the polynomial that represents this relation, press Enter')
pause
disp(' ')
F=polyfit(x,y,3)
disp(' ')
disp('To find the value of F(2.5), press Enter')
pause
disp(' ')
F1=polyval(F,2.5)
disp(' ')
disp('To find the value of the first derivative at x=2, press Enter')
pause
disp(' ')
polyval(polyder(F),2)

disp(' ')
disp('To find the value of the second derivative at x=2, press Enter')
pause
disp(' ')
polyval(polyder(polyder(F)),2)

disp('TO CLEAR SCREEN, PRESS ENTER')
pause
clc
