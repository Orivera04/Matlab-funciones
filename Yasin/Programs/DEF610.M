
% A program of type function
% Program name is def610.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% This defines the error function required to solve question 10 of chapter 6
% 
% This program defines the function "E=((x1)^2+(x2)^2-10*x1+8)^2+ (x1*(x2)^2+x1-10*x2+8)^2".

%
function E=def610(V)
x1=V(1)
x2=V(2)
E=((x1)^2+(x2)^2-10*x1+8)^2+ (x1*(x2)^2+x1-10*x2+8)^2