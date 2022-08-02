[x y] = meshgrid(-2.1:0.15:2.1, -6:0.15:6);
z = 80 * y.^2 .* exp(-x.^2 - 0.3*y.^2);
mesh(z),grid off