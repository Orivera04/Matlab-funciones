
% A program of type script
% Program name is ex404.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'ex404' in the command window.
clear all
x = 0:pi/2:2*pi;
y = sin(x);
plot(x,y)
hold
x = 0:pi/4:2*pi;
y = sin(x);
plot(x,y,'r')
x = 0:pi/10:2*pi;
y = sin(x);
plot(x,y,'g')
x = 0:pi/100:2*pi;
y=sin(x);
plot(x,y,'b')
axis([0,2*pi,-1.1,1.1])
xlabel('variable x')
ylabel('sin(x)')
title('y=sin(x) at different steps')
grid on
