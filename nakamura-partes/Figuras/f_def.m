% Used in L10_3
function f = f_def(y, t)
a=5; c=20;
f = [y(2),  (-a*abs(y(2))*y(2) - c*y(1))]';
