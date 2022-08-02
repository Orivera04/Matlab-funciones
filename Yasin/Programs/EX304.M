% A program of type script
% Program name is ex304.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'ex304' in the command window.
clear all
clc
disp(' ')
disp('This program shows you some logical operations on matrices')
disp('----------------------------------------------------------------------')
n=input('Type a number and press Enter    ');
disp(' ')
disp('Two matrices A & B will be shown, to see them press enter')
disp(' ')
pause
clc
A=fix(10*rand(n))
B=fix(10*rand(n))
% 
 disp('To check the equality of the elements the matrices A & B, press Enter')
 pause
 clc
 A
B
A==B

 disp('To check if the elements of A are greater than the elements of B, press Enter')
 pause
 clc
 A
B
A>B

disp('To check if the elements of A are lower than or equal to the elements of B, press Enter')
 pause
 clc
 A
B
A<=B


disp('To check if the matrices A and B are equal, press Enter')
 pause
 clc
 A
B
isequal(A,B)

disp('To check if the elements of A are prime numbers, press Enter')
 pause
 clc
 A
isprime(A)

disp('To check if the elements of the columns of A are not equal to zero, press Enter')
 pause
 clc
 A
all(A)

disp('To check if any element  of the columns of A is not equal to zero, press Enter')
 pause
 clc
 A
any(A)
disp('TO CLEAR SCREEN, PRESS ENTER')
pause
 clc
 

