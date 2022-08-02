% Illustration of polynomial fitting
% J.-S. Roger Jang 1993

force = [1.1; 1.9; 3.2; 4.4; 5.9; 7.4; 9.2];
leng  = [1.5; 2.1; 2.5; 3.3; 4.1; 4.6; 5.0];
x = (0:0.5:11)';
coef1 = polyfit(force, leng, 1);
coef2 = polyfit(force, leng, 2);
coef3 = polyfit(force, leng, 3);
coef4 = polyfit(force, leng, 4);
y1 = polyval(coef1, x);
y2 = polyval(coef2, x);
y3 = polyval(coef3, x);
y4 = polyval(coef4, x);

subplot(221);
plot(x, y1, '-', force, leng, '*');
axis([0 10 1 5.5]);
xlabel('Force'); ylabel('Length of Spring');
title('(a) First-order Polynomial');

subplot(222);
plot(x, y2, '-', force, leng, '*');
axis([0 10 1 5.5]);
xlabel('Force'); ylabel('Length of Spring');
title('(b) Second-order Polynomial');

subplot(223);
plot(x, y3, '-', force, leng, '*');
axis([0 10 1 5.5]);
xlabel('Force'); ylabel('Length of Spring');
title('(c) Third-order Polynomial');

subplot(224);
plot(x, y4, '-', force, leng, '*');
axis([0 10 1 5.5]);
xlabel('Force'); ylabel('Length of Spring');
title('(d) Fourth-order Polynomial');
