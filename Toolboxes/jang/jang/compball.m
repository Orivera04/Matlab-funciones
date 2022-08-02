[x, y, z] = sphere;
ballH = mesh(x, y, z);
set(ballH, 'facecolor', 'none');
axis square; axis off;

data_n = 6;

center1 = [-0.3 0 1]; center1 = center1/norm(center1);
cluster1 = ones(data_n, 1)*center1 + (rand(data_n, 3)-0.5)/2;
leng = sum(cluster1'.^2).^0.5;
cluster1 = diag(1./leng)*cluster1;
cluster1H = line(cluster1(:,1), cluster1(:,2), cluster1(:,3));
set(cluster1H, 'linestyle', '.', 'markersize', 20);

center2 = [-1 0 0]; center2 = center2/norm(center2);
cluster2 = ones(data_n, 1)*center2 + (rand(data_n, 3)-0.5)/2;
leng = sum(cluster2'.^2).^0.5;
cluster2 = diag(1./leng)*cluster2;
cluster2H = line(cluster2(:,1), cluster2(:,2), cluster2(:,3));
set(cluster2H, 'linestyle', '.', 'markersize', 20);

center3 = [-0.1 -0.5 -0.2]; center3 = center3/norm(center3);
cluster3 = ones(data_n, 1)*center3 + (rand(data_n, 3)-0.5)/2;
leng = sum(cluster3'.^2).^0.5;
cluster3 = diag(1./leng)*cluster3;
cluster3H = line(cluster3(:,1), cluster3(:,2), cluster3(:,3));
set(cluster3H, 'linestyle', '.', 'markersize', 20);

center4 = [0.2 -0.3 0.1]; center4 = center4/norm(center4);
cluster4 = ones(data_n, 1)*center4 + (rand(data_n, 3)-0.5)/2;
leng = sum(cluster4'.^2).^0.5;
cluster4 = diag(1./leng)*cluster4;
cluster4H = line(cluster4(:,1), cluster4(:,2), cluster4(:,3));
set(cluster4H, 'linestyle', '.', 'markersize', 20);

line1H=line([0 center1(1)],[0 center1(2)],[0 center1(3)],'linewidth',2);
line2H=line([0 center2(1)],[0 center2(2)],[0 center2(3)],'linewidth',2);
line3H=line([0 center3(1)],[0 center3(2)],[0 center3(3)],'linewidth',2);
line4H=line([0 center4(1)],[0 center4(2)],[0 center4(3)],'linewidth',2);
w1H = line(center1(1), center1(2), center1(3), ...
	'linestyle','x', 'markersize',10, 'linewidth',2, 'color','c');
w2H = line(center2(1), center2(2), center2(3), ...
	'linestyle','x', 'markersize',10, 'linewidth',2, 'color','c');
w3H = line(center3(1), center3(2), center3(3), ...
	'linestyle','x', 'markersize',10, 'linewidth',2, 'color','c');
w4H = line(center4(1), center4(2), center4(3), ...
	'linestyle','x', 'markersize',10, 'linewidth',2, 'color','c');
