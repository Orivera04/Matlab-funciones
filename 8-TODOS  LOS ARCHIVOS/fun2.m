
function w = fun2(x);

w(1) = x(1) + x(2) - 1;
w(2) = sin(x(1)^2 + x(2)^2) - x(1);
w = w(:);