% Illustration of fuzzy operations
% J.-S. Roger Jang

x = (0:1:100)';
A = gbell_mf(x, [20, 4, 40]);
B = gauss_mf(x, [70, 20]);

subplot(221); plot(x, A, x, B);
set(gca, 'xticklabels', []);
axis([-inf inf 0 1.2]);
title('(a) Fuzzy Sets A and B');
text(40, 1.1, 'A');
text(70, 1.1, 'B');

subplot(222); plot(x, 1-A);
set(gca, 'xticklabels', []);
axis([-inf inf 0 1.2]);
title('(b) Fuzzy Set "not A"');

subplot(223); plot(x, max(A,B));
set(gca, 'xticklabels', []);
axis([-inf inf 0 1.2]);
title('(c) Fuzzy Set "A OR B"');

subplot(224); plot(x, min(A,B));
set(gca, 'xticklabels', []);
axis([-inf inf 0 1.2]);
title('(d) Fuzzy Set "A AND B"');
