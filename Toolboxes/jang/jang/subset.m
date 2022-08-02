% Illustration of subsets in fuzzy sets
% J.-S. Roger Jang 1993

x = 0:100;
B = gbell_mf(x, [30, 2, 50]);
A = 0.9*gauss_mf(x, [60, 15]);
subplot(221); plot(x, A, x, B);
axis([-inf inf 0 1.2]);
title('A Is Contained in B');
ylabel('Membership Grades');
set(gca, 'xticklabels', []);
text(25, 1.0, 'B');
text(42, 0.75, 'A');
