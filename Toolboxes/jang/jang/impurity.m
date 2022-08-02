point_n = 101;
x = linspace(eps, 1-eps, point_n);
y1 = -x.*log(x)-(1-x).*log(1-x);
y2 = 1-x.*x - (1-x).*(1-x);

blackbg;
subplot(2,2,1); plot(x,y1); axis([-inf inf 0 0.8]);
xlabel('p1'); title('(a) Entropy Function with J = 2'); 
subplot(2,2,3); plot(x,y2); axis([-inf inf 0 0.8]);
xlabel('p1'); title('(c) Gini Index with J = 2'); 

point_n = 31;
x = linspace(eps, 1-eps, point_n);
[xx, yy] = meshgrid(x);
ind = find(1-xx-yy < eps);
xx(ind) = nan*ind; yy(ind) = nan*ind;
zz1 = -xx.*log(xx) - yy.*log(yy) - (1 - xx - yy).*log(1 - xx - yy);
zz2 = 1 - xx.*xx - yy.*yy - (1-xx-yy).*(1-xx-yy);

subplot(2,2,2); mesh(xx, yy, zz1);
axis([-inf inf -inf inf 0 1.1]);
xlabel('p1'); ylabel('p2'), title('(b) Entropy Function with J = 3'); 
view([60 45]);
set(gca, 'box', 'on');
%frot3d on;

subplot(2,2,4); mesh(xx, yy, zz2);
axis([-inf inf -inf inf 0 1.1]);
xlabel('p1'); ylabel('p2'), title('(d) Gini Index with J = 3'); 
view([60 45]);
set(gca, 'box', 'on');
%frot3d on;
