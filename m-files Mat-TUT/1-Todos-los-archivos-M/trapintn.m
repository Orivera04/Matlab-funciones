function intsum = trapintn(fnh, lowrange,highrange, n)
% trapintn approximates area under a curve f(x) from 
%  a to b using a trapezoid with n intervals
% Format: trapintn(handle of f, a, b, n) 
intsum = 0;
increm = (highrange - lowrange)/n;
for a = lowrange: increm : highrange - increm
    b = a + increm;
    intsum = intsum + (b-a) * (fnh(a) + fnh(b))/2;
end
end
