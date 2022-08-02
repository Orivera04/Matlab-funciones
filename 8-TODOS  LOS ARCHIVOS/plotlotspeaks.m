%Use plotlotspeaks.m to generate the .eps files:
set(0,'defaultaxeslinewidth',1,...
    'defaultlinelinewidth',1,...
    'defaultaxesfontsize',(4/3.53)*20)
[x,y,z]=peaks;
colormap(range(gray,.5,1))
clf
plot(z)
axis tight
print -deps 3d_lots1
mesh(x,y,z)
axis tight
print -deps 3d_lots2
surf(x,y,z)
shading flat
axis tight
print -deps 3d_lots3
surfl(x,y,z)
shading flat
axis tight
print -deps 3d_lots4
contour(x,y,z,'k')
axis tight
print -deps 3d_lots5
imagesc(z)
axis xy
axis tight
print -deps 3d_lots6
surfc(x,y,z)
h = findobj(gcf,'type','patch');
set(h,'edgecolor','k')
axis tight
print -deps 3d_lots7
contourf(x,y,z)
axis tight
print -deps 3d_lots8
plot3(x,y,z,'k')
hold on
contour3(x,y,z,'k')
axis tight
print -deps 3d_lots9
clf
spanplot(z)
axis tight
print -deps 3d_lots10
