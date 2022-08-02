
point_n = 101;
x = linspace(0, 1, point_n);
y = 1 - max(x, 1-x);
subplot(2,2,1); plot(x,y); axis([-inf inf -inf 0.6]);
xlabel('p1'); title('new impurity function with J = 2'); 

point_n = 20;
x = linspace(0, 1, point_n);
[xx, yy] = meshgrid(x);
ind = find(1-xx-yy < 0);
xx(ind) = nan*ind; yy(ind) = nan*ind;
zz = 1 - max(max(xx, yy), 1-xx-yy);

subplot(2,2,2); mesh(xx, yy, zz);
axis([-inf inf -inf inf -inf inf]);
xlabel('p1'); ylabel('p2'), title('new impurity function with J = 3'); 
view([60 45]);
set(gca, 'box', 'on');
%frot3d on;
