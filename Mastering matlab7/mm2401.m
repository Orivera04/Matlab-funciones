% mm2401.m
x = -1:.17:2;
y=humps(x);

xx=[x;x;x];
yy=[y;zeros(size(y));y];
xx=xx(:)';
yy=yy(:)';

xi=linspace(-1,2);
yi=humps(xi);
plot(xx,yy,':',xi,yi,[-1,2],[0 0],'k')
title('Figure 24.1: Integration Approximation with Trapezoids')