% Illustration of convex MFs
% J.-S. Roger Jang, 1993

x = 0:1:100;
mf = gbell_mf(x, [20, 2, 25]);
index = find(mf >= 0.5);
new_mf = mf(index) - 0.5;
new_mf = new_mf/max(new_mf);
new_x = x(index);
subplot(221);
plot(new_x, new_mf);
axis([-inf inf 0 1.2]);
ylabel('Membership Grades');
title('(a) Two Convex Fuzzy Sets');
hold on;
mf = gbell_mf(x, [5, 2, 75]);
plot(x, mf);
hold off;
set(gca, 'xticklabels', []);

subplot(222);
mf1 = gbell_mf(x, [15, 3, 60]);
mf2 = gbell_mf(x, [10, 2, 30]);
new_mf = mf1+0.4*mf2;
new_mf = new_mf/max(new_mf);
plot(x, new_mf);
axis([-inf inf 0 1.2]);
ylabel('Membership Grades');
title('(b) A Nonconvex Fuzzy Set');
axis;
set(gca, 'xticklabels', []);
