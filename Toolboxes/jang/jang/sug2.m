% 2-input 1-output Sugeno FIS with gbell_mf.

% Roger Jang, 1994.

genfig('Two-input Sugeno fuzzy model: MFs');

point_n = 100;
x = linspace(-5, 5, point_n);
ante_param_x = [5 8 -5;
		5 8 5];
for i = 1:2,
	ante_mf_x(i, :) = gbell_mf(x, ante_param_x(i, :));
end

subplot(211);
plot(x', ante_mf_x');
axis([-inf inf 0 1.2]);
xlabel('X'); ylabel('Membership Grades');
text(-3, 1.1, 'Small');
text(+3, 1.1, 'Large');

y = linspace(-5, 5, point_n);
ante_param_y = [5 2 -5;
		5 2 5];
for i = 1:2,
	ante_mf_y(i, :) = gbell_mf(y, ante_param_y(i, :));
end
subplot(212);
plot(y', ante_mf_y');
axis([-inf inf 0 1.2]);
xlabel('Y'); ylabel('Membership Grades');
text(-3, 1.1, 'Small');
text(+3, 1.1, 'Large');

z = linspace(-5, 5, point_n);
cons_param = [-1 1 1;
	0 -1 3;
	-1 0 3;
	1 1 2];

set(findobj(gcf, 'type', 'text'), 'hori', 'center');

point_n = 30;
x = linspace(-5, 5, point_n);
y = linspace(-5, 5, point_n);
[xx, yy] = meshgrid(x, y);
mfx1 = gbell_mf(x, ante_param_x(1,:));
mfx2 = gbell_mf(x, ante_param_x(2,:));
mfy1 = gbell_mf(y, ante_param_y(1,:));
mfy2 = gbell_mf(y, ante_param_y(2,:));

[tmp1, tmp2] = meshgrid(mfx1, mfy1); w1 = tmp1.*tmp2;
[tmp1, tmp2] = meshgrid(mfx1, mfy2); w2 = tmp1.*tmp2;
[tmp1, tmp2] = meshgrid(mfx2, mfy1); w3 = tmp1.*tmp2;
[tmp1, tmp2] = meshgrid(mfx2, mfy2); w4 = tmp1.*tmp2;
f1 = xx*cons_param(1,1) + yy*cons_param(1,2) + cons_param(1,3);
f2 = xx*cons_param(2,1) + yy*cons_param(2,2) + cons_param(2,3);
f3 = xx*cons_param(3,1) + yy*cons_param(3,2) + cons_param(3,3);
f4 = xx*cons_param(4,1) + yy*cons_param(4,2) + cons_param(4,3);
output = (w1.*f1+w2.*f2+w3.*f3+w4.*f4)./(w1+w2+w3+w4);

genfig('Two-input Sugeno fuzzy model: input-output surface');
mesh(x, y, output);
set(gca, 'box', 'on');
axis([-inf inf -inf inf -inf inf]);
xlabel('X'); ylabel('Y'); zlabel('Z');
