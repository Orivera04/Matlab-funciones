
function s = J2(x)

s = [1 1;
       2*x(1)*cos(x(1)^2 + x(2)^2)-1 2*x(2)*cos(x(1)^2 + x(2)^2)];