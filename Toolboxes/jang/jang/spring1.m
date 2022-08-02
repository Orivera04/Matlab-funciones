% Illustration of polynomial fitting
% Roger Jang, Oct-29-1996

x_sample = [0; 1; 2; 3; 4; 5; 6; 7; 8; 9];
y_sample  = [0; 2; 4; 6; 8; 10; 12; 14; 16; 18];
y_sample  = [0; 1.5; 3.5; 6.5; 7.5; 10.5; 11.5; 14.5; 15.5; 18.5];
x = linspace(min(x_sample), max(x_sample))';
coef1 = polyfit(x_sample, y_sample, 6);
coef2 = polyfit(x_sample, y_sample, 7);
coef3 = polyfit(x_sample, y_sample, 8);
coef4 = polyfit(x_sample, y_sample, 9);
y1 = polyval(coef1, x);
y2 = polyval(coef2, x);
y3 = polyval(coef3, x);
y4 = polyval(coef4, x);

subplot(221);
plot(x, y1, '-', x_sample, y_sample, '*');
axis([-inf inf -inf inf]);
title('Polynomial of order 6');

subplot(222);
plot(x, y2, '-', x_sample, y_sample, '*');
axis([-inf inf -inf inf]);
title('Polynomial of order 7');

subplot(223);
plot(x, y3, '-', x_sample, y_sample, '*');
axis([-inf inf -inf inf]);
title('Polynomial of order 8');

subplot(224);
plot(x, y4, '-', x_sample, y_sample, '*');
axis([-inf inf -inf inf]);
title('Polynomial of order 9');
