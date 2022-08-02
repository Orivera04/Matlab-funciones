x = (-10:0.4:10)';
y1 = sig_mf(x, [1, -5]);
y2 = sig_mf(x, [2, 5]);
y3 = sig_mf(x, [-2, 5]);

genfig('Various MFs generated via sigmoid function');

subplot(221); plot(x, y1, x, y2);
text(-5, 0.9, 'y1'); text(4, 0.6, 'y2');
axis([-inf inf 0 1.2]);
title('(a) y1 = sig(x;1,-5); y2 = sig(x;2,5)'); 

subplot(222); plot(x, y1-y2);
axis([-inf inf 0 1.2]);
title('(b) |y1 - y2|'); 

subplot(223); plot(x, y1, x, y3);
text(-4, 0.7, 'y1'); text(5, 0.7, 'y3');
axis([-inf inf 0 1.2]);
title('(c) y1 = sig(x;1,-5); y3 = sig(x;-2,5)'); 

subplot(224); plot(x, y1.*y3);
axis([-inf inf 0 1.2]);
title('(d) y1*y3');

cyclesty;
