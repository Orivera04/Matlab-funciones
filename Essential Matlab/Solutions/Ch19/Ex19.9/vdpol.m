function f = vdpol(t, x, b, ep)   
f = zeros(2,1);                              
f(1) = x(2);                                 
f(2) = ep * (1 - x(1)^2) * x(2) - b^2 * x(1);