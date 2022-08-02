% function trapez_v(f,h) integrates a function defined in 
% vector f with interval size, h.  
% Copyright S. Nakamura, 1995
function I = trapez_v(f, h)
I = h*(sum(f) - (f(1) + f(length(f)))/2);

