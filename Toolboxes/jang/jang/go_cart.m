% This is the top script for running CART

% Roger Jang, 7-31-1995

close all;
point_n = 25;
for_print = 1;
[xx, yy, zz] = peaks(point_n);
trn_data = [xx(:) yy(:) zz(:)];
rule_n1 = 10;
rule_n2 = 20;
rule_n3 = 30;
cart_table10 = cartmain(trn_data, rule_n1);
cart_table20 = cartmain(trn_data, rule_n2);
cart_table30 = cartmain(trn_data, rule_n3);
uu10 = reshape(usecart([xx(:) yy(:)], cart_table10), point_n, point_n);
uu20 = reshape(usecart([xx(:) yy(:)], cart_table20), point_n, point_n);
uu30 = reshape(usecart([xx(:) yy(:)], cart_table30), point_n, point_n);

% first page
figure;
subplot(2,2,1);
surf(xx, yy, zz);
min_x = min(xx(:)); max_x = max(xx(:));
min_y = min(yy(:)); max_y = max(yy(:));
min_z = min(zz(:)); max_z = max(zz(:));
axis_limit = [min_x max_x min_y max_y min_z max_z];
axis(axis_limit);
set(gca, 'box', 'on');
xlabel('x'); ylabel('y'); zlabel('z');
title('Target Surface');

subplot(2,2,3);
pcolor(xx, yy, zz);
axis square; axis equal;
xlabel('x'); ylabel('y'); zlabel('z');
shading interp

subplot(2,2,2);
surf(xx, yy, uu10);
axis(axis_limit);
set(gca, 'box', 'on');
set(gca, 'clim', [min_z max_z]);
xlabel('x'); ylabel('y'); zlabel('z');
title(['CART Surface (', int2str(rule_n1), ' Terminal Nodes)']);

subplot(2,2,4);
pcolor(xx, yy, uu10);
axis square; axis equal;
set(gca, 'clim', [min_z max_z]);
xlabel('x'); ylabel('y'); zlabel('z');

plotrule(cart_table10);
shading interp
%set(gca, 'box', 'on');
%axis equal; axis square

% second page
figure;
subplot(2,2,1);
surf(xx, yy, uu20);
axis(axis_limit);
set(gca, 'box', 'on');
set(gca, 'clim', [min_z max_z]);
xlabel('x'); ylabel('y'); zlabel('z');
title(['CART Surface (', int2str(rule_n2), ' Terminal Nodes)']);

subplot(2,2,3);
pcolor(xx, yy, uu20);
axis square; axis equal;
set(gca, 'clim', [min_z max_z]);
xlabel('x'); ylabel('y'); zlabel('z');
plotrule(cart_table20);
shading interp

subplot(2,2,2);
surf(xx, yy, uu30);
axis(axis_limit);
set(gca, 'box', 'on');
set(gca, 'clim', [min_z max_z]);
xlabel('x'); ylabel('y'); zlabel('z');
title(['CART Surface (', int2str(rule_n3), ' Terminal Nodes)']);

subplot(2,2,4);
pcolor(xx, yy, uu30);
axis square; axis equal;
set(gca, 'clim', [min_z max_z]);
xlabel('x'); ylabel('y'); zlabel('z');
plotrule(cart_table30);
shading interp

if for_print
	figure(1); colormap(gray);
	figure(2); colormap(gray);
end
