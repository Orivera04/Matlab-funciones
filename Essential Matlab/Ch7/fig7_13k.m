subplot(2,2,1)
[x y ] = meshgrid(-8 : 1 : 8);
r = sqrt(x.^2 + y.^2) + eps;
z = sin(r) ./ r;
ribbon(z),grid off
subplot(2,2,3)
t = 0:pi/40:4*pi;
y1 = sin(t);
y2 = exp(-0.2*t).*sin(2*t);
y = [y1; y2];
ribbon(t', y', 0.1),grid off
