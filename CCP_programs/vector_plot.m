% vector_plot.m
%This file plots the column vectors of the 3x3 Hilbert matrix.

x1=[0 1];
y1=[0 1/2];
z1=[0 1/3];
x2=[0 1/2];
y2=[0 1/3];
z2=[0 1/4];
x3=[0 1/3];
y3=[0 1/4];
z3=[0 1/5];
plot3(x1,y1,z1,x2,y2,z2,x3,y3,z3)
grid on
text(1,1/2,1/3,'col 1')
text(1/2,1/3,1/4,'col 2')
text(1/3,1/4,1/5,'col3')
