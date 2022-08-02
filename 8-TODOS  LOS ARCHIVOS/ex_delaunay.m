delete(gcf)
x = fix(rand(1, 10)*300); y = fix(rand(1, 10)*100);
tri = delaunay(x, y);
h1 = trimesh(tri,x,y,zeros(size(x))); view(2); hold on; 
h2 = plot(x,y,'o'); set(gca,'box','on'); axis equal
[vx, vy] = voronoi(x,y,tri);
h3 = plot(vx,vy,'b:'); axis([-50 350 -50 150]);
set(h3, 'linewidth',4)
set(gca,'box','on','fontsize', 14);
h=legend([h2, h1, h3(1)],'Points de données',...
       'Triangulation de Delaunay', 'diagramme de Voronoï');
