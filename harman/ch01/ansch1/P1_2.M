% P1_2.M Function evaluation
diary p1_2.dir
echo on
clear		% Clear the workspace
% (a) 
x=-2
f1=x^2+x-3
% (b)  
x=[-2 1 4]
f2=x.*(x+2).*(x-1)./((x+1).*(x-2))  % Note the grouping and (.)
% (c)
x=4
f3=(3*x^(3/2)+20*sqrt(x))^(1/3)
echo off
diary off