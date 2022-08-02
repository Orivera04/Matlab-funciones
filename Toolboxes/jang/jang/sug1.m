% 1-input 1-output Sugeno FIS with linear rule

% Roger Jang, 1994

genfig('Single-input Sugeno fuzzy model');

point_n = 200;
x = linspace(-10, 10, point_n);

ante_param = [6 1000 -10;
		4 1000 0;
		6 1000 10];
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
set(findobj(gcf, 'type', 'text'), 'hori', 'center');
title('(a) Antecedent MFs for Crisp Rules');

out = zeros(3, point_n);
out(1, :) = 0.1*x+6.4; 
out(2, :) = -0.5*x+4;
out(3, :) = x-2;
overall_out = sum(out.*ante_mf)./(sum(ante_mf));

max_mf = ones(3,1)*max(ante_mf);
nan_index = find(ante_mf~=max_mf);
new_out = out;
new_out(nan_index) = nan*ones(size(nan_index));

subplot(222);
plot(x', new_out');
axis([-inf inf 0 8]);
xlabel('X'); ylabel('Y');
title('(b) Overall I/O Curve for Crisp Rules');

ante_param = [6 4 -10;
		4 4 0;
		6 4 10];

ante_mf = zeros(3, point_n);
ante_mf(1, :) = gbell_mf(x, ante_param(1, :));
ante_mf(2, :) = gbell_mf(x, ante_param(2, :));
ante_mf(3, :) = gbell_mf(x, ante_param(3, :));

subplot(223);
plot(x', ante_mf');
axis([-inf inf 0 1.2]);
xlabel('X'); ylabel('Membership Grades');
text(-7, 1.1, 'small');
text(0, 1.1, 'medium');
text(7, 1.1, 'large');
title('(c) Antecedent MFs for Fuzzy Rules');
set(findobj(gcf, 'type', 'text'), 'hori', 'center');

out = zeros(3, point_n);
out(1, :) = 0.1*x+6.4; 
out(2, :) = -0.5*x+4;
out(3, :) = x-2;
overall_out = sum(out.*ante_mf)./(sum(ante_mf));

max_mf = ones(3,1)*max(ante_mf);
nan_index = find(ante_mf~=max_mf);
new_out = out;
new_out(nan_index) = nan*ones(size(nan_index));

subplot(224);
plot(x', overall_out');
axis([-inf inf 0 8]);
xlabel('X'); ylabel('Y');
title('(d) Overall I/O Curve for Fuzzy Rules');

% cycle through different line style
cyclesty;
