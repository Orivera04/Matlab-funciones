% CLOPT.M Find the minimum of a function input as 'fn(x(1),x(2))'
%  Input function and initial guess.
clear
fn=input('Function to minimize as a string f(x(1),x(2))=')
%
% Input the limits for minimization
xguess=input('Input the starting vector [x(1) x(2)]= ')
%
xmin=fmins(fn,xguess)	% Find minimum
% Display minimum value of function
x(1)=xmin(1);
x(2)=xmin(2);
zmin=eval(fn) 
