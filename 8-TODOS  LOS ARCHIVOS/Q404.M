
% A program of type script
% Program name is Q404.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'Q404' in the command window.

clear all
clc
disp(' ');
disp('This program answers question 4 of chapter 4')
disp('----------------------------------------------------------------------')
disp(' ')

x=-5:0.1:5;
y=-4:0.1:4;
[x,y]=meshgrid(x,y);
z=(x.^2).*(x+y);
surf(x,y,z)
xlabel('x axis')
ylabel('y axis')
zlabel('z axis')
title('Question 4 of chapter 4')