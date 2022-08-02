f=inline('x^2-y^2'); f=vectorize(f);
x0=linspace(-2,2,15);
y0=linspace(-2,2,10);
[X0,Y0]=meshgrid(x0,y0);
x1=linspace(-2,2,40);
y1=linspace(-2,2,40);
[X1,Y1]=meshgrid(x1,y1);
hold on % solapamos dos dibujos
%surf(X0,Y0,f(X0,Y0),'facecolor','none','edgecolor','k',...
%'marker','o', 'markersize',6,'MarkerFaceColor','k', 'linewidth',2);
surf(X1,Y1,f(X1,Y1),'facecolor','interp', 'facealpha',0.5,...
'edgecolor','none');
colorbar
colormap('bone')