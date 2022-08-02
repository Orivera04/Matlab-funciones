function [b, steps] = bisect(f,x,tol)
% BISECT:  zero of a function of one
% variable via the bisection method.
% bisect(f,x) returns a zero of the
% function f.  f is a function
% handle or a string with the name of a
% function.  x is an array of length 2;
% f(x(1)) and f(x(2)) must differ in
% sign.
%
% An optional third input argument sets
% a tolerance for the relative accuracy
% of the result.  The default is eps.
% An optional second output argument
% gives a matrix containing a trace of
% the steps; the rows are of the form
% [c f(c)].

if (nargin < 3)
    % default tolerance
    tol = eps ;
end
trace = (nargout == 2) ;
if (ischar(f))
    f = str2func(f) ;
end
a = x(1) ;
b = x(2) ;
fa = f(a) ;
fb = f(b) ;
if (trace) 
    steps = [a fa ; b fb] ;
end
% main loop
while (abs(b-a) > 2*tol*max(abs(b),1))
    c = a + (b-a)/2 ;
    fc = f(c) ;
    if (trace)
        steps = [steps ; [c fc]] ;
    end
    if (fb > 0) == (fc > 0)
        b = c ;
        fb = fc ;
    else
        a = c ;
        fa = fc ;
    end
end
