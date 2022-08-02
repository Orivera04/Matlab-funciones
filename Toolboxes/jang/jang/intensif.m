% Illustration of intensifier
% J.-S. Roger Jang

x = (0:0.2:10)';
mf = tri_mf(x, [1, 3, 9]);

mf1 = inc_ctrs(mf);
mf2 = inc_ctrs(mf1);
mf3 = inc_ctrs(mf2);

subplot(211);
plot(x, [mf mf1 mf2 mf3]);
xlabel('X');
ylabel('Membership Grades');
title('Effects of Contrast Intensifier');

cyclesty;
axis([min(x) max(x) 0 1.2]);
