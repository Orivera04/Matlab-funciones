f = inline('sin(-x.^2-2.*y.^2)', 'x', 'y');
int = dblquad(f, 0, 1, 0, pi)
int = dblquad(f, 0, 1, 0, pi, 1.0E-10,  'quadl')
int = dblquad(f, 0, 1, 0, pi, 1.0E-4)
