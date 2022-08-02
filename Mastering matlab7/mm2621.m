% mm2621.m
subplot(2,2,1)
fplot(@humps,[-.5 3])
title('Figure 26.21a: Fplot of the Humps Function')
xlabel('x')
ylabel('humps(x)')

subplot(2,2,2)
fstr='sin(x)/(x)';
ezplot(fstr,[-15,15])
title(['Figure 26.21b: ' fstr])

subplot(2,2,3)
istr='(x-2)^2/(2^2) + (y+1)^2/(3^2) - 1';
ezplot(istr,[-2 6 -5 3])
axis square
grid
title(['Figure 26.21c: ' istr])