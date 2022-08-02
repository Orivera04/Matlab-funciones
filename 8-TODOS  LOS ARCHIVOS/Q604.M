
% A program of type script
% Program name is Q604.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'Q604' in the command window.

clear all
clc
disp(' ');
disp('This program answers question 4 of chapter 6')
disp(' ')
disp('----------------------------------------------------------------------')
disp(' ')
disp('To see how polynomials P1 and P2 are represnted in MATLAB, press Enter')
pause
disp(' ')
P1 = [7 -3 36]
P2 = [1 0 -9 0]
disp('To find the zeros of P1, press Enter')
pause
roots(P1)
disp(' ')
disp('To find the zeros of P2, press Enter')
pause
roots(P2)

disp('To find the integral of P1, press Enter')
pause
polyint(P1)

disp('To find the integral of P2, press Enter')
pause
polyint(P2)

disp('To find the representation of the polynomial P, that is the product of P1 and P2, press Enter')
pause
P=conv(P1,P2)

disp('To find the representation of the polynomial that is P1/P2, press Enter')
pause
[q,r]=deconv(P1,P2)

disp('To find the partial fraction representation of P1/P2, press Enter')
pause
[r,p,k]=residue(P1,P2)

disp('TO CLEAR SCREEN, PRESS ENTER')
pause
clc
