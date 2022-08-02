% Illustration of the resolution principle
% J.-S. Roger Jang, 1993

x = (0:1:100)';
a = 30;
b = 2;
c = 50;
A = gbell_mf(x, [a, b, c]);

subplot(221); plot(x, A);
axis([-inf inf 0 1.2]);
hold on;

alpha = 0.95;
x1 = c - a*((1-alpha)/alpha)^(1/(2*b));
x2 = c + a*((1-alpha)/alpha)^(1/(2*b));
plot([0 x1], [alpha, alpha], '--');
plot([x1 x2], [alpha, alpha], ':');
plot([x1 x1], [0, alpha], ':');
plot([x2 x2], [0, alpha], ':');

alpha = 0.8;
x1 = c - a*((1-alpha)/alpha)^(1/(2*b));
x2 = c + a*((1-alpha)/alpha)^(1/(2*b));
plot([0 x1], [alpha, alpha], '--');
plot([x1 x2], [alpha, alpha], ':');
plot([x1 x1], [0, alpha], ':');
plot([x2 x2], [0, alpha], ':');

alpha = 0.6;
x1 = c - a*((1-alpha)/alpha)^(1/(2*b));
x2 = c + a*((1-alpha)/alpha)^(1/(2*b));
plot([0 x1], [alpha, alpha], '--');
plot([x1 x2], [alpha, alpha], ':');
plot([x1 x1], [0, alpha], ':');
plot([x2 x2], [0, alpha], ':');

alpha = 0.4;
x1 = c - a*((1-alpha)/alpha)^(1/(2*b));
x2 = c + a*((1-alpha)/alpha)^(1/(2*b));
plot([0 x1], [alpha, alpha], '--');
plot([x1 x2], [alpha, alpha], ':');
plot([x1 x1], [0, alpha], ':');
plot([x2 x2], [0, alpha], ':');

alpha = 0.2;
x1 = c - a*((1-alpha)/alpha)^(1/(2*b));
x2 = c + a*((1-alpha)/alpha)^(1/(2*b));
plot([0 x1], [alpha, alpha], '--');
plot([x1 x2], [alpha, alpha], ':');
plot([x1 x1], [0, alpha], ':');
plot([x2 x2], [0, alpha], ':');

hold off;
title('Resolution Principle');
ylabel('Membership Grades');
