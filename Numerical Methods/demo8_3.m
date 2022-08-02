%% Section 8.3 - The Runge-Kutta Method

%%
% In Problem Set C #16 I have asked you to implement the Runge-Kutta method
% in MATLAB.  Here I use my implementation, which I called *rungekutta*, to 
% find a numerical solution of
% 
% $$y' = 2y -1, \quad y(0) = 1.$$
% 
% *rungekutta* takes the same input as *myeuler*.


f = @(t,y) 2*y - 1;

%%
% First we use step size 0.1.
[t1,y1] = rungekutta(f, 0, 1, 0.4, 4); [t1 y1]

%%
% Next we use step size 0.05.
[t2,y2] = rungekutta(f, 0, 1, 0.4, 8); [t2 y2]

%%
% We will make a table of values at t = 0, 0.1,...,0.4.  We will include 
% the exact solution, which is 
syms t
y = dsolve('Dy = 2*y - 1, y(0) = 1', 't')

%%
% We will also include the approximate solution we had obtained with
% Euler's method using step size 0.025.

[ta,ya] = myeuler(f, 0, 1, 0.4, 16); ya
%%
% Here is the table.  The first column is t, the second ya, the third y1,
% the fourth y2 and the last y.
T = [ ]
for k = 0:4
    digits(9)
    A = [vpa(t1(k+1)),vpa(ya(4*k+1)),vpa(y1(k+1)),vpa(y2(2*k+1)),vpa(subs(y,'t',t1(k+1)))];
    T = [T;A];
end
T

%%
% We see that with step size 0.1 the Runge-Kutta method gives errors that
% are less than 1.01*10^(-5).  With step size 0.05 it gives errors that
% are less than 10^(-6).  With step size 0.025, Euler's method gives an
% error greater than 0.02 at t=0.4.

 