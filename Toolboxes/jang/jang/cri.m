%	Compositional rule of inference

%	Copyright by Jyh-Shing Roger Jang, 6-2-93.
%	(Tested on Matlab version 4.0a, HP workstation)

n = 31; m = 31;
x = linspace(0, 10, n)';
y = linspace(0, 40, m)';
coef = [-0.5; 8; 0];
y_val = polyval(coef, x);
subplot(221);
plot(x,y_val);
xlabel('X'); ylabel('Y'); title('A Crisp Relation');

z1 = zeros(m, n); z2 = zeros(m, n);


for i=1:n,
	a = 4; b = 3; c = y_val(i);
	z1(:, i) = gbell_mf(y, [a, b, c]);
end

for i=1:n,
	a = 1; b = 3; c = 5;
	z2(i,:) = gbell_mf(x', [a, b, c]);
end

subplot(222);
pcolor(x, y, z1);
shading interp;
colormap(gray);
xlabel('X'); ylabel('Y'); title('A Fuzzy Relation');

figure;

subplot(221);
mesh(x, y, z1)
set(gca, 'box', 'on');
view(-20, 60);
xlabel('X'); ylabel('Y'); zlabel('Membership Grades');
title('(a) Fuzzy Relation F on X and Y');

subplot(222);
mesh(x, y, z2)
set(gca, 'box', 'on');
view(-20, 60);
xlabel('X'); ylabel('Y'); zlabel('Membership Grades');
title('(b) Cylindrical Extension of A');
colormap('default');

intersection = min(z1, z2);
subplot(223);
mesh(x, y, min(z1, z2))
set(gca, 'box', 'on');
view(-20, 60);
xlabel('X'); ylabel('Y'); zlabel('Membership Grades');
title('(c) Minimum of (a) and (b)');

projection = intersection;
for i = 1:m,
	maximum = -10e6;
	for j=n:-1:1,
		if (projection(i,j) > maximum)
			maximum = projection(i,j);
		else
			projection(i,j) = maximum;
		end
	end
end
		
subplot(224);
mesh(x, y, projection)
set(gca, 'box', 'on');
view(-20, 60);
xlabel('X'); ylabel('Y'); zlabel('Membership Grades');
title('(d) Projection of (c) onto Y');
