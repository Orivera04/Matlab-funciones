% A program of type script
% Program name is ex302.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'ex302' in the command window.
clear all
clc
disp(' ')
disp('This program shows you some Array operations')
disp('----------------------------------------------------------------------')
n=input('Type a number and press Enter    ');
disp(' ')
disp('Two matrices A & B will be shown, to see them press enter')
disp(' ')
pause
clc
A=fix(10*rand(n))
B=fix(10*rand(n))

disp('To generate a complex matrix C from these two matrices , press Enter')
pause
clc
A
B
C=complex(A,B)

disp(' ')
disp('To find the absolute value (magnitude) of the elements of  C ,press Enter')
pause
clc
C
abs(C)

disp(' ')
disp('To find the phase angle of the elements of  C ,press Enter')
pause
clc
C
angle(C)

disp(' ')
disp('To find the real part of the elements of  C ,press Enter')
pause
clc
C
real(C)

disp(' ')
disp('To find the imaginary part of the elements of  C ,press Enter')
pause
clc
C
imag(C)

disp(' ')
disp('To find the sine the elements of  A ,press Enter')
pause
clc
A
sin(A)

disp(' ')
disp('To find the natural logarithm of the elements of  A ,press Enter')
pause
clc
A
log(A)

disp(' ')
disp('To find the elements of A raised to power 2  ,press Enter')
pause
clc
A
power(A,2)

disp(' ')
disp('To find the number 2 raised to the power elements of A ,press Enter')
pause
clc
A
power(2,A)

disp(' ')
disp('To see the result of multiplying the elements of A and the elements of B (array multiplication), press Enter')
pause
clc
A
B
times(A,B)



disp(' ')
disp('To see the result of the right array division of A and  B , press Enter')
pause
clc
A
B
rdivide(A,B)

disp(' ')
disp('To see the result of left array division of A and  B , press Enter')
pause
clc
A
B
ldivide(A,B)



disp('TO CLEAR SCREEN, PRESS ENTER')
pause
clc


