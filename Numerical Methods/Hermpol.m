
function yi = Hermpol(ga, gb, dga, dgb, a, b, xi)

% Two-point cubic Hermite interpolant. Points of interpolation
% are a and b. Values of the interpolant and its first order
% derivatives at a and b are equal to fa, fb, dfa and dfb.
% Vector yi holds values of the interpolant at the points xi.

h = b - a;
t = (xi - a)./h;
t1 = 1 - t;
t2 = t1.*t1;
yi = (1 + 2*t).*t2*ga + (3 - 2*t).*(t.*t)*gb+...
   h.*(t.*t2*dga + t.^2.*(t - 1)*dgb);