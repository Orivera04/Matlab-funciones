
% A program of type script
% Program name is ex103.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'ex103' in the command window.

clear all
clc
disp(' ')
disp('This program shows you other simple matrix operations')
disp('----------------------------------------------------------------------')
n=input('Type a number and press Enter    ');
disp(' ')
disp('Two matrices A & B  will be shown, to see them press enter')
disp(' ')
pause
clc
A=fix(10*rand(n))
B=fix(10*rand(n))
 disp('    ')
 disp('To see the product C=A*B, press Enter')
 pause
 clc
 A
 B
 C=A*B
 disp('    ')
 disp(' ')
 disp('C = A * B')
 disp(' ')
 disp('To see also the  Product D=B*A, press Enter')
 pause
 clc
 A
 B
 C
 D=B*A
disp('    ')
 disp(' ')
 disp('C = A * B')
 disp('D = B*A')
 disp(' ')
 disp(' ')
 disp('To see an Identity matrix , press Enter')
 pause
 clc
I=eye(n)
 disp(' ')
 disp('This is an identity matrix')
disp(' ')
 disp('To see the result of  multiplication by the identity matrix, press Enter' )
 pause
 clc
 disp('This is the matrix to be multiplied')
 disp(' ')
 A
 disp(' ')
 disp('This is the identity matrix')
 I
 disp(' ')
 disp('This is their product')
 A*I
 disp(' ')
disp('TO CLEAR SCREEN, PRESS ENTER')
pause
clc

 