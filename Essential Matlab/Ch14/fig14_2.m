x = 0:pi/20:4*pi;
plot(x, sin(x),'k')
hold on
plot(x, exp(-0.1*x).*sin(x), 'ok')
hold off
hkids = get(gca,'child');
set(hkids(1), 'marker', '*')
set(hkids(2), 'linew', 4)

