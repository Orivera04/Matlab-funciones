% Problems 12.16, 12.17
%  Use trapezoidal integration to
format long
errorf=erf(1)
% Trapezoid rule, 5 points
x=linspace(0,1,5);
y=(2/sqrt(pi))*exp(-x.^(2));
errortrap= trapz(x,y)
%
% Modify the script to compute the actual error and
%  display it with comments on the screen. 
%
%  Increase the number of points and determine the accuracy.
%