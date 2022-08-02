%genfig('MFs for linguistic labels');

x = (0:90)';
mf1 = gbell_mf(x, [30, 5, 0]);
mf2 = gbell_mf(x, [15, 3, 45]);
mf3 = gbell_mf(x, [30, 5, 90]);

subplot(211);
plot(x, [mf1 mf2 mf3]);

axis([-inf inf 0 1.4]);
xlabel('X = Age');
ylabel('Membership Grades');

h(1) = text(15, 1.15, 'Young');
h(2) = text(45, 1.15, 'Middle Aged');
h(3) = text(75, 1.15, 'Old');
set(h, 'horizon', 'center');

cyclesty;
