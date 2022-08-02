[x, y] = meshgrid(-3:0.3:3, -3:0.3:3);
z = x .* exp(-x.^2 - y.^2);
subplot(2,2,1), mesh(z)
subplot(2,2,2), mesh(z), view(-37.5,70)
subplot(2,2,3), mesh(z), view(37.5,-10)
subplot(2,2,4), mesh(z), view(0,0)

