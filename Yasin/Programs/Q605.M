
% A program of type script
% Program name is Q605.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'Q605' in the command window.

clear all
clc
disp(' ');
disp('This program answers question 5 of chapter 6')
disp(' ')
disp('----------------------------------------------------------------------')
disp(' ')
disp('To see A and B matrices that are describing the system, press Enter')
pause
disp(' ')
A=[1 1 -3;2 4 -9;2 -2 3]
B=[0 0 3]'
disp('To see the augmentd matrix, press Enter')
pause
[A B]
disp(' ')
disp('To see the reduced row echelon form of the system, press Enter')
pause
rref([A B])
disp(' ')
disp(' To see the solution of this system, press Enter')
pause
X=A\B


% pause
% roots(P1)
% disp(' ')
% disp('To find the zeros of P2, press Enter')
% pause
% roots(P2)
% 
% disp('To find the integral of P1, press Enter')
% pause
% polyint(P1)
% 
% disp('To find the integral of P2, press Enter')
% pause
% polyint(P2)
% 
% disp('To find the representation of the polynomial P, that is the product of P1 and P2, press Enter')
% pause
% P=conv(P1,P2)
% 
% disp('To find the representation of the polynomial that is P1/P2, press Enter')
% pause
% [q,r]=deconv(P1,P2)
% 
% disp('To find the partial fraction representation of P1/P2, press Enter')
% pause
% [r,p,k]=residue(P1,P2)
% 
% disp('TO CLEAR SCREEN, PRESS ENTER')
% pause
% clc
