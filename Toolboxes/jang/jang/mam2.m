genfig('Two-input Mamdani fuzzy model: MFs');

point_n = 100;
x = linspace(-5, 5, point_n);
ante_param_x = [5 8 -5;
		5 8 5];
for i = 1:2,
	ante_mf_x(i, :) = gbell_mf(x, ante_param_x(i, :));
end

subplot(311);
plot(x', ante_mf_x');
axis([-inf inf 0 1.2]);
xlabel('X'); ylabel('Membership Grades');
text(-3, 1.1, 'small');
text(+3, 1.1, 'large');

y = linspace(-5, 5, point_n);
ante_param_y = [5 2 -5;
		5 2 5];
for i = 1:2,
	ante_mf_y(i, :) = gbell_mf(y, ante_param_y(i, :));
end
subplot(312);
plot(y', ante_mf_y');
axis([-inf inf 0 1.2]);
xlabel('Y'); ylabel('Membership Grades');
text(-3, 1.1, 'small');
text(+3, 1.1, 'large');

z = linspace(-5, 5, point_n);
cons_param = [1.67 8 -5;
		1.67 8 -1.67;
		1.67 8 1.67;
		1.67 8 5];
for i = 1:4,
	cons_mf(i, :) = gbell_mf(z, cons_param(i, :));
end
subplot(313);
plot(z', cons_mf');
axis([-inf inf 0 1.2]);
xlabel('Z'); ylabel('Membership Grades');
text(-4, 1.1, 'large negative');
text(-1.5, 1.1, 'small negative');
text(+1.5, 1.1, 'small positive');
text(+4, 1.1, 'large positive');

set(findobj(gcf, 'type', 'text'), 'hori', 'center');

point_n = 15;
x = linspace(-5, 5, point_n);
y = linspace(-5, 5, point_n);
output = zeros(point_n, point_n);
for i = 1:point_n,
	for j = 1:point_n,
		mf1x = gbell_mf(x(i), ante_param_x(1, :));
		mf2x = gbell_mf(x(i), ante_param_x(2, :));
		mf1y = gbell_mf(y(j), ante_param_y(1, :));
		mf2y = gbell_mf(y(j), ante_param_y(2, :));
		w1 = min(mf1x, mf1y);
		w2 = min(mf1x, mf2y);
		w3 = min(mf2x, mf1y);
		w4 = min(mf2x, mf2y);
		qualified_cons_mf(1, :) = min(w1, cons_mf(1, :));
		qualified_cons_mf(2, :) = min(w2, cons_mf(2, :));
		qualified_cons_mf(3, :) = min(w3, cons_mf(3, :));
		qualified_cons_mf(4, :) = min(w4, cons_mf(4, :));
		overall_out_mf = max(qualified_cons_mf);
		output(i,j) = defuzzy(z, overall_out_mf, 1);
	end
end

genfig('Two-input Mamdani fuzzy model: input-output surface');
mesh(x, y, output');
set(gca, 'box', 'on');
axis([-inf inf -inf inf -inf inf]);
xlabel('X'); ylabel('Y'); zlabel('Z');

