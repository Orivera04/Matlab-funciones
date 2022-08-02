function [X,Y]=cuad(x,y,e,a);
r=e*sqrt(2);
b=pi/4-a;
X=[x-r*sin(b),x+r*cos(b),x+r*sin(b),x-r*cos(b),x-r*sin(b)];
Y=[y-r*cos(b),y-r*sin(b),y+r*cos(b),y+r*sin(b),y-r*cos(b)];
