% Illustration of various MFs
% J.-S. Roger Jang

x = 0:100;

mf = tri_mf(x, [20, 60, 80]);
subplot(221); plot(x, mf);
axis([-inf inf 0 1.2]);
ylabel('Membership Grades'); title('(a) Triangular MF');
%set(gca, 'xticklabels', []);
set(gca, 'xtick', [0 20 40 60 80 100]);

mf = trap_mf(x, [10, 20, 60, 95]);
subplot(222); plot(x, mf);
axis([-inf inf 0 1.2]);
ylabel('Membership Grades'); title('(b) Trapezoidal MF');
%set(gca, 'xticklabels', []);
set(gca, 'xtick', [0 20 40 60 80 100]);

mf = gauss_mf(x, [50, 20]);
subplot(223); plot(x, mf);
axis([-inf inf 0 1.2]);
ylabel('Membership Grades'); title('(c) Gaussian MF');
%set(gca, 'xticklabels', []);
set(gca, 'xtick', [0 20 40 60 80 100]);

mf = gbell_mf(x, [20, 4, 50]);
subplot(224); plot(x, mf);
axis([-inf inf 0 1.2]);
ylabel('Membership Grades'); title('(d) Generalized Bell MF');
%set(gca, 'xticklabels', []);
set(gca, 'xtick', [0 20 40 60 80 100]);
