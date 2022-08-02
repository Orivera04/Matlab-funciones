x = (0:0.05:10)';

all_mf1 = [];
all_mf2 = [];

for j = 1:1:5,
	all_mf1 = [all_mf1 sig_mf(x, [j, 5])];
end
for j = 0.5:1:5,
	all_mf2 = [all_mf2 exts_mf(x, [2, 8, j])];
end

subplot(221); plot(x, all_mf1);
xlabel('y'), ylabel('Membership Grade');
title('(a) Sigmoidal MFs');
axis([min(x) max(x) 0 1.2]);

subplot(222); plot(x, all_mf2);
xlabel('y'), ylabel('Membership Grade');
title('(b) S MFs');
axis([min(x) max(x) 0 1.2]);
