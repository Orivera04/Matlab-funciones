%% SECTION 8.1 - EULER'S METHOD

%%
% Here I use the function *myeuler* (from pages 104-105 of _Differential 
% Equations with MATLAB_) implementing Euler's method to solve y' = 2y - 1. 
% It takes as input the function f, the inital time tinit, the initial 
% y-value yinit, the final time value b and the number of steps n. 

syms t y
f = @(t,y) 2*y - 1

%%
% First we use step size 0.1.

[t1,y1] = myeuler(f,0,1,0.4,4); [t1,y1]

%%
% Next we use step size 0.05.

[t2,y2] = myeuler(f,0,1,0.4,8); [t2,y2]

%%
% Finally we use step size 0.025

[t3,y3] = myeuler(f,0,1,0.4,16); [t3,y3]

%%
% The exact solution is 
y = dsolve('Dy = 2*y-1, y(0) = 1','t')

%%
% Here is a table of values.  The first entry is t, followed by the
% approximate solutions evaluated at that value of t, followed by the exact
% solution evaluated at that value of t.  We build the table T a row at a
% time using a *for* loop.  We initialize T as an empty matrix.

format short
T = [ ];
for k=0:4
    A = [t1(k+1),y1(k+1),y2(2*k+1),y3(4*k+1),subs(y,'t',t1(k+1))];
    T = [T;A];
end
T

%%
% We plot the three approximate solutions and the exact solution.  

plot(t1,y1,'c'), hold on
plot(t2,y2,'r')
plot(t3,y3,'g')
ezplot(y,[0,0.4])
title 'Solutions using Eulers method and the exact solution'
legend1 = legend({'step size 0.1', 'step size 0.05', 'step size 0.025','exact'},'Position',[0.1465 0.7205 0.2171 0.1869]);
hold off

%%
% We see from both the plot and the table that the error in the approximate 
% solutions decreases as the number of steps increases, but it is still 
% fairly large.

 