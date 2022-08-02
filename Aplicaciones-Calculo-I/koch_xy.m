%KOCH: Plots 'Koch Curve' Fractal
% Get the coorsinates x,y from koch.m
%Modified by Per Sundqvist june 2004
function [x,y]=koch_xy(n)
global X1 Y1 X5 Y5 i
i=1;
koch(n)
Nx=length(X1);
x=X1;x(Nx+1)=X5(Nx);
y=Y1;y(Nx+1)=Y5(Nx);
x=x/10^n;
y=y/10^n;

