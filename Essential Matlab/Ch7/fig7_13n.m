subplot(2,2,1)
[x y] = meshgrid(-2:0.1:2);
z = x.*exp(-x.^2-y.^2);
waterfall(z),grid off
