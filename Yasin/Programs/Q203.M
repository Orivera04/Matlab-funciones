
% A program of type script
% Program name is Q203.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'Q203' in the command window.

clear all
clc
disp(' ');
disp('This program answers question 3 of chapter 2')
disp('----------------------------------------------------------------------')
disp(' ')
disp('To see the matrix P, press Enter')
pause
disp(' ')
P=[0:pi/4:pi;1:5;5:-1:1;2:2:10]
disp(' ')
disp('To see the transpose of  P, press Enter')
pause
disp(' ')
P'
disp(' ')
disp('To see the result of flipping the matrix  P from left to right, press Enter')
pause
clc
disp(' ')
disp('This is the matrix P')
P
disp(' ')
disp('This is the result of flipping the matrix P from left to right')
fliplr(P)
disp(' ')
disp('To see the result of flipping the matrix  P from up to down, press Enter')
pause
clc
disp(' ')
disp('This is the matrix P')
P
disp(' ')
disp('This is the result of flipping the matrix P from up to down')
flipud(P)
disp(' ')
disp('To see the result of rotating the matrix  P 270 degrees, press Enter')
pause
clc
disp(' ')
disp('This is the matrix P')
P
disp(' ')
disp('This is the result of rotating the matrix P 270 degrees')
rot90(P,3)
disp(' ')
disp('To see the result of changing places of lines one and four, press Enter')
pause
clc
disp(' ')
disp('This is the matrix P')
P
disp(' ')
A=P;
disp('This is the result of changing places of lines one and four')
A([4 2 3 1],:)
disp('To see the result of changing places of columns two and three, press Enter')
pause
clc
disp(' ')
disp('This is the matrix P')
P
disp(' ')
A=P;
disp('This is the result of changing places of columns two and three')
A(:,[1 3 2 4 5])

disp('To see the result of eleminating rows two and four , press Enter')
pause
clc
disp(' ')
disp('This is the matrix P')
P
disp(' ')
A=P;
disp('This is the result of eleminating rows two and four of matrix P')
A([2 4],:)=[]

disp('To see the two sub-matrices P1, from rows 1&2 and P2 from rows 3&4, press Enter')
pause
clc
disp(' ')
disp('This is the matrix P')
P
disp(' ')
disp('This the matrix P1, consisting from rows 1&2')
P1=P([1 2],:)
disp(' ')
disp('This the matrix P2, cosisting from rows 3&4 ')
P2=P([3 4],:)
disp(' ')
disp('To see forming the original matrix again from the sub-matrices P1 and P2, press Enter')
pause
clc
disp(' ')
disp('This is P1')
P1
disp('This is P2')
P2
disp('This the matrix P, formed from P1 & P2')
P=[P1;P2]
 disp(' ')
disp('TO CLEAR SCREEN, PRESS ENTER')
pause
clc

