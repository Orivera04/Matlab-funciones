function [X,Y]=cuad(x,y,e,a);
% X=[x-e,x+e,x+e,x-e,x-e];
% Y=[y-e,y-e,y+e,y+e,y-e];
%X=[x-e*sqrt(2)*sin(a),x+e*sqrt(2)*sin(a),x+e*sqrt(2)*sin(a),x-e*sqrt(2)*sin(a),x-e*sqrt(2)*sin(a)];
%Y=[y-e*sqrt(2)*cos(a),y-e*sqrt(2)*cos(a),y+e*sqrt(2)*cos(a),y+e*sqrt(2)*cos(a),y-e*sqrt(2)*cos(a)];
r=e*sqrt(2);
b=pi/4-a;
X=[x-r*sin(b),x+r*cos(b),x+r*sin(b),x-r*cos(b),x-r*sin(b)];
Y=[y-r*cos(b),y-r*sin(b),y+r*cos(b),y+r*sin(b),y-r*cos(b)];

