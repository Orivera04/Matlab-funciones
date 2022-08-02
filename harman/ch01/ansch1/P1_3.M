% P1_3.M MATLAB functions for f(x) 
% We will scan through the manual and list a few commands
% For trigonometric functions, the value is in radians
% The list does not include some functions that make more sense for
%  vectors and matrices.
%
% Try help elfun for a longer list
%
diary p1_3.dir
echo on
x=2.0
abs(x)  % Same value since x>0.
acos(x)	% If you don't understand this answer, review complex values
acosh(x) %  There are other functions such as asin, asinh, atan, etc.
angle(x) %  This is zero for a real number
ceil(x)  % Other functions are fix, floor and round (Try these for x=2.1) 
cos(x)  % Other functions are cosh, cot, coth, sin, tan, etc.
erf(x) % This is an integral; others are expint and gamma
exp(x)
gamma(x) % For an integer value, this is (n-1) factorial
imag(x)  % This is zero for x real 
log(x) % Others are log10 and log2
sqrt(x)
echo off
diary off