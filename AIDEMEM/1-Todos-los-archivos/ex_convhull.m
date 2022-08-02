x = [0 0 0.8 0.8 0]; y = [0 1 0.2 0.8 0]; 
k = convhull(x, y); 
plot(x(k),y(k),'k-');
hold on
fill(x,y,'r')
axis([-0.10 1.1 -0.1 1.1]),; axis(axis); 

xx = [0.25 0.5 0.5 0.75]; 
yy = [0.5  0.25 0.75 0.5];
ind = inpolygon(xx, yy, x, y); hold on; 
plot(xx(~ind), yy(~ind), 'r*'); set(gca,'fontsize',16)
legend('\bfenv. convexe', 'dehors' , 'dedans'); 
aire1 = polyarea(x, y); 
aire2 = polyarea(x(k), y(k));
title(['\bfaire croisé : ', num2str(aire1, 2),... 
       ', aire convexe : ', num2str(aire2, 2)], 'fontsize', 16)