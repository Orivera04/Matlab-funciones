
% A program of type script
% Program name is Q403.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'Q403' in the command window.

clear all
clc
disp(' ');
disp('This program answers question 3 of chapter 4')
disp('----------------------------------------------------------------------')
R=5:5:30;
V=0:10:40;
[R,V]=meshgrid(R,V)
P=[0 0 0 0 0 0;20 10 6.67 5 4 3.33;80 40 26.7 20 8 13.3;180 90 60 45 36 30;320 160 107 80 64 53.3]
surf(R,V,P)
xlabel('Resistance')
ylabel('Voltage')
title('P = f(R,V)')
zlabel('Power')
