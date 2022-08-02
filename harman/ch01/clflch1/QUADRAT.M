function [x,Eflag] = quadrat(a,b,c)
% QUADRAT Function to solve the quadratic equation ax^2+bx+c=0
%
% CALL [x,Eflag]=quadrat(a,b,c)      % This will display x and Eflag also
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
if a ==0 &  b==0     % Error? 
	Eflag=1;    
 elseif a==0         % Linear equation?
	Eflag=0;
        x=-c/b;
 else 
 	x1=sqrt(b^2-4*a*c);
 	x(1)= (-b + x1)/(2*a);
 	x(2)= (-b -x1)/(2*a);
end
