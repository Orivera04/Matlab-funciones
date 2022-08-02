% Illustration of the extension principle
% J.-S. Roger Jang, 1993

delta = 0.02;
x1 = (-3:delta:0)';
x2 = (delta:delta:3)';
x = [x1; x2];

y1 = x1;
y2 = (x2-1).^2-1;
y = [y1; y2];

subplot(221);
plot(x, y);
axis([min(x) max(x) min(y) max(y)]);
axis('square');
hold on;
plot([-1 max(x)], [0 0], ':');
plot([-1 max(x)], [-1 -1], ':');
plot([-1 -1], [-3 0], ':');
plot([2 2], [-3 0], ':');
hold off;
xlabel('X'); ylabel('Y');
text(0, 1.2, 'y = f(x)', 'horizon', 'center');

subplot(223);
a = 1.5; b = 2; c = 0.5;
mux = gbell_mf(x, [a, b, c]);
plot(x, mux);
axis('square');
axis([min(x) max(x) 0 1.2]);
hold on;
plot([-1 -1], [0 1.2], ':');
plot([2 2], [0 1.2], ':');
hold off;
xlabel('X'); ylabel('Membership Grades');
text(0.5, 1.1, 'A', 'horizon', 'center');

y1 = (-3:delta:-1)';
y2 = (-1+delta:delta:0)';
y3 = (delta:delta:3)';
y = [y1; y2; y3];

x1 = y1;
muy1 = gbell_mf(x1, [a, b, c]);

x2_1 = y2;
muy2_1 = gbell_mf(x2_1, [a, b, c]);
x2_2 = -(y2+1).^0.5+1;
muy2_2 = gbell_mf(x2_2, [a, b, c]);
x2_3 =  (y2+1).^0.5+1;
muy2_3 = gbell_mf(x2_3, [a, b, c]);
tmp1 = max(muy2_1, muy2_2);
muy2 = max(tmp1, muy2_3);

x3 = (y3+1).^0.5+1;
muy3 = gbell_mf(x3, [a, b, c]);

muy = [muy1; muy2; muy3];
subplot(222);
plot(muy, y);
axis([0 1.2 min(y) max(y)]);
axis('square');
hold on;
plot([0 1.2], [0 0], ':');
plot([0 1.2], [-1 -1], ':');
hold off;
xlabel('Membership Grades'); ylabel('Y');
text(0.75, 1.2, 'B', 'horizon', 'center');
