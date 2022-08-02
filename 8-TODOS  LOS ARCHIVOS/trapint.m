function int = trapint(fnh, a, b)
% trapint approximates area under a curve f(x) from 
%  a to b using a trapezoid
% Format: trapint(handle of f, a, b)
int = (b-a) * (fnh(a) + fnh(b))/2;
end