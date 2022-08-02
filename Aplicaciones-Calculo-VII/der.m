function [fx, fy] = der(f)
syms x y;
fx=diff(f,x);
fy=diff(f,y);