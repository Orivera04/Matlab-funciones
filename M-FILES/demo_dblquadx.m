% This function demos the usage of the
% double integration over the regoin
% where lower and upper limits of inner
% integration could be function of the 
% variable of the outer integration.

clear all; close all;
x_lower=inline('asinh(x)'); x_upper=inline('x+1'); 
f=inline('x.*x+y','x','y'); p=51;
ymin=1; ymax=3; y0=(linspace(1,3,p))';
x1=feval(x_lower,y0);x2=feval(x_upper,y0);
fill([x1;x2(p:-1:1);x1(1,1)],[y0;y0(p:-1:1);y0(1,1)],'g','linewidth',2);
axis([0 5 0 4]); set(gca,'fontsize',16,'XTick',[0:1:5],'YTick',[1:1:4]);
text(1.2, 0.7, 'ymin=1', 'fontsize',14); text(2.5, 3.3, 'ymax=3', 'fontsize',14);
text(0.2, 2.5, 'x_{1}(y)=asinh(y)', 'fontsize',14);
text(0.2, 2.2, '[y=sinh(x)]', 'fontsize',14);
text(3.5, 2, 'x_{2}(y)=y+1', 'fontsize',14);
text(3.5, 1.8, '(y=x-1)', 'fontsize',14);
title('The domain and the double integration', 'fontsize',16);
fprintf('     press anykey to show the result  .......\n'); pause; 
Q=dblquadx(f,x_lower,x_upper,ymin,ymax,1.0e-6,[]);
text(2.2,0.5,['\int_{1}^{3}dy\int_{asinh(y)}^{y+1}dx (x^{2}+y)=',num2str(Q,'%11.4g')],'fontsize',14);