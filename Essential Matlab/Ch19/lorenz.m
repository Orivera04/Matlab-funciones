function f = lorenz(t, x)
f = zeros(3,1);                        
f(1) = 10 * (x(2) - x(1));             
f(2) = -x(1) * x(3) + 28 * x(1) - x(2);
f(3) = x(1) * x(2) - 8 * x(3) / 3;     