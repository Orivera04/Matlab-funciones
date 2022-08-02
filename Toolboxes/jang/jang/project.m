% Illustration of projection operation
% J.-S. Roger Jang, 1993

xx = -10:10;
yy = -10:10;

[x,y] = meshgrid(xx, yy);
z = exp(-x.*x/10 - y.*y/30);
[m,n] = size(z);

subplot(331); mesh(x, y, z);
view(-40, 30);
xlabel('X'); ylabel('Y'); % zlabel('membership grades');
set(gca, 'box', 'on');
title('(a) A Two-dimensional MF');

proj_x = z;
proj_y = z;

[maximum, index]=max(z);
for i=1:m,
	for j=1:n,
		if i > index(j),
			proj_x(i,j) = maximum(j);
		end
	end
end
subplot(332); mesh(x, y, proj_x);
axis('ij');
view(-40, 30);
xlabel('X'); ylabel('Y'); % zlabel('membership grades');
set(gca, 'box', 'on');
title('(b) Projection onto X');

[maximum, index]=max(z');
for i=1:m,
	for j=1:n,
		if j < index(i),
			proj_y(i,j) = maximum(i);
		end
	end
end
subplot(333); mesh(x, y, proj_y);
axis('ij');
view(-40, 30);
xlabel('X'); ylabel('Y'); % zlabel('membership grades');
set(gca, 'box', 'on');
title('(c) Projection onto Y');

% get rid of tick labels
h = findobj(gcf, 'type', 'axes');
set(h, 'xticklabels', []);
set(h, 'yticklabels', []);
