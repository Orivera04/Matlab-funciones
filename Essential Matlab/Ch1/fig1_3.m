[x y ] = meshgrid(-8 : 0.5 : 8.5);
r = sqrt(x.^2 + y.^2) + eps;
z = sin(r) ./ r;
mesh(z)