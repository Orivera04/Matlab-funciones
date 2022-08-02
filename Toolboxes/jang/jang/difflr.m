% Illustration of varior L-R MFs
% J.-S. Roger Jang, 1993

x = 0:100;

mf = lr_mf(x, [65, 60, 10]);
subplot(221); plot(x, mf);
axis([-inf inf 0 1.2]);
ylabel('Membership Grades'); title('(a)');
xlabel('X');

mf = lr_mf(x, [25, 10, 40]);
subplot(222); plot(x, mf);
axis([-inf inf 0 1.2]);
ylabel('Membership Grades'); title('(b)');
xlabel('X');
