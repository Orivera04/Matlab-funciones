
% A program of type script
% Program name is Q406.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'Q406' in the command window.
clear all
t = 0:pi/100:2*pi
z1 = 5*exp(i*t)
z2 = 3*exp(i*t)
plot(z1)
hold
plot(z2)
axis equal

