function [x1,x2]=rootquad(a,b,c)
% Solves a quadratic equation ax^2 + bx + c = 0.
%
% Example call: [x1,x2]=rootquad(a,b,c)
% Roots assigned to x1 and x2.
% The function is included as a simple illustration.
%
d=b*b-4*a*c;
x1=(-b+sqrt(d))/(2*a);
x2=(-b-sqrt(d))/(2*a);
