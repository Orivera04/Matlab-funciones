genfig('Single-input Mamdani fuzzy model: MFs');

point_n = 100;
x = linspace(-10, 10, point_n);

ante_param = [-20 -15 -6 -3;
		-6 -3 3 6;
		3 6 15 20];

ante_mf = zeros(3, point_n);
ante_mf(1, :) = trap_mf(x, ante_param(1, :));
ante_mf(2, :) = trap_mf(x, ante_param(2, :));
ante_mf(3, :) = trap_mf(x, ante_param(3, :));

subplot(211);
plot(x', ante_mf');
axis([-inf inf 0 1.2]);
xlabel('X'); ylabel('Membership Grades');
text(-7, 1.1, 'small');
text(0, 1.1, 'medium');
text(7, 1.1, 'large');

y = linspace(0, 10, point_n);
cons_param = [-2.46 -1.46 1.46 2.46;
		1.46 2.46 5 7;
		5 7 13 15];

cons_mf = zeros(3, point_n);
cons_mf(1, :) = trap_mf(y, cons_param(1, :));
cons_mf(2, :) = trap_mf(y, cons_param(2, :));
cons_mf(3, :) = trap_mf(y, cons_param(3, :));

subplot(212);
plot(y', cons_mf');
axis([-inf inf 0 1.2]);
xlabel('Y'); ylabel('Membership Grades');
text(1, 1.1, 'small');
text(3.5, 1.1, 'medium');
text(7.5, 1.1, 'large');

set(findobj(gcf, 'type', 'text'), 'hori', 'center');

output = zeros(size(x));
qualified_cons_mf = zeros(3, point_n);
for i = 1:point_n,
	w1 = trap_mf(x(i), ante_param(1, :));
	w2 = trap_mf(x(i), ante_param(2, :));
	w3 = trap_mf(x(i), ante_param(3, :));
	qualified_cons_mf(1, :) = min(w1, cons_mf(1, :));
	qualified_cons_mf(2, :) = min(w2, cons_mf(2, :));
	qualified_cons_mf(3, :) = min(w3, cons_mf(3, :));
	overall_out_mf = max(qualified_cons_mf);
	output(i) = defuzzy(y, overall_out_mf, 1);
end

genfig('Single-input Mamdani fuzzy model: input-output curve');
plot(x, output);
axis([min(x) max(x) min(y) max(y)]);
xlabel('X'); ylabel('Y');
return;

% The following is for augmentation of side MFs
y1 = linspace(-2.46, 15); 
cons_mf(1, :) = trap_mf(y1, cons_param(1, :));
cons_mf(2, :) = trap_mf(y1, cons_param(2, :));
cons_mf(3, :) = trap_mf(y1, cons_param(3, :));
figure
subplot(212);
plot(y1', cons_mf');
axis([-inf inf 0 1.2]);
xlabel('Y'); ylabel('Membership Grades');

output1 = zeros(size(x));
for i = 1:point_n,
	w1 = trap_mf(x(i), ante_param(1, :));
	w2 = trap_mf(x(i), ante_param(2, :));
	w3 = trap_mf(x(i), ante_param(3, :));
	qualified_cons_mf(1, :) = min(w1, cons_mf(1, :));
	qualified_cons_mf(2, :) = min(w2, cons_mf(2, :));
	qualified_cons_mf(3, :) = min(w3, cons_mf(3, :));
	overall_out_mf = max(qualified_cons_mf);
	output1(i) = defuzzy(y1, overall_out_mf, 1);
end

figure
plot(x, output1);
xlabel('X'); ylabel('Y');
axis([min(x) max(x) min(y) max(y)]);

