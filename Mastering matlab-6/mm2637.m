fstr=['3*(1-x).^2.*exp(-(x.^2) - (y+1).^2)' ... 
  ' - 10*(x/5 - x.^3 - y.^5).*exp(-x.^2-y.^2)' ... 
  ' - 1/3*exp(-(x+1).^2 - y.^2)'];
subplot(2,2,1)
ezmesh(fstr)
title('Figure 26.37a: Mesh of peaks(x,y)')
subplot(2,2,2)
ezsurf(fstr)
title('Figure 26.37b: Surf of peaks(x,y)')
subplot(2,2,3)
ezcontour(fstr)
title('Figure 26.37c: Contour of peaks(x,y)')
subplot(2,2,4)
ezcontourf(fstr)
title('Figure 26.37d: Contourf of peaks(x,y)')