
% A program of type script
% Program name is Q601.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'Q601' in the command window.

clear all
clc
disp(' ');
disp('This program answers question 1 of chapter 6')
disp(' ')
disp('To run this program, the file def601.m, that defines the function, must be in the work-directory')
disp(' ')
disp('----------------------------------------------------------------------')
disp(' ')
disp('To plot the function in the interval [-pi ,pi], press Enter')
pause
disp(' ')
fplot(@def601,[-pi pi])
grid on
disp('This function has 3 zeros, as seen from the figure')
disp(' ')
disp('To find the First zero, press Enter')
pause
Z1=fzero(@def601,[-1 -0.5])

disp(' ')
disp('To find the Second zero, press Enter')
pause
Z2=fzero(@def601,[-0.5 0.5])

disp(' ')
disp('To find the Third zero, press Enter')
pause
Z3=fzero(@def601,[2 3])
disp(' ')
disp('To find the value of this function at pi/4, press Enter')
pause
clc
feval(@def601,pi/4)

disp(' ')
disp('To find the value of the variable x in the interval [-1 1], at which the function has a minimum, press Enter')
pause
fminbnd(@def601,-1,1)

disp(' ')
disp('To find the value of this function at this minimum, press Enter')
pause
feval(@def601,ans)

disp(' ')
disp('TO CLEAR SCREEN, PRESS ENTER')
pause
clc
