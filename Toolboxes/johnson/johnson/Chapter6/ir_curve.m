function y=ir_curve(theta,a,g)
y=phi(a*theta-g);

function val=phi(x)
val=.5*(1+erf(x/sqrt(2)));
