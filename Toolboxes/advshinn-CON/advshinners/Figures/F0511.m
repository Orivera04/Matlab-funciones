sm = linspace(0,1);
nmk = (2*pi)*(sm.*cos(asin(sm))+asin(sm));
plot(sm,nmk); grid; title('Normalized describing function for saturation');
xlabel('S/M'); ylabel('|N(M)/K1|');

