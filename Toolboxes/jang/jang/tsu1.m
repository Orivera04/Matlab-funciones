%genfig('Single-input Tsukamoto fuzzy model');

point_n = 100;
x = linspace(-10, 10, point_n);
ante_param = [6 4 -10;
		4 4 0;
		6 4 10];
ante_mf = zeros(3, point_n);
ante_mf(1, :) = gbell_mf(x, ante_param(1, :));
ante_mf(2, :) = gbell_mf(x, ante_param(2, :));
ante_mf(3, :) = gbell_mf(x, ante_param(3, :));

subplot(221);
plot(x', ante_mf');
axis([-inf inf 0 1.2]);
xlabel('X'); ylabel('Membership Grades');
text(-7, 1.1, 'small');
text(0, 1.1, 'medium');
text(7, 1.1, 'large');
title('(a) Antecedent MFs');
set(findobj(gcf, 'type', 'text'), 'hori', 'center');

y = linspace(0, 10, point_n);
cons_mf = zeros(3, point_n);
cons_mf(1, :) = min(1, max((y-0)/(2-0), 0));
cons_mf(2, :) = 1-min(1, max((y-4)/(6-4), 0));
cons_mf(3, :) = min(1, max((y-7)/(10-7), 0));

subplot(222);
tmp = cons_mf;
%index = find(tmp == 1); tmp(index) = nan*index;
%index = find(tmp == 0); tmp(index) = nan*index;
plot(y', tmp');
axis([-inf inf 0 1.2]);
xlabel('Y'); ylabel('Membership Grades');
text(1, 0.5, 'C1');
text(5, 0.5, 'C2');
text(8.5, 0.5, 'C3');
title('(b) Consequent MFs');
set(findobj(gcf, 'type', 'text'), 'hori', 'center');

out = zeros(3, point_n);
% get rid of repeated elements, otherwise interp1 won't take it
zz = cons_mf(1, :); yy = y;
index1 = find(diff(zz) == 0);
index2 = point_n+1-find(diff(fliplr(zz)) == 0);
index = [index1 index2];
zz(index) = []; yy(index) = [];
tmp = interp1(zz, yy, ante_mf(1, :), 'spline');
out(1, :) = tmp(:)'; 

zz = cons_mf(2, :); yy = y;
index1 = find(diff(zz) == 0);
index2 = point_n+1-find(diff(fliplr(zz)) == 0);
index = [index1 index2];
zz(index) = []; yy(index) = [];
tmp = interp1(zz, yy, ante_mf(2, :), 'spline');
out(2, :) = tmp(:)';

zz = cons_mf(3, :); yy = y;
index1 = find(diff(zz) == 0);
index2 = point_n+1-find(diff(fliplr(zz)) == 0);
index = [index1 index2];
zz(index) = []; yy(index) = [];
tmp = interp1(zz, yy, ante_mf(3, :), 'spline');
out(3, :) = tmp(:)';

overall_out = sum(out.*ante_mf)./(sum(ante_mf));

subplot(223);
plot(x', out');
axis([-inf inf 0 12]);
xlabel('X'); ylabel('Y');
title('(c) Each Rule''s Output');

subplot(224);
plot(x', overall_out');
axis([-inf inf 0 12]);
xlabel('X'); ylabel('Y');
title('(d) Overall Input-Output Curve');

cyclesty;
