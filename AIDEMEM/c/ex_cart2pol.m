t = logspace(eps, 2*pi, 10000);
r =  log(t); 
[x, y] = pol2cart(r, t);
plot(x, y); 
title('spirale logarithmique', 'fontsize', 14)