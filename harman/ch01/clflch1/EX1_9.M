function [x,Eflag] = quadrat(a,b,c)
%
% Function to solve the quadratic equation ax^2+bx+c=0
%
% CALL [x,Eflag]=quadrat(a,b,c)   
%
% INPUTS:  a, b, and c coefficients as real numbers
%
% OUTPUTS: x, a vector of the solutions as real or complex numbers
%	   Eflag, error condition 
%		if a=b=0, Eflag=1 since x is not defined
%		otherwise Eflag=0
%
% ALGORITHM: The quadratic formula is used in the form
%		(1) x = -b/2a +/- sqrt(b^2-4ac)/2a, if a not = 0;
%		(2) x = -c/b, if a =0 and b not = 0.
% ________________________________
%
Eflag=0;	% Assume result is correct
% (Program statements start here)
%
	