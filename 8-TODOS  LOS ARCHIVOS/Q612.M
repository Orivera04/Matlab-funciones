
% A program of type script
% Program name is Q612.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'Q612' in the command window.

clear all
clc
disp(' ');
disp('This program answers question 12 of chapter 6')
disp(' ')
disp('To run this program, the file def612.m, that defines the differential equation, must be in the work-directory')
disp(' ')
disp('----------------------------------------------------------------------')
disp(' ')
disp('To find the solution using ode45 solver, press Enter')
pause
[t,y]=ode45(@def612,[1 2],[-1 0 -2])
disp(' ')
disp('To plot this solution, press Enter')
pause
plot(t,y(:,1))
hold
disp('To find the solution using ode23 solver, used for stiff equations, press Enter')
pause
[t,y]=ode23(@def612,[1 2],[-1 0 -2])
disp(' ')
disp('To plot this solution, press Enter')
pause
plot(t,y(:,1),'r')

disp('TO CLEAR SCREEN, PRESS ENTER')
pause
clc

